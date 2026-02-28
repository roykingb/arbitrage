import test from 'node:test';
import assert from 'node:assert/strict';

import { runScan } from '../src/scanner.js';

test('runScan returns arbitrage opportunities', () => {
  const result = runScan({ bankroll: 100000, min_roi_percent: 0 });

  assert.ok(result.events_scanned > 0);
  assert.ok(result.opportunities.length > 0);
  assert.ok(result.opportunities.every((opp) => opp.total_implied_probability < 1));
});

test('market filter restricts scan scope', () => {
  const result = runScan({ include_markets: ['match_winner'], min_roi_percent: 0 });
  assert.ok(result.opportunities.every((opp) => opp.market === 'match_winner'));
});
