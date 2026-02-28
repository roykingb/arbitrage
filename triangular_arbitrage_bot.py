#!/usr/bin/env python3
"""Multi-exchange triangular arbitrage scanner.

Scans each exchange independently for triangular arbitrage opportunities over all
available spot pairs, evaluating both cycle directions.
"""

from __future__ import annotations

import argparse
import asyncio
import math
import time
from dataclasses import dataclass
from typing import Dict, Iterable, List, Optional, Set, Tuple

import ccxt.async_support as ccxt


DEFAULT_EXCHANGES = ["binance", "bybit", "bitget", "okx", "gateio", "kucoin", "mexc"]
ANSI_GREEN = "\033[92m"
ANSI_RED = "\033[91m"
ANSI_YELLOW = "\033[93m"
ANSI_CYAN = "\033[96m"
ANSI_RESET = "\033[0m"


@dataclass(frozen=True)
class DirectedEdge:
    src: str
    dst: str
    market_symbol: str
    side: str  # sell_base | buy_base


@dataclass
class Opportunity:
    exchange: str
    path: Tuple[str, str, str, str]
    legs: Tuple[DirectedEdge, DirectedEdge, DirectedEdge]
    final_amount: float
    spread_pct: float


def color_spread(spread_pct: float) -> str:
    text = f"{spread_pct:+.4f}%"
    if spread_pct > 0:
        return f"{ANSI_GREEN}{text}{ANSI_RESET}"
    if spread_pct < 0:
        return f"{ANSI_RED}{text}{ANSI_RESET}"
    return text


def parse_exchanges(raw: str) -> List[str]:
    if not raw.strip():
        return list(DEFAULT_EXCHANGES)
    return [part.strip().lower() for part in raw.split(",") if part.strip()]


def get_taker_fee(exchange, market: dict, override_fee: Optional[float]) -> float:
    if override_fee is not None:
        return override_fee
    fee = market.get("taker")
    if fee is None:
        fee = exchange.fees.get("trading", {}).get("taker")
    if fee is None:
        return 0.001
    return max(0.0, float(fee))


def build_graph(exchange, markets: Dict[str, dict], tickers: Dict[str, dict], override_fee: Optional[float]):
    directed_rates: Dict[Tuple[str, str], Tuple[float, DirectedEdge]] = {}
    undirected_adj: Dict[str, Set[str]] = {}

    for symbol, market in markets.items():
        if market.get("spot") is False:
            continue
        if not market.get("active", True):
            continue
        if symbol not in tickers:
            continue

        ticker = tickers[symbol] or {}
        bid = ticker.get("bid")
        ask = ticker.get("ask")
        base = market.get("base")
        quote = market.get("quote")

        if not base or not quote:
            continue
        if bid is None or ask is None or bid <= 0 or ask <= 0:
            continue

        fee = get_taker_fee(exchange, market, override_fee)
        fee_factor = 1.0 - fee
        if fee_factor <= 0:
            continue

        # base -> quote : sell base at bid
        bq_rate = bid * fee_factor
        # quote -> base : buy base with quote at ask
        qb_rate = (1.0 / ask) * fee_factor

        directed_rates[(base, quote)] = (
            bq_rate,
            DirectedEdge(src=base, dst=quote, market_symbol=symbol, side="sell_base"),
        )
        directed_rates[(quote, base)] = (
            qb_rate,
            DirectedEdge(src=quote, dst=base, market_symbol=symbol, side="buy_base"),
        )

        undirected_adj.setdefault(base, set()).add(quote)
        undirected_adj.setdefault(quote, set()).add(base)

    return directed_rates, undirected_adj


def enumerate_triangles(adj: Dict[str, Set[str]]) -> Iterable[Tuple[str, str, str]]:
    currencies = sorted(adj.keys())
    for i, a in enumerate(currencies):
        for b in sorted(x for x in adj[a] if x > a):
            common = adj[a].intersection(adj.get(b, set()))
            for c in sorted(x for x in common if x > b):
                yield (a, b, c)


def evaluate_cycle(
    exchange_name: str,
    directed_rates: Dict[Tuple[str, str], Tuple[float, DirectedEdge]],
    cycle: Tuple[str, str, str, str],
) -> Optional[Opportunity]:
    a, b, c, d = cycle
    edge1 = directed_rates.get((a, b))
    edge2 = directed_rates.get((b, c))
    edge3 = directed_rates.get((c, d))
    if not edge1 or not edge2 or not edge3:
        return None

    r1, l1 = edge1
    r2, l2 = edge2
    r3, l3 = edge3

    final_amount = r1 * r2 * r3
    if not math.isfinite(final_amount):
        return None

    spread_pct = (final_amount - 1.0) * 100.0
    return Opportunity(
        exchange=exchange_name,
        path=cycle,
        legs=(l1, l2, l3),
        final_amount=final_amount,
        spread_pct=spread_pct,
    )


