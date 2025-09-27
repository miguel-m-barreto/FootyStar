# Footy Star v1.0.1
# Leaderboards & Awards (Merged: Per‑League + Global)

This spec **merges and harmonizes** the per‑league and cross‑league end‑of‑season systems into a single source of truth. It defines common metrics, eligibility, tables, awards, UI/UX, and integration hooks so that **Local (per‑league)** and **Global (all leagues)** outputs remain consistent and tunable.

---

## 0. Scope, Timing & Data Sources

- **Scope modes**
  - **Local (Per‑League):** runs on each league’s season close (e.g., EPL 2025/26).
  - **Global (Cross‑League):** runs once after all configured leagues within the **season window** have closed (see trigger below).
- **Season window:** **July 1 → June 30**. Leagues with different calendars are mapped to the nearest window end.
- **Trigger for Global:** run aggregation **after all leagues** in the window finish (supports a configurable timeout).
- **Transfers mid‑season:** player statistics are merged across clubs/leagues within the active window; the player appears **once** in global outputs.
- **Data sources:** per‑match event logs and ratings from `Match.md` (Goals, Assists, Key Passes, Dribbles/Take‑ons, Tackles Won, Interceptions, Aerial Clears, Pass Attempts/Accuracy, MOM, Minutes, Appearances).

---

## 1. Common Metrics, Normalisation & Eligibility

To guarantee fairness and consistency across Local and Global tables:

1) **Per‑90 base (toggleable per table)**
   - Rate definition: `stat_per90 = 90 * stat_total / minutes`.
   - Default usage:
     - **Local:** show **totals** as the ranking metric; display per‑90 as a secondary column where relevant.
     - **Global:** **rank on per‑90** for counting stats (with stricter minutes floors), while still displaying totals.
2) **Minutes floors (defaults)**
   - **Local leaderboards:** ≥ **600** minutes.
   - **Local awards:** ≥ **900–1,200** minutes (award‑specific below).
   - **Global leaderboards:** ≥ **1,200** minutes.
   - **Global awards:** ≥ **1,500** minutes (unless noted).
3) **Ratings aggregation**
   - Minutes‑weighted season average; min **10 appearances** and **900 minutes** for rating tables.
4) **League prestige weight (optional)**
   - `prestige_weight ∈ [0.85, 1.15]`, default **1.00** (off by default for transparency).
   - Apply only to **ratings** and **SVS** (see below).
5) **Core composite metrics**
   - **SVS (Season Value Score):** `0.50×AvgRating (+prestige opt) + 0.30×Goal/Assist Impact (+per90 where configured) + 0.20×MOM share`.
   - **Role Score (for ToS/ToY):** role‑specific weighted blend of stats + rating (tunable per role).
6) **Age & eligibility cutoffs**
   - **Young Player:** age **≤21** at **season (Local)** or **window (Global)** start.
7) **Tiebreakers (default order)**
   - Unless otherwise specified by a table/award:
     1. **Fewer minutes** (more efficient)
     2. **Higher Avg Rating**
     3. **Younger age**

> All thresholds are **data‑driven tunables**.

---

## 2. Local (Per‑League) Leaderboards & Awards

### 2.1 Leaderboards (Top 10 by default)
Each table lists **Player, Club, Stat, Apps, Minutes**. Rank on **totals** unless per‑90 is explicitly stated; always display per‑90 in a column where meaningful.

1. **Top Scorers** - most **Goals**.  
   Ties: (1) Fewer minutes, (2) More assists, (3) Higher avg rating.
2. **Top Assists** - most **Assists**.  
   Ties: (1) Fewer minutes, (2) Higher pass accuracy, (3) Higher avg rating.
3. **Highest Average Ratings** - minutes‑weighted **Avg Rating**.  
   Eligibility: **≥900 min** and **≥10 apps**. Ties: (1) More minutes, (2) More MOM.
4. **Most MOM Awards** - total **Man‑of‑the‑Match**.  
   Ties: (1) Higher avg rating, (2) Team league position.
