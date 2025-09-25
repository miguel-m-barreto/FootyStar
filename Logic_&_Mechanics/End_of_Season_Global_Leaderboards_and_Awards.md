# Footy Star v1.0.1
## Global End‑of‑Season Leaderboards & Awards (cross‑league)

This spec extends the per‑league end‑of‑season system to produce **one global table** and awards aggregating **all leagues** at season close. It is designed to be fair across leagues with different match counts and calendars by using **per‑90 metrics**, **minutes thresholds**, and optional **league prestige weights**.

---

## 1 Scope and timing

- **Scope:** league matches only (no cups/continentals in v1.0.1; can be toggled later).
- **Season year window:** July 1 -> June 30 (European season window). MLS/other leagues whose seasons fall within the window are mapped to the nearest window end.
- **Trigger:** Run global aggregation **after all configured leagues finish** within the window. If a league ends late, global waits (configurable timeout).a

Transfers mid‑season: a player's stats are **aggregated across clubs/leagues** within the season window. The player appears once in global tables with the sum of minutes and events.

---

## 2 Normalisation rules (fairness across leagues)

1) **Per‑90 base** for counting stats  
   - Goals/Assists/Key Passes/Take‑ons/Tackles/Interceptions/Aerials -> compute **rate per 90**: `stat_per90 = 90 * stat_total / minutes`.
   - Leaderboards still display **totals** alongside the **per‑90 rate**.

2) **Minutes floors**  
   - Global leaderboards: **≥ 1,200 minutes** (stricter than per‑league 600).  
   - Global awards: **≥ 1,500 minutes** unless otherwise noted.

3) **League prestige weight (optional)**  
   - From **League_Calendar.json** add `prestige_weight ∈ [0.85, 1.15]` (default 1.00).  
   - Apply to **ratings** and **SVS** only (not to raw counts): `rating_adj = rating * prestige_weight`.  
   - Toggle `use_prestige_weight` (default **off** for transparency).

4) **Ratings aggregation**  
   - Use **minutes‑weighted average** across appearances.  
   - Minimum **10 appearances** and **900 minutes** to appear on rating tables; **1,500 minutes** for awards.

---

## 3 Global leaderboards (Top 20)

1. **Top Scorers (per‑90)** - sorted by Goals/90; show totals and minutes.  
   Ties: (1) higher total goals, (2) higher avg rating, (3) fewer minutes.

2. **Top Assists (per‑90)** - sorted by Assists/90; show totals and minutes.  
   Ties: (1) higher total assists, (2) pass accuracy, (3) fewer minutes.

3. **Highest Average Ratings** - minutes‑weighted rating (optionally prestige‑adjusted).  
   Eligibility: 1,500 minutes, 15 apps.

4. **Most MOM Awards** - total MOM across leagues.  
   Ties: (1) avg rating, (2) more minutes.

5. **Creative Leaders** - Key Passes/90.  
6. **Take‑On Kings** - Successful take‑ons/90.  
7. **Defensive Stoppers** - Index = Tackles Won/90 + 0.8×Interceptions/90.  
8. **Aerial Dominance** - Index = Aerial Clears/90 + 0.7×Offensive Headers Won/90.  
9. **Passing Accuracy Leaders** - Accuracy % (min 800 attempts).

All tables default to **Top 20** globally. Thresholds are tunables.

---

## 4 Global awards

- **World MVP**  
  - Metric: **SVS_global** = 50% Avg Rating(+prestige opt) + 30% Goal/Assist Impact/90 + 20% MOM share.  
  - Eligibility: ≥ 1,500 minutes.  
  - Rewards: `Reputation +3.0`, `Money +$50,000`.

- **Global Golden Boot**  
  - Metric: **Goals per 90**.  
  - Eligibility: ≥ 1,500 minutes. Ties by total goals, then rating.  
  - Rewards: `Reputation +2.0`, `Money +$30,000`.

- **Global Playmaker**  
  - Metric: **Assists per 90**.  
  - Eligibility: ≥ 1,500 minutes. Ties by pass accuracy, then rating.  
  - Rewards: `Reputation +1.8`, `Money +$25,000`.

- **Global Young Player of the Year**  
  - Metric: SVS_global among players **≤21** at window start.  
  - Eligibility: ≥ 1,200 minutes.  
  - Rewards: `Reputation +1.5`, `Money +$20,000`.

- **Global Team of the Year (ToY)**  
  - 11 players with best **Role Score** (4 DF, 3 MF, 3 ST + 1 best overall wild card).  
  - Bench: next 7 overall.  
  - Reward per selected: `Reputation +0.8`, `Money +$6,000`.

- **Most Improved (Global)**  
  - Metric: Δ Avg Rating between first and second half of season (both halves ≥ 600 minutes).  
  - Rewards: `Reputation +0.8`, `Money +$6,000`.

- **Iron Man (Global)**  
  - Most minutes played globally.  
  - Rewards: `Reputation +0.6`, `Money +$4,000`.

- **Super Sub (Global)**  
  - Goals per 90 among players with **≤900 minutes** and **≥8 appearances**.  
  - Rewards: `Reputation +0.6`, `Money +$4,000`.

All rewards are defaults; may scale with `league.prestige_weight` or a global prestige curve.

---

## 5 UI/UX

- **Statistics menu:**  
  - Tabs: one per **League**, plus a **Global** tab.  
  - Filters: Season window, position (ST/MF/DF), min minutes toggle, prestige weighting toggle.  
  - Each table shows **per‑90**, **totals**, **minutes**, and **clubs**.

- **End‑of‑Season flow:**  
  - After per‑league awards, show a second screen: **Global Awards** with the above trophies and the **Global Team of the Year**.  
  - Store accolades in Career History (league‑tagged vs global‑tagged).

---

## 6 Implementation notes

- Data pipeline:  
  1) Aggregate per‑league season stats first (already implemented).  
  2) Merge across leagues by player‑id within the **season window**.  
  3) Compute per‑90 rates and thresholds; apply optional prestige weight.  
  4) Produce global leaderboards and pick awards.  
  5) Credit **Reputation** and **Money** via Weekly Economy; persist accolades.

- Edge cases:  
  - Players switching leagues mid‑season: merge stats; club field shows “multi” or last club.  
  - Different league lengths: per‑90 and minutes floors handle fairness.  
  - Calendar: global waits until all leagues in the window have closed.

- Tunables (defaults):  
  - Global leaderboards min minutes: 1,200.  
  - Global awards min minutes: 1,500.  
  - Attempts floor for passing table: 800.  
  - `use_prestige_weight = false` (can be toggled).  
  - `prestige_weight` default per league = 1.0; range 0.85–1.15.

