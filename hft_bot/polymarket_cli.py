from __future__ import annotations

import asyncio
import json
import shlex
from datetime import datetime, timezone
from typing import Any, Dict, List

from hft_bot.config import BotConfig
from hft_bot.models import BestPrices, Market, Position


class PolymarketCliClient:
    def __init__(self, config: BotConfig):
        self.config = config

    async def _run_json(self, template: str, **kwargs: Any) -> Any:
        cmd = template.format(cli=self.config.polymarket_cli, **kwargs)
        proc = await asyncio.create_subprocess_exec(
            *shlex.split(cmd),
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE,
        )
        out, err = await proc.communicate()
        if proc.returncode != 0:
            raise RuntimeError(f"CLI failed: {cmd}\n{err.decode()}")
        raw = out.decode().strip()
        return json.loads(raw) if raw else {}

    async def list_active_crypto_markets(self) -> List[Market]:
        data = await self._run_json(self.config.list_markets_cmd)
        markets: List[Market] = []
        for item in data:
            slug = (item.get("slug") or "").lower()
            question = (item.get("question") or "").lower()
            if not any(k in slug + " " + question for k in ["bitcoin", "ethereum", "solana", "xrp", "btc", "eth"]):
                continue
            timeframe = 5 if "5" in slug + question else 15 if "15" in slug + question else 0
            if timeframe not in (5, 15):
                continue
            end_time_str = item.get("endTime") or item.get("end_time")
            if not end_time_str:
                continue
            end_time = datetime.fromisoformat(end_time_str.replace("Z", "+00:00")).astimezone(timezone.utc)
            asset = "BTC" if "btc" in slug + question or "bitcoin" in slug + question else "ETH" if "eth" in slug + question or "ethereum" in slug + question else "OTHER"
            markets.append(
                Market(
                    market_id=str(item.get("id") or item.get("marketId")),
                    slug=slug,
                    question=item.get("question") or "",
                    end_time=end_time,
                    asset=asset,
                    timeframe_minutes=timeframe,
                )
            )
        return markets

    async def best_prices(self, market_id: str) -> BestPrices:
        ob = await self._run_json(self.config.orderbook_cmd, market_id=market_id)
        yes_asks = [float(x[0]) for x in ob.get("yes", {}).get("asks", []) if x]
        no_asks = [float(x[0]) for x in ob.get("no", {}).get("asks", []) if x]
        yes_bids = [float(x[0]) for x in ob.get("yes", {}).get("bids", []) if x]
        no_bids = [float(x[0]) for x in ob.get("no", {}).get("bids", []) if x]

        best_yes_ask = min(yes_asks) if yes_asks else None
        best_no_ask = min(no_asks) if no_asks else None
        midpoint_yes = ((max(yes_bids) + best_yes_ask) / 2) if yes_bids and yes_asks else None
        midpoint_no = ((max(no_bids) + best_no_ask) / 2) if no_bids and no_asks else None
        return BestPrices(best_yes_ask, best_no_ask, midpoint_yes, midpoint_no)

    async def create_limit_buy(self, market_id: str, outcome: str, price: float, size_usd: float) -> Dict[str, Any]:
        return await self._run_json(
            self.config.create_order_cmd,
            market_id=market_id,
            outcome=outcome,
            price=f"{price:.4f}",
            size=f"{size_usd:.2f}",
        )

    async def positions(self) -> List[Position]:
        data = await self._run_json(self.config.positions_cmd)
        out: List[Position] = []
        for item in data:
            out.append(
                Position(
                    market_id=str(item.get("marketId") or item.get("market_id")),
                    outcome=(item.get("outcome") or "YES").upper(),
                    shares=float(item.get("shares") or 0),
                    avg_price=float(item.get("avgPrice") or item.get("avg_price") or 0),
                    unrealized_pnl=float(item.get("unrealizedPnl") or item.get("unrealized_pnl") or 0),
                )
            )
        return out

    async def open_orders(self) -> List[Dict[str, Any]]:
        return await self._run_json(self.config.open_orders_cmd)

    async def cancel_order(self, order_id: str) -> Dict[str, Any]:
        return await self._run_json(self.config.cancel_order_cmd, order_id=order_id)
