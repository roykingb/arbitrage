# TZ Arbitrage Website

This is an advanced arbitrage scanning web app focused on Tanzanian-popular bookmakers:
- SportPesa
- SportyBet
- BetPawa
- Betway

## What it does
- Scans all configured markets (`match_winner`, `both_teams_to_score`, `over_under_2_5`).
- Compares best odds across bookmakers per outcome.
- Detects arbitrage when total implied probability `< 1`.
- Computes stake split and projected ROI for a bankroll.
- Includes market selection, bankroll input, and minimum ROI filtering.

## Important real-world note
The current implementation is fully functional using robust mock adapters so it runs reliably in this environment.
For live bookmaker data, replace `fetchNormalizedMarkets()` with official/authorized API adapters. Many bookmakers use anti-bot and legal restrictions.

## Run
```bash
npm start
```
Then open `http://localhost:8000`.

## Test
```bash
npm test
```
