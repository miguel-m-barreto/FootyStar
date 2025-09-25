# Footy Star v1.0.1
## Investments - Fixed Businesses and Casino (arcade)

This module adds two optional money systems that plug into **Weekly Economy.md**:
1) **Fixed Businesses** you can buy and upgrade for predictable weekly income, gated by **OVR** and **Reputation**.
2) **Casino** where players can risk money for quick wins or losses (arcade RNG with clear house edge).

All values are in **$** per week. Numbers here are defaults meant for tuning.

---

## 1 Fixed Businesses

### 1.1 Core model
Each business has:
- **C0**: purchase cost (includes Level 1).
- **W0**: weekly income at Level 1.
- **Requirements**: minimum **OVR** and/or **Reputation** to purchase.
- **Upgrades**: optional; increase weekly income linearly.

Parameters:
- **Income step** per upgrade: `ΔW = W0 * (1 + β)` with default **β = 0.125** (12.5%).
- **Upgrade cost** series: first upgrade cost `U1 = u * C0` with default **u = 0.5`; subsequent upgrades grow by **25%**:
  - `U(k+1) = 1.25 * U(k)`
- **Weekly income at Level L (L ≥ 1):**
  - `W(L) = W0 + (L - 1) * ΔW`, where `ΔW = 1.125 * W0` by default.
- **Max level** per business: default **Lmax = 5** (purchase = L1 + up to 4 upgrades).

Notes:
- This is deterministic. No random price swings in v1.0.1.
- You can own multiple different businesses, subject to **slots** (see 1.4).

### 1.2 ROI and payback
- **Marginal payback** for upgrade k ≈ `U(k) / ΔW` weeks.
- **Total payback** to reach level L: `(C0 + Σ U(i)) / W(L)` (rough guide).

### 1.3 Purchase and upgrade rules
- You must meet **requirements** at time of purchase (OVR/Rep gates).
- Upgrades do not require extra OVR/Rep unless specified.
- All costs are paid immediately from balance and logged in **Weekly Economy** as **Expenses**.
- Weekly income is credited at the end of the week as **Income**.
- Selling is disabled in v1.0.1 (no liquidation).

### 1.4 Business slots (by Reputation)
- Rep 0-9: **1 slot**
- Rep 10-19: **2 slots**
- Rep 20+: **3 slots**
- Future: raise caps with story events or special sponsors.

### 1.5 Catalog (v1 defaults)
All follow the same formulas. Adjust C0/W0/requisites to tune pacing.

| Business | Requirements | C0 | W0 (L1) | U1 (50% C0) | ΔW (per upgrade) |
|---|---|---:|---:|---:|---:|
| Café | OVR ≥ 5 | $10,000 | $120 | $5,000 | $135 |
| Spa | Rep ≥ 10 | $25,000 | $300 | $12,500 | $337.5 |
| Gym (Neighborhood) | OVR ≥ 12, Rep ≥ 8 | $40,000 | $500 | $20,000 | $562.5 |
| Sports Bar | OVR ≥ 15, Rep ≥ 12 | $60,000 | $720 | $30,000 | $810 |
| Merch / Streetwear | Rep ≥ 18 | $90,000 | $1,050 | $45,000 | $1,181.25 |
| Fitness & Wellness Studio | OVR ≥ 20, Rep ≥ 20 | $140,000 | $1,600 | $70,000 | $1,800 |

Examples of weekly income by level (Café, W0=120, ΔW=135):
- L1: $120
- L2: $255
- L3: $390
- L4: $525
- L5: $660

### 1.6 Example build (Café to L3)
- Buy Café: C0 = $10,000 -> L1 income $120.
- Upgrade 1: U1 = $5,000 -> L2 income $255.
- Upgrade 2: U2 = $6,250 -> L3 income $390.
- Total invested: $21,250; weekly income now $390.

---

## 2 Casino (arcade RNG, optional)

The casino is a pure RNG sink with a **negative expected value** (house edge). It is designed for flavor and drama, not sustainable profit. All casino actions settle immediately and are logged in Weekly Economy.

### 2.1 Games
- **Slots**
  - Bet sizes: $50, $100, $250, $500.
  - Payout table: many small misses, some small hits (2-5x), rare big hits (25x, 50x, 100x).
  - House edge target: **5%** EV.
- **Blackjack (simplified)**
  - Single action: bet resolves to win/lose with small bias to house.
  - House edge target: **2%** EV assuming basic strategy abstraction.
- **Sportsbook (league games)**
  - Bet on simulated fixtures with decimal odds.
  - Payouts = stake × odds on win; push/refund on draws if market is 1X2 split (configurable).
  - Set bookmaker margin to **4-7%** over fair odds.
- **Future**: Poker tournaments against bots (high variance).

### 2.2 Limits, cooldowns, and risk
- **Weekly bet cap**: default **min($5,000, 0.5 × weekly salary)** across all casino games.
- **Per‑bet cap**: **$500**.
- **Cooldown**: at most **5 bets** per week.
- **Addiction flag**: if a player wagers ≥ 50% of salary for **3 consecutive weeks**, set `problem_gambler=true`.
  - Optional consequences (disabled by default): Reputation −0.5/week while flagged; coach warnings in inbox; unlock a small story quest to clear the flag.
- All of the above are tuneable constants.

### 2.3 Anti‑exploit
- Casino uses **client RNG seeds** validated per session; results are settled immediately and stored in the weekly statement.
- No offline/online arbitrage since outcomes do not depend on external prices.
- Bets cannot be undone or re‑rolled; session seeds rotate weekly.

---

## 3 Integration points

- **Weekly Economy.md**
  - Business income is added to weekly **Income**.
  - Business purchases/upgrades and casino losses/wins are **Expenses/Income** in the statement.
- **Match/Contracts**
  - No direct effect from money on selection or matches.
  - Optional flavor events can link excessive gambling to Reputation (off by default).
- **UI**
  - Businesses tab: shows owned businesses, level, next upgrade cost, current weekly income.
  - Casino tab: simple list of games, bet input, responsible play warning, weekly caps.

---

## 4 Tuning constants (defaults)
- Business income step: `β = 0.125` -> `ΔW = 1.125×W0`.
- Upgrade cost factor: `u = 0.50`; growth: `×1.25` per upgrade.
- Max business level: `Lmax = 5`; business slots by Rep: 1/2/3 at 0/10/20.
- Casino edges: Slots 5%, Blackjack 2%, Sportsbook margin 4-7%.
- Weekly casino cap: `min($5,000, 0.5×salary)`; per‑bet cap $500; 5 bets/week.
- Addiction flag threshold: wager ≥ 50% of salary for 3 consecutive weeks.
- All constants are data‑driven and can be tuned per league/difficulty.

---

## 5 Dev notes
- Implement businesses as data objects `{id, name, C0, W0, req_OVR, req_Rep, Lmax, u, growth, beta}`.
- Persist per‑player ownership `{business_id, current_level, invested_total}`.
- Weekly tick computes business income and appends to the statement log.
- Casino outcomes recorded per bet `{game, stake, outcome, net}`; enforce caps before placing.
- Add unit tests for payback math and caps.
