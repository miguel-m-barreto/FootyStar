# Footy Star v1.0.1
## Transfers & Market System

This document defines how players move between clubs, how interest is generated, how bids and negotiations work, and how it integrates with Contracts, League Calendar, Weekly Economy, and Skills. Money values are in USD.

---

## 0 Goals
- Make transfers feel plausible and dynamic without micromanagement.
- Respect league calendars and windows.
- Tie demand to on‑pitch performance (Ratings, Goals/Assists), reputation, and fit.
- Keep it data‑driven and tunable per league and club profile.

---

## 1 Integration map
- **League_Calendar.md**: transfer_windows per league control when bids/offers can be created, accepted, or registered.
- **Contracts.md v1.0.1**: salary targeting, PlayerQualityMult (Consistency, Determination), SPP (soft signals), MarketValue formulas.
- **Match.md**: performance stats and reputation deltas feed interest weekly.
- **Weekly Economy.md**: transfer fees paid by buying club; signing bonus, agent fees; player’s salary flows after the move.
- **Investments.md**: unrelated; funds are personal, not club budgets.

---

## 2 Key definitions
- **Interest (0–100)**: latent desire of a club to pursue a player.
- **Shortlist**: clubs with Interest ≥ 40 or flagged by scouts.
- **Enquiry**: Interest ≥ 60 → club pings selling club for availability & price idea.
- **Bid/Offer**: Interest ≥ 80 and affordability gate passed → a formal transfer offer is created.
- **Affordability gate**: `fee ≤ buying_club.transfer_budget` and `target_wage ≤ buying_club.wage_bill_room`.
- **Registration**: transfer can only be registered inside window; pre‑agreements allowed but “joins on date” applies (end of season or window open).

---

## 3 Weekly interest model (per club → player)
Recompute weekly for all candidate players (by scouts’ coverage). Baseline weights (sum 100%):

- 28% **Performance**: last 5 match ratings weighted by minutes (7.0 baseline).
- 18% **RoleNeed**: club need score for player’s primary role (0–1).
- 15% **Reputation**: player’s current Reputation (0–100 scaled).
- 10% **Fit**: cosine similarity between club style weights and player skill vector (normalized 0–1).
- 10% **CoachRelation**: coach signals (−/+). Map to −5…+5 Interest.
- 7% **Age/Potential**: favor younger with Potential gap.
- 5% **Favorite**: player/agent preferences toggle adds up to +5.
- −13% **WagePressure**: expected wage vs club wage cap/room.

Then apply gates and modifiers:
- **Club status gate**: clubs below player’s Reputation tier suffer −10 Interest.
- **Window proximity**: +5 Interest during window weeks.
- **Competition**: if n other clubs on shortlist, each adds +2 Interest (cap +6).
- Clamp: 0–100. Store a rolling average with small decay (0.85 carry).

Enquiry threshold 60; Offer threshold 80 plus affordability.

---

## 4 Transfer valuation (offers & fees)
Base fee suggestion uses Contracts.md MarketValue, then apply club/player context:

```
base_fee = MarketValue(player)    // from Contracts.md
years_left = contract_years_left  // 0..3 (MVP), use weeks if needed
ask_fee = base_fee
ask_fee *= (1 + 0.10*min(3, years_left))             // contract leverage
ask_fee *= (1 + 0.002*(Consistency - 50))            // small merit bumps
ask_fee *= (1 + 0.002*(Determination - 50))
ask_fee *= (1 + 0.003*(Leadership - 50))
ask_fee *= season_phase_mult                           // e.g., early window 1.00, deadline 1.10
ask_fee = clamp_noise(ask_fee, ±10%)
```
- **Release clause** (optional per contract): if set, selling club must accept any bid ≥ clause value.
- **Auction pressure**: when ≥2 active bidders, auto‑increment asks by +5% steps per cycle up to +20% cap.

Add‑ons (optional in v1.0.1, can be toggled off initially):
- **Bonuses**: after 10 apps, after 10 goals, team promotion, continental qualification.
- **Sell‑on %**: 10–20% typical.
- **Loan with option/obligation**: fee now + option fee later.

---

## 5 Offer pipeline
1) **Enquiry**: buying club requests price idea. Selling club responds with `ask_fee` or “not for sale” (raises ask by +20%).
2) **Bid**: buying club sends `{fee, add_ons?, loan?}`.
3) **Response**:
   - Accept → move to **Player terms**.
   - Reject → Interest drops −5; buying club may increase.
   - Counter → adjust fee by ±(5–15)% or add bonuses; Interest adjusts ±2.
4) **Deadline behavior**: last 48h of window accelerates cycles and accepts slightly worse terms if Interest high.

