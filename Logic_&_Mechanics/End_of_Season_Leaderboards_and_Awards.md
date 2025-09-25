# Footy Star v1.0.1
## End‑of‑Season Leaderboards & Awards (per league)

This spec defines league‑scoped end‑of‑season tables and awards built from the Match/Training/Contracts ecosystem. It runs once at the end of each league season (see League_Calendar.md) and generates persistent accolades that affect Reputation, Contracts, and Weekly Economy.

---

## 1 Data sources and scope

- Scope: per **league season** (e.g., EPL 2025/26), not global.
- Source stats come from Match.md event logs and ratings:
  - Goals, Assists, Key Passes, Successful Long Shots
  - Match Ratings, Man‑of‑the‑Match (MOM)
  - Tackles Won, Interceptions, Aerial Clears (defensive)
  - Dribbles/Take‑ons Won
  - Pass Accuracy (weighted by attempts)
- Minutes played and appearances are tracked for eligibility thresholds.

---

## 2 Leaderboards (top N tables)

Each table shows **Top 10** by default (configurable) with player name, club, stat, appearances, minutes.

1. **Top Scorers** — sorted by Goals.
   - Tiebreakers: (1) Fewer minutes, (2) More assists, (3) Higher average rating.
2. **Top Assists** — sorted by Assists.
   - Tiebreakers: (1) Fewer minutes, (2) Higher pass accuracy, (3) Higher average rating.
3. **Highest Average Ratings** — sorted by Season Avg Rating.
   - Eligibility: min **900 minutes** and **10 appearances**.
   - Tiebreakers: (1) More minutes, (2) More MOM awards.
4. **Most MOM Awards** — total Man‑of‑the‑Match.
   - Tiebreakers: (1) Higher avg rating, (2) Team league position.
5. **Creative Leaders** — Key Passes (includes Through Balls and Switches that register as key passes).
   - Tiebreakers: (1) Higher Vision, (2) Higher pass accuracy, (3) Avg rating.
6. **Take‑On Kings** — Successful 1v1 take‑ons.
   - Tiebreakers: (1) Higher Dribbling, (2) Higher success %, (3) Avg rating.
7. **Defensive Stoppers** — Tackles Won + Interceptions (weighted 1.0 and 0.8 respectively).
   - Tiebreakers: (1) Higher success %, (2) More minutes, (3) Team GA lower.
8. **Aerial Dominance** — Aerial Clears + Offensive Headers Won (weighted 1.0 and 0.7).
   - Tiebreakers: (1) Higher Heading, (2) More minutes.
9. **Passing Accuracy Leaders** — Pass accuracy % (min 400 pass attempts).
   - Tiebreakers: (1) More attempts, (2) Avg rating.
10. **Discipline** (optional) — Fewest cards per 90 (requires card tracking).

All leaderboards enforce an eligibility floor of **600 minutes** unless otherwise specified.

---

## 3 Awards (trophies and bonuses)

Awards are determined using the leaderboards and rating aggregates. Prizes are paid once on season close and logged in Weekly Economy.

### 3.1 Major awards
- **League MVP** (Most Valuable Player)
  - Criteria: highest **Season Value Score (SVS)** = 50% Avg Rating + 30% Goal/Assist Impact + 20% MOM share.
  - Eligibility: min 1,200 minutes.
  - Rewards: `Reputation +2.0`, `Money +$20,000`.
- **Golden Boot** (Top Scorer)
  - Criteria: most Goals. Tie by fewer minutes, then more assists.
  - Rewards: `Reputation +1.5`, `Money +$15,000`.
- **Playmaker of the Year**
  - Criteria: most Assists. Tie by fewer minutes, then higher pass accuracy.
  - Rewards: `Reputation +1.2`, `Money +$12,000`.
- **Young Player of the Year**
  - Criteria: SVS among players aged **≤21** at season start.
  - Eligibility: min 900 minutes.
  - Rewards: `Reputation +1.2`, `Money +$10,000`.

### 3.2 Positional highlights
- **Attacking Star**
  - Criteria: Top 3 in Goals or Avg Rating among ST/MF; committee pick if close.
  - Reward: `Reputation +0.8`, `Money +$8,000`.
- **Midfield Maestro**
  - Criteria: Top 3 in Assists or Key Passes among MF.
  - Reward: `Reputation +0.8`, `Money +$8,000`.
- **Defensive Rock**
  - Criteria: top **Defensive Stoppers** index among MF/DF.
  - Reward: `Reputation +0.8`, `Money +$8,000`.
- **Aerial Ace**
  - Criteria: top **Aerial Dominance** index.
  - Reward: `Reputation +0.5`, `Money +$5,000`.

### 3.3 Special mentions
- **Most Improved**
  - Criteria: highest positive delta in Avg Rating between first and second half of season (min 600 minutes in both halves).
  - Reward: `Reputation +0.5`, `Money +$3,000`.
- **Iron Man**
  - Criteria: most minutes played.
  - Reward: `Reputation +0.4`, `Money +$2,000`.
- **Super Sub**
  - Criteria: most goals per 90 among players with ≤900 minutes.
  - Reward: `Reputation +0.4`, `Money +$2,000`.

All reward amounts are defaults and league‑agnostic; they can scale with league prestige if desired.

---

## 4 Team of the Season (ToS)

Pick **11 players** ignoring exact formations (or use a simple 4‑3‑3 template). Roles available in Footy Star: ST, MF, DF. Select by highest RoleOVR‑weighted season performance:
- Compute a **Role Score** using role‑specific weights on stats and rating.
- Ensure at least: 3 DF, 3 MF, 1 ST; remaining 4 best available regardless of role.
- Bench: next best 5. Show club and per‑game contributions.

Rewards per player selected: `Reputation +0.6`, `Money +$3,000`.

---

## 5 Tiebreakers and eligibility (global)

- Minutes floors: unless stated, award eligibility requires **900 minutes**; leaderboards require **600 minutes**.
- Tiebreakers order, unless overridden: (1) fewer minutes, (2) higher Avg Rating, (3) younger age.
- Age cutoff for Young Player: age on **season start date**.
- Exclusions: players suspended for misconduct > 3 matches can be excluded from special mentions (config).

---

## 6 Integration effects

- **Reputation** deltas apply immediately and feed Contracts (increased interest and PQI inputs).
- **Money** prizes are credited in Weekly Economy on season close.
- Accolades are shown on the player profile (Career tab) and can unlock minor narrative events.
- Optionally, awards can add small passive boosts for one season (e.g., MVP: +0.1 CoachRelation baseline). Disabled by default.

---

## 7 UI/UX

- End‑of‑season screen:
  - Leaderboard tabs: Scorers, Assists, Ratings, MOM, Creative, Take‑Ons, Defensive, Aerial, Passing.
  - Awards tab with trophy cards and rewards.
  - Team of the Season with player cards.
- Export summary to a season report page accessible from Career History.

---

## 8 notes

- Persist per‑match stat deltas; compute season aggregates per league on the final week.
- Pre‑compute derived indices (Defensive Stoppers, Aerial Dominance, SVS) to keep UI cheap.
- All thresholds (minutes floors, rewards) are data‑driven tunables.
- Run awards once per league season, after playoffs if present.
