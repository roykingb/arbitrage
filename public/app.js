const scanBtn = document.getElementById('scanBtn');
const results = document.getElementById('results');
const meta = document.getElementById('meta');

const selectedMarkets = () =>
  Array.from(document.getElementById('markets').selectedOptions).map((option) => option.value);

const renderCard = (opp, bankroll) => {
  const legs = opp.legs
    .map(
      (leg) => `<div>
      <strong>${leg.outcome}</strong><br>
      Bookmaker: ${leg.bookmaker}<br>
      Odds: ${leg.odds.toFixed(2)}<br>
      Stake: ${(leg.stake_share * bankroll).toFixed(0)} TZS
    </div>`
    )
    .join('');

  return `<article class="card">
    <h3>${opp.event_name} <span class="tag">ROI ${opp.expected_roi_percent.toFixed(2)}%</span></h3>
    <p>${opp.league} • ${opp.market} • ${new Date(opp.start_time).toLocaleString()}</p>
    <div class="legs">${legs}</div>
  </article>`;
};

scanBtn.addEventListener('click', async () => {
  const bankroll = Number(document.getElementById('bankroll').value);
  const min_roi_percent = Number(document.getElementById('minRoi').value);
  const include_markets = selectedMarkets();

  scanBtn.disabled = true;
  scanBtn.textContent = 'Scanning...';

  try {
    const response = await fetch('/api/scan', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ bankroll, min_roi_percent, include_markets })
    });

    const data = await response.json();

    meta.textContent = `Scanned ${data.events_scanned} events across ${data.bookmakers.join(', ')} at ${new Date(data.scanned_at).toLocaleTimeString()}`;

    if (!data.opportunities.length) {
      results.innerHTML = '<p>No arbitrage found with current filters.</p>';
      return;
    }

    results.innerHTML = data.opportunities.map((opp) => renderCard(opp, bankroll)).join('');
  } catch (error) {
    results.innerHTML = `<p>Scan failed: ${error.message}</p>`;
  } finally {
    scanBtn.disabled = false;
    scanBtn.textContent = 'Scan All Markets';
  }
});
