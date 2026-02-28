# Multi-Exchange Triangular Arbitrage Scanner

A fast async bot that scans each exchange independently for **triangular arbitrage** across all available spot markets and both cycle directions.

Supported by default:
- Binance
- Bybit
- Bitget
- OKX
- Gate.io
- KuCoin
- MEXC

## Features
- Async multi-exchange scanning (`ccxt.async_support`)
- Scans all detected spot currencies and triangle combinations per exchange
- Evaluates both triangle directions:
  - `A -> B -> C -> A`
  - `A -> C -> B -> A`
- Taker-fee aware pricing for each leg
- Colored spread output:
  - **Green** for positive spread
  - **Red** for negative spread

## Install
```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Run
One-shot scan:
```bash
python triangular_arbitrage_bot.py --once
```

Continuous scan every 5s:
```bash
python triangular_arbitrage_bot.py --interval 5
```

Examples:
```bash
# custom exchanges
python triangular_arbitrage_bot.py --once --exchanges binance,okx,bybit

# show top 50 opportunities, filter tiny spreads
python triangular_arbitrage_bot.py --once --top 50 --min-abs-spread 0.03

# override taker fee globally (0.1%)
python triangular_arbitrage_bot.py --once --fee 0.001
```

## Notes
- Opportunities are computed from last fetched bid/ask snapshots and may disappear quickly.
- Real profitability depends on size, slippage, orderbook depth, withdrawal/deposit constraints, and fees.
- This project is for research/monitoring and not financial advice.
