import test from 'node:test';
import assert from 'node:assert/strict';

import { runScan } from '../src/scanner.js';

test('runScan returns arbitrage opportunities in mock mode', async () => {
  const result = await runScan({ bankroll: 100000, min_roi_percent: 0, live_scrape: false });

  assert.ok(result.events_scanned > 0);
  assert.ok(result.opportunities.length > 0);
  assert.ok(result.opportunities.every((opp) => opp.total_implied_probability < 1));
  assert.equal(result.data_mode, 'mock_fallback');
});

test('market filter restricts scan scope', async () => {
  const result = await runScan({ include_markets: ['match_winner'], min_roi_percent: 0, live_scrape: false });
  assert.ok(result.opportunities.every((opp) => opp.market === 'match_winner'));
});
