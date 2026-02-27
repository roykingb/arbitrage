from __future__ import annotations

import asyncio

from hft_bot.binance_feed import BinanceMomentumFeed
from hft_bot.config import CONFIG
from hft_bot.logger import JsonTradeLogger
from hft_bot.polymarket_cli import PolymarketCliClient
from hft_bot.strategy import HftStrategy


async def amain() -> None:
    logger = JsonTradeLogger(CONFIG.log_file)
    pm = PolymarketCliClient(CONFIG)
    feed = BinanceMomentumFeed(CONFIG)
    strategy = HftStrategy(CONFIG, pm, feed, logger)
    await strategy.run()


if __name__ == "__main__":
    asyncio.run(amain())
