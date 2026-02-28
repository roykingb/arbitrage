import { scrapeAllBookmakers } from './scrapers.js';

export const BOOKMAKERS = ['sportpesa', 'sportybet', 'betpawa', 'betway'];

const nowIso = (hoursAhead) => new Date(Date.now() + hoursAhead * 3600 * 1000).toISOString();

const BASE_EVENTS = [
  {
    eventId: 'EPL-ARS-MUN',
    eventName: 'Arsenal vs Manchester United',
    league: 'Premier League',
    startTime: nowIso(8),
    market: 'match_winner',
    outcomes: [['1', 2.2], ['x', 3.45], ['2', 3.1]]
  },
  {
    eventId: 'LIGA-RMA-BAR',
    eventName: 'Real Madrid vs Barcelona',
    league: 'La Liga',
    startTime: nowIso(14),
    market: 'both_teams_to_score',
    outcomes: [['yes', 1.8], ['no', 2.08]]
  },
  {
    eventId: 'UCL-BAY-INT',
    eventName: 'Bayern vs Inter',
    league: 'Champions League',
    startTime: nowIso(20),
    market: 'over_under_2_5',
    outcomes: [['over 2.5', 1.94], ['under 2.5', 2.01]]
  }
];

const BOOKMAKER_BIAS = {
  sportpesa: 1,
  sportybet: 1.02,
  betpawa: 0.98,
  betway: 1.03
};

const normalizeOutcome = (label) => String(label).trim().toLowerCase();

export function fetchMockNormalizedMarkets() {
  return BOOKMAKERS.flatMap((bookmaker) => {
    const bias = BOOKMAKER_BIAS[bookmaker] ?? 1;
    return BASE_EVENTS.map((event) => ({
      ...event,
      bookmaker,
      outcomes: event.outcomes.map(([outcome, odds]) => ({ outcome, odds: Number((odds * bias).toFixed(2)) }))
    }));
  });
}

const detectArbitrage = (markets, min_roi_percent) => {
  const grouped = new Map();

  for (const market of markets) {
    const key = `${market.eventId}::${market.market}`;
    if (!grouped.has(key)) grouped.set(key, []);
    grouped.get(key).push(market);
  }

  const opportunities = [];

  for (const group of grouped.values()) {
    const bestByOutcome = new Map();

    for (const offer of group) {
      for (const outcome of offer.outcomes) {
        const key = normalizeOutcome(outcome.outcome);
        const current = bestByOutcome.get(key);
        if (!current || outcome.odds > current.odds) {
          bestByOutcome.set(key, { outcome: key, odds: outcome.odds, bookmaker: offer.bookmaker });
        }
      }
    }

    if (bestByOutcome.size < 2) continue;

    const legs = Array.from(bestByOutcome.values()).map((entry) => ({
      bookmaker: entry.bookmaker,
      outcome: entry.outcome,
      odds: entry.odds,
      implied_probability: 1 / entry.odds
    }));

    const totalImplied = legs.reduce((sum, leg) => sum + leg.implied_probability, 0);
    if (totalImplied >= 1) continue;

    const expectedRoi = (1 / totalImplied - 1) * 100;
    if (expectedRoi < min_roi_percent) continue;

    const sample = group[0];
    opportunities.push({
      event_id: sample.eventId,
      event_name: sample.eventName,
      league: sample.league,
      start_time: sample.startTime,
      market: sample.market,
      total_implied_probability: totalImplied,
      expected_roi_percent: expectedRoi,
      legs: legs.map((leg) => ({
        ...leg,
        stake_share: leg.implied_probability / totalImplied
      }))
    });
  }

  opportunities.sort((a, b) => b.expected_roi_percent - a.expected_roi_percent);
  return opportunities;
};

export async function runScan({ bankroll = 100000, min_roi_percent = 0.2, include_markets = [], live_scrape = true } = {}) {
  let scrapeErrors = [];
  let markets = [];
  let usedMock = false;

  if (live_scrape) {
    const scraped = await scrapeAllBookmakers();
    scrapeErrors = scraped.errors;
    markets = scraped.markets;
  }

  if (!markets.length) {
    markets = fetchMockNormalizedMarkets();
    usedMock = true;
  }

  const filtered = markets.filter((m) => include_markets.length === 0 || include_markets.includes(m.market));
  const opportunities = detectArbitrage(filtered, min_roi_percent).map((opportunity) => ({
    ...opportunity,
    bankroll,
    legs: opportunity.legs.map((leg) => ({ ...leg, stake_amount: Number((leg.stake_share * bankroll).toFixed(2)) }))
  }));

  return {
    scanned_at: new Date().toISOString(),
    bookmakers: BOOKMAKERS,
    events_scanned: new Set(filtered.map((m) => m.eventId)).size,
    total_markets_scanned: filtered.length,
    opportunities,
    scrape_errors: scrapeErrors,
    data_mode: usedMock ? 'mock_fallback' : 'live'
  };
}
