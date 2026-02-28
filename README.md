# Sports +EV Finder & Alerts

A collection of web-based tools for sports betting analysis, +EV (positive expected value) finding, and real-time alerts.

## Project Structure

### `/nhl` — NHL Tools
- **`index.html`** — NHL FMV (Fair Market Value) Tracker - main dashboard for tracking NHL game values
- **`nhl.html`** — NHL Periods +EV Finder - find +EV opportunities on NHL period markets
- **`nhlprops.html`** — NHL Period Props +EV Finder - player prop analysis for NHL periods
- **`goal.html`** — NHL Goal Alerts - real-time goal notifications

### `/cbb` — College Basketball Tools
- **`cbb.html`** through **`cbb11.html`** — +EV Finder iterations for CBB + Polymarket
- **`cbk.html`** — CBB dashboard
- **`ev-finder-polymarket (13).html`** — Polymarket EV finder

### `/kalshi` — Kalshi Tools
- **`kalshi-alerts.html`** — Kalshi NHL Goal Alerts - real-time Kalshi market alerts
- **`CSK.html`** — Kalshi NHL Mobile interface

## Tech Stack
- Standalone HTML files (no build step required)
- Tailwind CSS (via CDN)
- Vanilla JavaScript
- Real-time API integrations (NHL, Polymarket, Kalshi)