5. **Creative Leaders** - **Key Passes** (includes Through Balls & Switches that register as key pass).  
   Ties: (1) Higher Vision, (2) Pass accuracy, (3) Avg rating.
6. **Take‑On Kings** - **Successful take‑ons**.  
   Ties: (1) Higher Dribbling, (2) Higher success %, (3) Avg rating.
7. **Defensive Stoppers** - index = `Tackles Won + 0.8×Interceptions`.  
   Ties: (1) Higher success %, (2) More minutes, (3) Team GA lower.
8. **Aerial Dominance** - index = `Aerial Clears + 0.7×Offensive Headers Won`.  
   Ties: (1) Higher Heading, (2) More minutes.
9. **Passing Accuracy Leaders** - **Accuracy %** (min **400 attempts**).  
   Ties: (1) More attempts, (2) Avg rating.
10. **Discipline** *(optional)* - **fewest cards per 90** (requires card tracking).

**Eligibility floor for Local leaderboards:** **≥600 minutes** (unless table says otherwise).

### 2.2 Local Awards (trophies + bonuses)
Paid once on league season close and logged in Weekly Economy.

- **League MVP** - highest **SVS**.  
  Eligibility: **≥1,200 minutes**. Reward: `Reputation +2.0`, `Money +$20,000`.
- **Golden Boot** - **most Goals**.  
  Reward: `Reputation +1.5`, `Money +$15,000`.
- **Playmaker of the Year** - **most Assists**.  
  Reward: `Reputation +1.2`, `Money +$12,000`.
- **Young Player of the Year** - top **SVS** among ≤21.  
  Eligibility: **≥900 minutes**. Reward: `Reputation +1.2`, `Money +$10,000`.

**Positional highlights**
- **Attacking Star** - Top 3 in Goals or Avg Rating among ST/MF. Reward: `Rep +0.8`, `+$8,000`.
- **Midfield Maestro** - Top 3 in Assists or Key Passes among MF. Reward: `Rep +0.8`, `+$8,000`.
- **Defensive Rock** - Top **Defensive Stoppers** index among MF/DF. Reward: `Rep +0.8`, `+$8,000`.
- **Aerial Ace** - Top **Aerial Dominance** index. Reward: `Rep +0.5`, `+$5,000`.

**Special mentions**
- **Most Improved** - highest **Δ Avg Rating** between halves (≥600 min in each half). Reward: `Rep +0.5`, `+$3,000`.
- **Iron Man** - most **Minutes**. Reward: `Rep +0.4`, `+$2,000`.
- **Super Sub** - best **Goals/90** with **≤900 minutes** and **≥8 apps**. Reward: `Rep +0.4`, `+$2,000`.

### 2.3 Team of the Season (ToS)
Pick **11 players** (4‑3‑3 template or role‑agnostic best‑fit) ensuring at least **3 DF, 3 MF, 1 ST**; remaining 4 by best **Role Score**. Bench: next best **5**.  
Reward per selected: `Reputation +0.6`, `Money +$3,000`.

---

## 3. Global (Cross‑League) Leaderboards & Awards

### 3.1 Global Leaderboards (Top 20 by default)
Global tables **rank on per‑90** (fairness across calendars) and **display totals** and **minutes**. Stricter eligibility applies.

1. **Top Scorers (per‑90)** - rank by **Goals/90**; show Goals total & Minutes.  
   Ties: (1) Higher total goals, (2) Higher avg rating, (3) Fewer minutes.
2. **Top Assists (per‑90)** - rank by **Assists/90**; show totals & Minutes.  
   Ties: (1) Higher total assists, (2) Pass accuracy, (3) Fewer minutes.
3. **Highest Average Ratings** - minutes‑weighted (optionally **prestige‑adjusted**).  
   Eligibility: **≥1,500 minutes** and **≥15 apps**.
4. **Most MOM Awards** - total MOM.  
   Ties: (1) Avg rating, (2) More minutes.
