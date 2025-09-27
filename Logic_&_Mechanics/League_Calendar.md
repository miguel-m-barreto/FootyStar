# Footy Star v1.0.1

## League_Calendar - Realistic League Durations (data‑driven)

This file defines a **data model** and **ready‑to‑use presets** for real‑world league durations. The calendar is league‑scoped: each league has its own start/end, number of matchdays, transfer windows, cup rounds and international breaks. Systems that consume this (Match, Training, Weekly Economy, Random Events, Contracts) operate in **weeks** derived from these dates.

---

## 1 Data model (per league)

```json
{
  "league_id": "EPL",
  "name": "Premier League",
  "season": "2025/26",
  "start_date": "2025-08-09",
  "end_date": "2026-05-17",
  "teams": 20,
  "matchdays": 38,
  "league_format": "double_round_robin",
  "regular_week_pattern": {
    "primary_matchday": "Sat/Sun",
    "secondary_matchday": "Tue/Wed",
    "midweek_probability": 0.30
  },
  "domestic_cup": {
    "enabled": true,
    "rounds": 5,
    "round_weeks_hint": [10, 18, 25, 32, 37]
  },
  "intl_breaks_fifa": [
    { "start": "2025-09-01", "end": "2025-09-09" },
    { "start": "2025-10-06", "end": "2025-10-14" },
    { "start": "2025-11-10", "end": "2025-11-18" },
    { "start": "2026-03-23", "end": "2026-03-31" }
  ],
  "transfer_windows": [
    { "name": "summer", "start": "2025-07-01", "end": "2025-09-01" },
    { "name": "winter", "start": "2026-01-01", "end": "2026-01-31" }
  ],
  "playoffs": { "enabled": false },
  "prestige_weight": 1.0,
  "notes": "Dates are representative defaults; tune per season if needed."
}
```

Guidelines:
- **intl_breaks_fifa** lists FIFA match windows for the season (approximate). During these, reduce domestic fixtures.
- **domestic_cup.round_weeks_hint** are relative week indices from season start; exact fixtures are drawn by the competition module.
- **regular_week_pattern.midweek_probability** helps the engine schedule midweeks realistically without a full fixture list.
- **transfer_windows** must align with Contracts (offer periods).

> NOTE: contracts can be offered outside transfer_windows if they are from the club the player is currently in

---

## 2 Engine consumption

From any league record:
1. Build a **week index** from `start_date` to `end_date` (inclusive).  
2. Tag weeks as: **League MD**, **Midweek MD**, **Cup**, **International Break**, or **Idle** using the pattern and hints.  
3. **Training System** lowers volume on Midweeks/Intl breaks.  
4. **Weekly Economy**: salaries each week; match bonuses only on match weeks; business income every week.  
5. **Random Events** roll after match/training, before economy close. Flags may trigger follow‑ups (Events.md).  
6. **Contracts/Transfers** enforce **transfer_windows** for offers and registrations.  
7. **System Notifications** emit concise alerts (“Transfer window OPEN”, “Intl break this week”).


---

## 3 Presets (typical real‑world durations by league)

> Dates below are **typical month windows** and **matchday counts**. Use as defaults; adjust per actual season if later ingest real schedules.

### 3.1 Europe - Top 5
- **Premier League (EPL)**: 20 teams, 38 MD, Aug–May, windows Jul–Aug + Jan.  
- **LaLiga**: 20 teams, 38 MD, Aug–May. Cups midweeks.  
- **Serie A**: 20 teams, 38 MD, Aug–May. Cups midweeks.  
- **Bundesliga**: 18 teams, 34 MD, Aug–May. Cups = DFB Pokal.  
- **Ligue 1**: 18 teams, 34 MD, Aug–May. Cups = Coupe de France.

### 3.2 Europe - Others
- **Liga Portugal**: 18 teams, 34 MD, Aug–May. Cups: Taça Portugal + Taça Liga.  
- **Eredivisie**: 18 teams, 34 MD, Aug–May. Cups: KNVB Beker.  
- **EFL Championship**: 24 teams, 46 MD, Aug–May. Playoffs in May.  
- **LaLiga 2**: 22 teams, 42 MD, Aug–Jun. Playoffs late May–Jun.

