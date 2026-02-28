# TZ Arbitrage Website (Live Scrape + Fallback)

This app scans arbitrage opportunities across Tanzanian-popular bookmakers:
- SportPesa
- SportyBet
- BetPawa
- Betway

## What is improved
- Added **live scraper adapters** that fetch bookmaker upcoming pages and try to extract odds from hydration/shadow JSON blobs.
- Added fallback strategy: if live scraping fails on any/all sources, scanner automatically falls back to mock data so the app stays functional.
- Supports broad market ingestion (including dynamic markets), not only fixed 3 options.
- Arbitrage engine computes best-outcome odds, implied probability sum, ROI, and bankroll stake allocation.

## Run
```bash
npm start
```
Open http://localhost:8000

## Test
```bash
npm test
```

## Live scraping configuration
You can override source URLs via env vars:
- `SPORTPESA_UPCOMING_URL`
- `SPORTYBET_UPCOMING_URL`
- `BETPAWA_UPCOMING_URL`
- `BETWAY_UPCOMING_URL`

Example:
```bash
SPORTPESA_UPCOMING_URL='https://example.com/sports' npm start
```

## Important real-world constraints
- Bookmakers frequently use anti-bot protections (Cloudflare, dynamic signatures, captcha, geo/risk controls).
- This means **no one can guarantee 100% continuous scraping uptime** from public pages.
- The architecture here is production-oriented (multi-source, parser isolation, graceful fallback), but you may still need rotating proxies, browser automation workers, and legal permission/compliance per bookmaker terms.