5. **Creative Leaders** - **Key Passes/90**.
6. **Take‑On Kings** - **Successful take‑ons/90**.
7. **Defensive Stoppers** - index = `Tackles Won/90 + 0.8×Interceptions/90`.
8. **Aerial Dominance** - index = `Aerial Clears/90 + 0.7×Offensive Headers Won/90`.
9. **Passing Accuracy Leaders** - **Accuracy %** (min **800 attempts**).

**Eligibility floors (Global):** leaderboards **≥1,200 min**, awards **≥1,500 min** (unless noted).

### 3.2 Global Awards
- **World MVP** - highest **SVS_global** (same formula; prestige weight optional).  
  Eligibility: **≥1,500 minutes**. Reward: `Reputation +3.0`, `Money +$50,000`.
- **Global Golden Boot** - highest **Goals/90** (ties by total goals, then rating).  
  Reward: `Reputation +2.0`, `Money +$30,000`.
- **Global Playmaker** - highest **Assists/90** (ties by pass accuracy, then rating).  
  Reward: `Reputation +1.8`, `Money +$25,000`.
- **Global Young Player of the Year** - top **SVS_global** among ≤21.  
  Eligibility: **≥1,200 minutes**. Reward: `Reputation +1.5`, `Money +$20,000`.
- **Global Team of the Year (ToY)** - **11** by best **Role Score** (≥4 DF, ≥3 MF, ≥3 ST + **1 wild card**). Bench: next **7**.  
  Reward per selected: `Reputation +0.8`, `Money +$6,000`.
- **Most Improved (Global)** - highest **Δ Avg Rating** between halves (each half **≥600 min**).  
  Reward: `Reputation +0.8`, `Money +$6,000`.
- **Iron Man (Global)** - most **Minutes**. Reward: `Reputation +0.6`, `Money +$4,000`.
- **Super Sub (Global)** - best **Goals/90** with **≤900 minutes** and **≥8 apps**.  
  Reward: `Reputation +0.6`, `Money +$4,000`.

### 3.3 Hidden Gems (ΔOVR Progress)
- **Local Hidden Gems:** ΔOVR across the league season (min **900 min**). Young variant (≤21) available.  
- **Global Hidden Gems:** ΔOVR across the **season window** (min **1,200 min**). Young variant (≤21) available.  
- Default tie‑breakers: (1) Younger age at cutoff, (2) Higher second‑half rating, (3) Fewer minutes.

---

## 4. UI/UX

- **Statistics menu**
  - Tabs: one per **League** + a **Global** tab.
  - Filters: Season window, position (ST/MF/DF), min minutes toggle, prestige weighting toggle.
  - Each table shows **per‑90**, **totals**, **minutes**, **club(s)**.
- **End‑of‑Season flow**
  - Run **Local** awards per league; then show **Global Awards** (MVP, Golden Boot/Playmaker, ToY).
  - Persist accolades to **Career History** (league‑tagged vs global‑tagged). Export a **Season Report** page.

---

## 5. Integration Effects

- **Reputation** and **Money** rewards are credited via **Weekly Economy** on season close.
- **Reputation** feeds **Contracts/Transfers** (interest, PQI inputs).  
- Accolades can unlock minor narrative events (optional).  
- All thresholds, rewards, and weights are **configurable** in data.

---

## 6. Tunables (default values)

- Local leaderboards min minutes: **600**.  
- Local awards min minutes: **900–1,200** (per award).  
- Global leaderboards min minutes: **1,200**.  
- Global awards min minutes: **1,500**.  
- Passing attempts floor (Local/Global): **400 / 800**.  
- `use_prestige_weight = false` by default; `prestige_weight = 1.0` (range **0.85–1.15**).

---

## 7. Changelog (merge)

- Unified **Local** and **Global** specs into a single document with shared metrics and tiebreakers.
- Clarified when to rank on **totals vs per‑90** to satisfy fairness and UX expectations.
- Consolidated **Hidden Gems** into Local + Global variants with ΔOVR and minutes floors.
