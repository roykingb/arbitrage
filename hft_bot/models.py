from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from typing import Literal, Optional


Side = Literal["YES", "NO"]


@dataclass
class Market:
    market_id: str
    slug: str
    question: str
    end_time: datetime
    asset: str
    timeframe_minutes: int


@dataclass
class BestPrices:
    best_ask_yes: Optional[float]
    best_ask_no: Optional[float]
    midpoint_yes: Optional[float]
    midpoint_no: Optional[float]


@dataclass
class MomentumSignal:
    symbol: str
    direction: Literal["UP", "DOWN", "FLAT"]
    one_minute_return: float
    volume_spike: bool


@dataclass
class Position:
    market_id: str
    outcome: Side
    shares: float
    avg_price: float
    unrealized_pnl: float
