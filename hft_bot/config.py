from __future__ import annotations

import os
from dataclasses import dataclass
from typing import Tuple

from dotenv import load_dotenv


load_dotenv()


@dataclass(frozen=True)
class BotConfig:
    polymarket_cli: str = os.getenv("POLYMARKET_CLI", "polymarket-cli")
    loop_interval_seconds: float = float(os.getenv("LOOP_INTERVAL_SECONDS", "2"))
    default_order_usd: float = float(os.getenv("DEFAULT_ORDER_USD", "24"))
    max_simultaneous_positions: int = int(os.getenv("MAX_SIMULTANEOUS_POSITIONS", "50"))
    min_simultaneous_positions: int = int(os.getenv("MIN_SIMULTANEOUS_POSITIONS", "20"))
    spread_arb_threshold: float = float(os.getenv("SPREAD_ARB_THRESHOLD", "0.99"))
    spread_arb_aggressive_threshold: float = float(os.getenv("SPREAD_ARB_AGGRESSIVE_THRESHOLD", "0.985"))
    momentum_window_seconds: int = int(os.getenv("MOMENTUM_WINDOW_SECONDS", "60"))
    momentum_threshold_pct: float = float(os.getenv("MOMENTUM_THRESHOLD_PCT", "0.00125"))
    volume_spike_multiplier: float = float(os.getenv("VOLUME_SPIKE_MULTIPLIER", "1.4"))
    late_entry_min_seconds: int = int(os.getenv("LATE_ENTRY_MIN_SECONDS", "30"))
    late_entry_max_seconds: int = int(os.getenv("LATE_ENTRY_MAX_SECONDS", "180"))
    hard_reversal_threshold_pct: float = float(os.getenv("HARD_REVERSAL_THRESHOLD_PCT", "0.0010"))
    take_profit_price: float = float(os.getenv("TAKE_PROFIT_PRICE", "0.90"))
    base_symbols: Tuple[str, ...] = tuple(os.getenv("BASE_SYMBOLS", "BTCUSDT,ETHUSDT").split(","))
    optional_symbols: Tuple[str, ...] = tuple(os.getenv("OPTIONAL_SYMBOLS", "SOLUSDT,XRPUSDT").split(","))
    log_file: str = os.getenv("LOG_FILE", "logs/trades.jsonl")

    # CLI templates are intentionally configurable for different polymarket-cli versions.
    list_markets_cmd: str = os.getenv(
        "LIST_MARKETS_CMD",
        "{cli} markets list --status active --json",
    )
    orderbook_cmd: str = os.getenv(
        "ORDERBOOK_CMD",
        "{cli} markets orderbook --market-id {market_id} --json",
    )
    create_order_cmd: str = os.getenv(
        "CREATE_ORDER_CMD",
        "{cli} orders create --market-id {market_id} --outcome {outcome} --side buy --order-type limit --price {price} --size {size} --json",
    )
    cancel_order_cmd: str = os.getenv(
        "CANCEL_ORDER_CMD",
        "{cli} orders cancel --order-id {order_id} --json",
    )
    positions_cmd: str = os.getenv("POSITIONS_CMD", "{cli} positions list --json")
    open_orders_cmd: str = os.getenv("OPEN_ORDERS_CMD", "{cli} orders list --status open --json")


CONFIG = BotConfig()
