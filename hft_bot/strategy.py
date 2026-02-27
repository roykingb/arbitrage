from __future__ import annotations

import asyncio
from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Dict, List

from hft_bot.binance_feed import BinanceMomentumFeed
from hft_bot.config import BotConfig
from hft_bot.logger import JsonTradeLogger
from hft_bot.models import Market, Position
from hft_bot.polymarket_cli import PolymarketCliClient


@dataclass
class BotState:
    active_positions: Dict[str, List[Position]]


class HftStrategy:
    def __init__(self, config: BotConfig, pm: PolymarketCliClient, feed: BinanceMomentumFeed, logger: JsonTradeLogger):
        self.config = config
        self.pm = pm
        self.feed = feed
        self.logger = logger
        self.state = BotState(active_positions={})

    async def run(self) -> None:
        await self.feed.start()
        while True:
            await self.step()
            await asyncio.sleep(self.config.loop_interval_seconds)

    async def step(self) -> None:
        markets = await self.pm.list_active_crypto_markets()
        positions = await self.pm.positions()
        self.state.active_positions = {}
        for p in positions:
            self.state.active_positions.setdefault(p.market_id, []).append(p)

        await self._spread_arb(markets)
        await self._late_momentum_scaling(markets)
        await self._intermarket_arb(markets)
        await self._risk_management(markets)

    async def _spread_arb(self, markets: List[Market]) -> None:
        for market in markets:
            px = await self.pm.best_prices(market.market_id)
            if px.best_ask_yes is None or px.best_ask_no is None:
                continue
            total = px.best_ask_yes + px.best_ask_no
            if total < self.config.spread_arb_threshold:
                await self._buy_both_sides(market.market_id, px.best_ask_yes, px.best_ask_no, reason=f"spread_arb_{total:.4f}")

    async def _late_momentum_scaling(self, markets: List[Market]) -> None:
        now = datetime.now(timezone.utc)
        for market in markets:
            if market.asset not in ("BTC", "ETH"):
                continue
            if market.timeframe_minutes != 5:
                continue
            seconds_left = (market.end_time - now).total_seconds()
            if not (self.config.late_entry_min_seconds <= seconds_left <= self.config.late_entry_max_seconds):
                continue

            symbol = "BTCUSDT" if market.asset == "BTC" else "ETHUSDT"
            signal = self.feed.signal(symbol)
            if signal.direction == "FLAT" or not signal.volume_spike:
                continue

            px = await self.pm.best_prices(market.market_id)
            if signal.direction == "UP" and px.best_ask_yes:
                await self._scale_in(market.market_id, "YES", px.best_ask_yes, signal)
            if signal.direction == "DOWN" and px.best_ask_no:
                await self._scale_in(market.market_id, "NO", px.best_ask_no, signal)

    async def _intermarket_arb(self, markets: List[Market]) -> None:
        grouped: Dict[str, Dict[int, List[Market]]] = {}
        for m in markets:
            grouped.setdefault(m.asset, {}).setdefault(m.timeframe_minutes, []).append(m)

        for asset, by_tf in grouped.items():
            if 5 not in by_tf or 15 not in by_tf:
                continue
            five = by_tf[5][:3]
            fifteen = by_tf[15][:1]
            if len(five) < 3 or len(fifteen) < 1:
                continue
            p5 = []
            for m in five:
                px = await self.pm.best_prices(m.market_id)
                if px.best_ask_yes is None:
                    break
                p5.append(px.best_ask_yes)
            if len(p5) < 3:
                continue
            p15 = await self.pm.best_prices(fifteen[0].market_id)
            if p15.best_ask_yes is None:
                continue

            implied_5 = sum(p5) / 3
            if p15.best_ask_yes + 0.02 < implied_5:
                await self.pm.create_limit_buy(fifteen[0].market_id, "YES", p15.best_ask_yes, self.config.default_order_usd)
                self.logger.event({"event": "intermarket_arb", "asset": asset, "action": "buy_15m_yes", "price": p15.best_ask_yes})

    async def _risk_management(self, markets: List[Market]) -> None:
        if sum(len(v) for v in self.state.active_positions.values()) > self.config.max_simultaneous_positions:
            open_orders = await self.pm.open_orders()
            for order in open_orders[:10]:
                order_id = str(order.get("id"))
                await self.pm.cancel_order(order_id)
                self.logger.event({"event": "cancel", "order_id": order_id, "reason": "position_cap"})

        for market in markets:
            px = await self.pm.best_prices(market.market_id)
            for pos in self.state.active_positions.get(market.market_id, []):
                if pos.outcome == "YES" and px.midpoint_yes and px.midpoint_yes >= self.config.take_profit_price:
                    self.logger.event({"event": "take_profit_signal", "market_id": market.market_id, "outcome": "YES", "mid": px.midpoint_yes})
                if pos.outcome == "NO" and px.midpoint_no and px.midpoint_no >= self.config.take_profit_price:
                    self.logger.event({"event": "take_profit_signal", "market_id": market.market_id, "outcome": "NO", "mid": px.midpoint_no})

    async def _scale_in(self, market_id: str, outcome: str, ask_price: float, signal) -> None:
        # multiple small buy orders in quick succession to replicate scaling-in behavior
        for _ in range(3):
            result = await self.pm.create_limit_buy(market_id, outcome, ask_price, self.config.default_order_usd)
            self.logger.event(
                {
                    "event": "momentum_scale_in",
                    "market_id": market_id,
                    "outcome": outcome,
                    "price": ask_price,
                    "size_usd": self.config.default_order_usd,
                    "signal": signal.direction,
                    "ret_1m": signal.one_minute_return,
                    "volume_spike": signal.volume_spike,
                    "result": result,
                }
            )

    async def _buy_both_sides(self, market_id: str, yes_price: float, no_price: float, reason: str) -> None:
        yes = await self.pm.create_limit_buy(market_id, "YES", yes_price, self.config.default_order_usd)
        no = await self.pm.create_limit_buy(market_id, "NO", no_price, self.config.default_order_usd)
        self.logger.event(
            {
                "event": "buy_both_sides",
                "market_id": market_id,
                "yes_price": yes_price,
                "no_price": no_price,
                "size_usd": self.config.default_order_usd,
                "reason": reason,
                "yes_result": yes,
                "no_result": no,
            }
        )