def format_leg(leg: DirectedEdge) -> str:
    action = "SELL" if leg.side == "sell_base" else "BUY"
    return f"{action} {leg.src}->{leg.dst} [{leg.market_symbol}]"


def render_exchange_report(
    exchange_name: str,
    opportunities: List[Opportunity],
    scanned_triangles: int,
    top_n: int,
) -> str:
    lines = []
    ts = time.strftime("%Y-%m-%d %H:%M:%S")
    lines.append(f"{ANSI_CYAN}[{ts}] Exchange: {exchange_name}{ANSI_RESET}")
    lines.append(f"Triangles scanned: {scanned_triangles} | Opportunities analyzed (both directions): {len(opportunities)}")

    if not opportunities:
        lines.append(f"{ANSI_YELLOW}No valid triangular cycles found with current ticker data.{ANSI_RESET}")
        return "\n".join(lines)

    ranked = sorted(opportunities, key=lambda o: o.spread_pct, reverse=True)
    show = ranked[:top_n]

    header = f"{'#':>3}  {'Cycle':<30} {'Spread':>12}   Legs"
    lines.append(header)
    lines.append("-" * max(80, len(header)))

    for idx, opp in enumerate(show, start=1):
        path = " -> ".join(opp.path)
        spread = color_spread(opp.spread_pct)
        legs = " | ".join(format_leg(leg) for leg in opp.legs)
        lines.append(f"{idx:>3}  {path:<30} {spread:>20}   {legs}")

    return "\n".join(lines)


async def scan_exchange(
    exchange_name: str,
    sem: asyncio.Semaphore,
    top_n: int,
    min_abs_spread: float,
    override_fee: Optional[float],
) -> str:
    async with sem:
        if not hasattr(ccxt, exchange_name):
            return f"{ANSI_RED}Exchange '{exchange_name}' not found in ccxt.{ANSI_RESET}"

        exchange_class = getattr(ccxt, exchange_name)
        exchange = exchange_class({"enableRateLimit": True})

        try:
            markets = await exchange.load_markets()
            tickers = await exchange.fetch_tickers()

            directed_rates, undirected_adj = build_graph(exchange, markets, tickers, override_fee)

            opportunities: List[Opportunity] = []
            triangles_count = 0

            for a, b, c in enumerate_triangles(undirected_adj):
                triangles_count += 1
                # Direction 1: a -> b -> c -> a
                d1 = evaluate_cycle(exchange_name, directed_rates, (a, b, c, a))
                if d1 and abs(d1.spread_pct) >= min_abs_spread:
                    opportunities.append(d1)

                # Direction 2: a -> c -> b -> a
                d2 = evaluate_cycle(exchange_name, directed_rates, (a, c, b, a))
                if d2 and abs(d2.spread_pct) >= min_abs_spread:
                    opportunities.append(d2)

            return render_exchange_report(exchange_name, opportunities, triangles_count, top_n)
        except Exception as exc:  # noqa: BLE001
            return f"{ANSI_RED}Exchange '{exchange_name}' scan failed: {exc}{ANSI_RESET}"
        finally:
            await exchange.close()


async def run(args) -> None:
    exchanges = parse_exchanges(args.exchanges)
    sem = asyncio.Semaphore(max(1, args.concurrency))

    while True:
        tasks = [
            scan_exchange(
                exchange_name=exchange,
                sem=sem,
                top_n=args.top,
                min_abs_spread=args.min_abs_spread,
                override_fee=args.fee,
            )
            for exchange in exchanges
        ]
        reports = await asyncio.gather(*tasks)
        print("\n" + ("=" * 120))
        print("\n\n".join(reports))
        print("=" * 120 + "\n")

        if args.once:
            break

        await asyncio.sleep(max(0.5, args.interval))


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Fast multi-exchange triangular arbitrage scanner")
    parser.add_argument(
        "--exchanges",
        default=",".join(DEFAULT_EXCHANGES),
        help="Comma-separated ccxt exchange ids (default: major CEX set)",
    )
    parser.add_argument("--top", type=int, default=20, help="Top N opportunities to print per exchange")
    parser.add_argument(
        "--min-abs-spread",
        type=float,
        default=0.0,
        help="Filter by absolute spread %% (e.g. 0.05 keeps >=0.05%% and <=-0.05%%)",
    )
    parser.add_argument(
        "--fee",
        type=float,
        default=None,
        help="Override taker fee as decimal (e.g. 0.001 for 0.1%%). If omitted, exchange/market fee is used.",
    )
    parser.add_argument("--interval", type=float, default=5.0, help="Seconds between scan loops")
    parser.add_argument("--concurrency", type=int, default=4, help="Max exchange scans in parallel")
    parser.add_argument("--once", action="store_true", help="Run one scan cycle and exit")
    return parser


def main() -> None:
    parser = build_parser()
    args = parser.parse_args()
    try:
        asyncio.run(run(args))
    except KeyboardInterrupt:
        print("Stopped by user")


if __name__ == "__main__":
    main()
