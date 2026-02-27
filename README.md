# Polymarket HFT Bot (CLI + Binance Websocket)

This project is a production-oriented Python bot that executes a high-frequency Polymarket strategy using **official `polymarket-cli` JSON commands** and a **Binance websocket** feed.

## What it implements

- 1–3 second loop cadence.
- Maker-only **limit buy** execution.
- Default small order size (`$24`), configurable.
- Late momentum scaling-in on 5-minute BTC/ETH markets.
- Buy-both-sides spread arbitrage (`YES ask + NO ask < 0.99`).
- 5-minute vs 15-minute implied mispricing arbitrage.
- Position-cap safety and open-order cancellation.
- Structured JSONL trade/event logging.

## Architecture

- `hft_bot/config.py`: all configurable thresholds + polymarket CLI command templates.
- `hft_bot/polymarket_cli.py`: async wrapper around `polymarket-cli ... --json`.
- `hft_bot/binance_feed.py`: websocket ingestion + momentum/volume spike signals.
- `hft_bot/strategy.py`: trading logic and risk controls.
- `hft_bot/main.py`: startup wiring.

## Setup

1. Install dependencies:
   ```bash
   python -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   ```
2. Install and authenticate `polymarket-cli` (official docs / your internal process).
3. Configure env:
   ```bash
   cp .env.example .env
   ```
4. If your `polymarket-cli` subcommands differ from defaults, edit command templates in `.env`.

## Run

```bash
source .venv/bin/activate
python -m hft_bot.main
```

## Operational notes

- The bot intentionally places multiple small orders during momentum bursts to mimic scaling-in behavior.
- It focuses on BTC/ETH 5-minute and 15-minute markets, with optional SOL/XRP discovery.
- Keep `LOOP_INTERVAL_SECONDS` in the 1–3s range to match high-frequency behavior.
- All events are written to `logs/trades.jsonl` for replay/audit.

## Safety controls you should tune before live trading

- `MAX_SIMULTANEOUS_POSITIONS`
- `MOMENTUM_THRESHOLD_PCT`
- `VOLUME_SPIKE_MULTIPLIER`
- `SPREAD_ARB_THRESHOLD`
- `TAKE_PROFIT_PRICE`

## Disclaimer

This is software infrastructure, not financial advice. Run first in paper/sandbox mode and validate CLI command syntax against your installed `polymarket-cli` version.