Cooldowns:
- After a reject, buying club cannot rebid for **3 days** unless they increase fee by ≥10%.

---

## 6 Player terms (negotiation)
Once clubs agree a fee (or release clause triggers), the player negotiates contract terms (see Contracts.md). Use v1.0.1 behaviors:
- Expected wage from **target_wage** pipeline (league base × PQI × role × SPP × auction).
- Determination ≥70: player accepts slightly lower wages (accept‑threshold +2% in club favor).
- Consistency ≥70: fewer clauses demanded.
- Leadership ≥80: may request captaincy premium (+5%).

Decision helpers:
- **Competition for place**: if buying club role projection is Rotation or Bench vs current Starter/Key → ask wage ↑ and Interest ↓.
- **CoachRelation**: high at current club gives −10 to accept unless role improves.
- **Career path**: if Reputation gap upwards (bigger club), accept threshold −3% wage.

Outcome:
- Accept → contract created, registration on window date.
- Stall → 3‑day hold, then Interest decays −5 unless improved terms.
- Decline → deal off; buying club can pivot to other targets.

---

## 7 Loans
Supported flows (optional to implement early):
- **Standard loan**: no fee or small fee, wage split ratio (e.g., 60/40). Duration until season end.
- **Loan‑to‑buy**: option fee pre‑agreed; auto‑triggers if appearances ≥ threshold or on promotion (obligation).
- **Recall**: selling club can recall in January window if clauses allow.

Loan selection rules:
- If player is <21 or low Selection Score at current club, other clubs with RoleNeed high will prefer loan offers.
- Player prefers loans that guarantee minutes (role projection Starter).

---

## 8 Scouting & discovery
- **Coverage**: each club has a scouting capacity cap (number of players tracked per week).
- **Discovery channels**:
  - Performance leaderboards (league and global) seed candidates.
  - Agent offers: random list of available players, bias by agent network.
  - Shortlists carry over across windows with slow decay.
- **Scouting grade**: accuracy of OVR/skills estimation depends on scouting level (±1–3 points).

---

## 9 Registration and timing
- Deals can be agreed at any time but are only **registered** during windows per League_Calendar.
- **Pre‑contract**: with ≤6 weeks remaining, player can agree a free transfer to join next season (Bosman).  
- Cross‑league sync: if leagues have different windows, apply the stricter rule for registration.
- UI shows “joins on DATE” when signed outside the current window.

---

## 10 UI/UX flow
- **Transfer Hub** tabs:
  - Inbox: Enquiries, Bids, Terms to review.
  - Shortlist: clubs interested in you and your interest in clubs (toggle favorites).
  - Market Radar: top Interest matches sorted by RoleNeed and Fit.
  - Deadlines: countdown during window.
- Offer view shows fee, add‑ons, wage, role projection, coach rating, and accept/decline/counter options.

---

## 11 Tuning constants (defaults)
- Enquiry at Interest ≥ 60; Offer at ≥ 80.
- Interest decay weekly outside window: −8%; inside window: −3%.
- Cooldown after reject: 3 days unless bid improved by ≥10%.
- Auction pressure cap: +20% over base ask.
- Deadline heuristic: last 48h, acceptability loosened by 3%.
- Scouting accuracy error: ±2 OVR (±3 for low‑budget clubs).

---

## 12 Dev notes
- All clubs run the same weekly interest evaluation with affordability gate and window proximity.
- Store offers as stateful objects with timestamps for cooldown and deadlines.
- Respect transfer budgets and wage rooms in club JSON.
- Keep deterministic seeds for reproducibility per week.
- Add telemetry on acceptance rates, average fees vs MV, to tune constants.

---

## 13 Examples

### 13.1 Mid‑table club pursues Starter MF
- Player: MF OVR 70, Rep 55, Consistency 72, Determination 78, CoachRel 65.
- Interest drivers: strong recent ratings, RoleNeed high → Interest 84 → Bid.
- Ask fee: MV $6.0m × years_left 1.2 × Cons/Det bumps 1.06 → ~$7.6m.
- Negotiation: wage per Contracts target → $18.5k/week. Player accepts Rotation→Starter projection → accept −2% threshold. Deal closes.

### 13.2 Auction for a Wonderkid ST
- Two elite clubs shortlist; third joins near deadline. Auction pressure → ask +15%.
- Release clause exists at $45m: final club hits the clause, skipping selling club negotiation; goes straight to player terms.

### 13.3 Loan to buy for bench DF
- Low Selection Score triggers loan recommendations. Buying club offers wage split 60/40 + option to buy $2.5m if 20 apps. Player accepts for minutes.
