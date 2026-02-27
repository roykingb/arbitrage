from __future__ import annotations

import asyncio
import json
import time
from collections import deque
from dataclasses import dataclass
from typing import Deque, Dict, Tuple

import websockets

from hft_bot.config import BotConfig
from hft_bot.models import MomentumSignal


@dataclass
class Tick:
    ts: float
    price: float
    qty: float


class BinanceMomentumFeed:
    def __init__(self, config: BotConfig) -> None:
        self.config = config
        self.buffers: Dict[str, Deque[Tick]] = {s: deque(maxlen=6000) for s in config.base_symbols + config.optional_symbols}
        self._task: asyncio.Task | None = None

    async def start(self) -> None:
        symbols = [s.lower() + "@trade" for s in self.buffers.keys()]
        stream = "/".join(symbols)
        url = f"wss://stream.binance.com:9443/stream?streams={stream}"

        async def _run() -> None:
            while True:
                try:
                    async with websockets.connect(url, ping_interval=20) as ws:
                        async for raw in ws:
                            msg = json.loads(raw)
                            data = msg.get("data", {})
                            symbol = data.get("s")
                            if symbol not in self.buffers:
                                continue
                            self.buffers[symbol].append(Tick(ts=time.time(), price=float(data["p"]), qty=float(data["q"])))
                except Exception:
                    await asyncio.sleep(1)

        self._task = asyncio.create_task(_run())

    def _stats(self, symbol: str) -> Tuple[float, bool]:
        now = time.time()
        window = self.config.momentum_window_seconds
        ticks = [t for t in self.buffers[symbol] if now - t.ts <= window]
        if len(ticks) < 2:
            return 0.0, False
        ret = (ticks[-1].price - ticks[0].price) / ticks[0].price
        volume = sum(t.qty for t in ticks)
        baseline_ticks = [t for t in self.buffers[symbol] if window < now - t.ts <= 2 * window]
        baseline = sum(t.qty for t in baseline_ticks) if baseline_ticks else volume
        volume_spike = volume > baseline * self.config.volume_spike_multiplier
        return ret, volume_spike

    def signal(self, symbol: str) -> MomentumSignal:
        ret, volume_spike = self._stats(symbol)
        direction = "FLAT"
        if ret >= self.config.momentum_threshold_pct:
            direction = "UP"
        elif ret <= -self.config.momentum_threshold_pct:
            direction = "DOWN"
        return MomentumSignal(symbol=symbol, direction=direction, one_minute_return=ret, volume_spike=volume_spike)