### 3.3 Americas
- **MLS**: ~30 teams, 34 MD + playoffs, Feb–Nov. Two windows (Feb–Apr, Jul–Aug).  
- **Brasileirão Série A**: 20 teams, 38 MD, Apr–Dec. Local window rules.

### 3.4 Continental cups
If simulating UEFA/Libertadores, reserve midweeks from Sep–May. Otherwise set `midweek_probability ≈ 0.30`.

---

## 4 Minimal JSON examples

```json
{
  "league_id": "LIGA_PT",
  "name": "Liga Portugal",
  "season": "2025/26",
  "start_date": "2025-08-09",
  "end_date": "2026-05-24",
  "teams": 18,
  "matchdays": 34,
  "league_format": "double_round_robin",
  "regular_week_pattern": { "primary_matchday": "Sat/Sun", "secondary_matchday": "Tue/Wed", "midweek_probability": 0.25 },
  "domestic_cup": { "enabled": true, "rounds": 5, "round_weeks_hint": [12, 18, 24, 31, 36] },
  "intl_breaks_fifa": [
    { "start": "2025-09-01", "end": "2025-09-09" },
    { "start": "2025-10-06", "end": "2025-10-14" },
    { "start": "2025-11-10", "end": "2025-11-18" },
    { "start": "2026-03-23", "end": "2026-03-31" }
  ],
  "transfer_windows": [
    { "name": "summer", "start": "2025-07-01", "end": "2025-09-01" },
    { "name": "winter", "start": "2026-01-01", "end": "2026-01-31" }
  ],
  "playoffs": { "enabled": false }
}
```

```json
{
  "league_id": "MLS",
  "name": "Major League Soccer",
  "season": "2026",
  "start_date": "2026-02-22",
  "end_date": "2026-11-10",
  "teams": 30,
  "matchdays": 34,
  "league_format": "balanced_schedule_plus_rivals",
  "regular_week_pattern": { "primary_matchday": "Sat", "secondary_matchday": "Wed", "midweek_probability": 0.35 },
  "domestic_cup": { "enabled": true, "rounds": 5, "round_weeks_hint": [8, 14, 20, 28, 33] },
  "intl_breaks_fifa": [
    { "start": "2026-03-23", "end": "2026-04-01" },
    { "start": "2026-06-01", "end": "2026-06-15" },
    { "start": "2026-09-01", "end": "2026-09-09" },
    { "start": "2026-10-05", "end": "2026-10-13" }
  ],
  "transfer_windows": [
    { "name": "primary", "start": "2026-02-10", "end": "2026-04-30" },
    { "name": "secondary", "start": "2026-07-10", "end": "2026-08-12" }
  ],
  "playoffs": { "enabled": true, "start_week_hint": 35 }
}
```

---

## 5 Integration checklist

- Match engine uses **matchdays** and **midweek_probability** to schedule moments volume (no change in formulas).  
- Training System lowers volume on **midweeks** and during **intl_breaks_fifa**.  
- Weekly Economy posts salary each week and bonuses on match weeks.  
- Contracts use **transfer_windows** for offers.  
- Random Events roll weekly after matches/training; they ignore intl breaks unless an event requires national team context (future).

---

## 6 Tuning knobs

- `midweek_probability` per league (0.20-0.40 typical in Europe).  
- `round_weeks_hint` density for domestic cups.  
- Add/remove intl breaks for special seasons.  
- Shift transfer windows within typical local rules if you later import an authoritative dataset.


---

## 7 Season generation

Each new season advances dates by 1 year (2025/26 → 2026/27). Templates shift automatically: start/end, intl breaks, windows.  
Supports infinite progression without static datasets.

> Transfers between other teams can might occur, like players from other teams should be able to go to other teams and to our team etc, the player is not the only player that can swap teams.