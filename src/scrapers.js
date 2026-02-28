export const BOOKMAKER_SOURCES = {
  sportpesa: {
    upcomingUrl: process.env.SPORTPESA_UPCOMING_URL || 'https://www.sportpesa.co.tz/sports',
    enabled: true
  },
  sportybet: {
    upcomingUrl: process.env.SPORTYBET_UPCOMING_URL || 'https://www.sportybet.com/tz/sport/football',
    enabled: true
  },
  betpawa: {
    upcomingUrl: process.env.BETPAWA_UPCOMING_URL || 'https://www.betpawa.co.tz/',
    enabled: true
  },
  betway: {
    upcomingUrl: process.env.BETWAY_UPCOMING_URL || 'https://www.betway.co.tz/',
    enabled: true
  }
};

const MARKET_MAP = {
  '1x2': 'match_winner',
  'match result': 'match_winner',
  'full time result': 'match_winner',
  'double chance': 'double_chance',
  'both teams to score': 'both_teams_to_score',
  'btts': 'both_teams_to_score',
  'over/under 2.5': 'over_under_2_5',
  'totals': 'totals',
  'asian handicap': 'asian_handicap'
};

const safeJsonParse = (value) => {
  try {
    return JSON.parse(value);
  } catch {
    return null;
  }
};

const decodeEscapedJson = (text) =>
  text
    .replace(/\\\"/g, '"')
    .replace(/\\n/g, '')
    .replace(/\\t/g, '')
    .replace(/\\\//g, '/');

const normalizeMarketName = (name = 'unknown_market') => {
  const clean = String(name).trim().toLowerCase();
  return MARKET_MAP[clean] || clean.replace(/\s+/g, '_').replace(/[^a-z0-9_]/g, '');
};

const canonicalOutcome = (label) =>
  String(label)
    .trim()
    .toLowerCase()
    .replace(/\s+/g, ' ')
    .replace(/^home$/i, '1')
    .replace(/^away$/i, '2')
    .replace(/^draw$/i, 'x');

const pullJsonBlobs = (html) => {
  const blobs = [];

  // Next.js / Nuxt / hydration blobs
  for (const re of [
    /<script[^>]*id="__NEXT_DATA__"[^>]*>([\s\S]*?)<\/script>/gi,
    /<script[^>]*type="application\/ld\+json"[^>]*>([\s\S]*?)<\/script>/gi,
    /window\.__INITIAL_STATE__\s*=\s*(\{[\s\S]*?\});/gi,
    /window\.__NUXT__\s*=\s*(\{[\s\S]*?\});/gi
  ]) {
    let match;
    while ((match = re.exec(html)) !== null) {
      const jsonRaw = decodeEscapedJson(match[1].trim());
      const parsed = safeJsonParse(jsonRaw);
      if (parsed) blobs.push(parsed);
    }
  }

  return blobs;
};

const asNumber = (v) => {
  const n = Number(v);
  return Number.isFinite(n) && n > 1 ? n : null;
};

const toMarketRecords = ({ bookmaker, eventId, eventName, league, startTime, marketName, selections }) => {
  if (!eventId || !eventName || !selections?.length) return [];
  const outcomes = selections
    .map((s) => ({
      outcome: canonicalOutcome(s.outcome || s.name || s.label || ''),
      odds: asNumber(s.odds || s.price || s.decimal)
    }))
    .filter((s) => s.outcome && s.odds);

  if (outcomes.length < 2) return [];

  return [
    {
      eventId: String(eventId),
      eventName: String(eventName),
      league: league || 'Unknown',
      startTime: startTime || new Date().toISOString(),
      market: normalizeMarketName(marketName),
      bookmaker,
      outcomes
    }
  ];
};

function walk(node, visitor) {
  if (!node || typeof node !== 'object') return;
  visitor(node);
  if (Array.isArray(node)) {
    for (const item of node) walk(item, visitor);
    return;
  }
  for (const value of Object.values(node)) walk(value, visitor);
}

const extractFromBlob = (bookmaker, blob) => {
  const rows = [];

  walk(blob, (node) => {
    if (!node || typeof node !== 'object') return;

    const eventName = node.eventName || node.name || node.matchName || node.fixtureName;
    const eventId = node.eventId || node.id || node.fixtureId || node.matchId;
    const league = node.leagueName || node.competitionName || node.tournamentName || node.league;
    const startTime = node.startTime || node.kickoff || node.startDate || node.start;

    const markets = node.markets || node.betOffers || node.marketGroups || node.options;
    if (!eventName || !eventId || !Array.isArray(markets)) return;

    for (const market of markets) {
      const marketName = market.name || market.marketName || market.label || market.type;
      const selections = market.outcomes || market.selections || market.choices || market.runners;
      if (!Array.isArray(selections)) continue;
      rows.push(
        ...toMarketRecords({
          bookmaker,
          eventId,
          eventName,
          league,
          startTime,
          marketName,
          selections
        })
      );
    }
  });

  return rows;
};

export async function scrapeBookmaker(bookmaker, config) {
  if (!config?.enabled || !config?.upcomingUrl) return [];

  const response = await fetch(config.upcomingUrl, {
    headers: {
      'user-agent':
        process.env.SCRAPER_UA ||
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36',
      accept: 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      'accept-language': 'en-US,en;q=0.9'
    }
  });

  if (!response.ok) {
    throw new Error(`${bookmaker} source unavailable (${response.status})`);
  }

  const html = await response.text();
  const blobs = pullJsonBlobs(html);

  const extracted = blobs.flatMap((blob) => extractFromBlob(bookmaker, blob));
  return extracted;
}

export async function scrapeAllBookmakers() {
  const entries = Object.entries(BOOKMAKER_SOURCES);
  const settled = await Promise.allSettled(entries.map(([name, cfg]) => scrapeBookmaker(name, cfg)));

  const markets = [];
  const errors = [];

  for (let i = 0; i < settled.length; i += 1) {
    const [name] = entries[i];
    const result = settled[i];
    if (result.status === 'fulfilled') {
      markets.push(...result.value);
    } else {
      errors.push({ bookmaker: name, error: result.reason?.message || 'Unknown scrape failure' });
    }
  }

  return { markets, errors };
}
