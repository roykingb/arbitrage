const scanBtn = document.getElementById('scanBtn');
const results = document.getElementById('results');
const meta = document.getElementById('meta');
const warnings = document.getElementById('warnings');

const selectedMarkets = () =>
  Array.from(document.getElementById('markets').selectedOptions).map((option) => option.value);

const renderCard = (opp) => {
  const legs = opp.legs
    .map(
      (leg) => `<div>
      <strong>${leg.outcome}</strong><br>
      Bookmaker: ${leg.bookmaker}<br>
      Odds: ${leg.odds.toFixed(2)}<br>
      Stake: ${leg.stake_amount.toLocaleString()} TZS
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
  const live_scrape = document.getElementById('liveMode').value === 'live';

  scanBtn.disabled = true;
  scanBtn.textContent = 'Scanning...';
  warnings.innerHTML = '';

  try {
    const response = await fetch('/api/scan', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ bankroll, min_roi_percent, include_markets, live_scrape })
    });

    const data = await response.json();

    meta.textContent = `Mode: ${data.data_mode} • Events: ${data.events_scanned} • Market rows: ${data.total_markets_scanned} • Sources: ${data.bookmakers.join(', ')}`;

    if (data.scrape_errors?.length) {
      warnings.innerHTML = data.scrape_errors
        .map((err) => `<li>${err.bookmaker}: ${err.error}</li>`)
        .join('');
    }

    if (!data.opportunities.length) {
      results.innerHTML = '<p>No arbitrage found with current filters.</p>';
      return;
    }

    results.innerHTML = data.opportunities.map((opp) => renderCard(opp)).join('');
  } catch (error) {
    results.innerHTML = `<p>Scan failed: ${error.message}</p>`;
  } finally {
    scanBtn.disabled = false;
    scanBtn.textContent = 'Scan Upcoming Markets';
  }
});
