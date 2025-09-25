# Footy Star v1.0.1
## League_Calendar — Realistic League Durations (data‑driven)

This file defines a **data model** and **ready‑to‑use presets** for real‑world league durations. The calendar is league‑scoped: each league has its own start/end, number of matchdays, transfer windows, cup rounds and international breaks. Systems that consume this (Match, Training, Weekly Economy, Random Events, Contracts) operate in **weeks** derived from these dates.

No emojis. All money is in USD elsewhere; this file has no currency usage.

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
  "notes": "Dates are representative defaults; tune per season if needed."
}
```

Guidelines:
- **intl_breaks_fifa** lists FIFA match windows for the season (approximate). During these, reduce domestic fixtures.
- **domestic_cup.round_weeks_hint** are relative week indices from season start; exact fixtures are drawn by the competition module.
- **regular_week_pattern.midweek_probability** helps the engine schedule midweeks realistically without a full fixture list.
- **transfer_windows** must align with Contracts (offer periods).

---

## 2 Engine consumption

From any league record:
1. Build a **week index** from `start_date` to `end_date` (inclusive).  
2. Tag weeks as: **League MD**, **Midweek MD**, **Cup**, **International Break**, or **Idle** using the pattern and hints.  
3. Training: when a **Midweek MD** or **International Break** occurs, Training System adapts volume (already supported).  
4. Weekly Economy: salary posts each week; **match bonuses** post on played weeks; business income posts every week.  
5. Random Events: roll after match/training and before economy close, respecting cooldowns and caps.  
6. Contracts: enforce **transfer_windows** for offer creation/acceptance.

---

## 3 Presets (typical real‑world durations by league)

> Dates below are **typical month windows** and **matchday counts**. Use them as defaults; adjust per actual season if you later ingest real schedules.

### 3.1 Europe — Top 5

- **Premier League (EPL)**
  - Teams: 20, Matchdays: **38**
  - Season: **Aug-May**
  - Transfer windows: **Jul-Aug (summer)**, **Jan (winter)**
  - Domestic cups: FA/League Cup interspersed midweeks
  - Intl breaks: Sep, Oct, Nov, Mar

- **LaLiga**
  - Teams: 20, Matchdays: **38**
  - Season: **Aug-May**
  - Windows: **Jul-Aug**, **Jan**
  - Cups: Copa del Rey (midweeks), Supercopa (Jan)
  - Intl breaks: Sep, Oct, Nov, Mar

- **Serie A**
  - Teams: 20, Matchdays: **38**
  - Season: **Aug-May**
  - Windows: **Jul-Aug**, **Jan**
  - Cups: Coppa Italia (midweeks)
  - Intl breaks: Sep, Oct, Nov, Mar

- **Bundesliga**
  - Teams: 18, Matchdays: **34**
  - Season: **Aug-May**
  - Windows: **Jul-Aug**, **Jan**
  - Cups: DFB‑Pokal
  - Intl breaks: Sep, Oct, Nov, Mar

- **Ligue 1**
  - Teams: **18**, Matchdays: **34** (since 2023/24)
  - Season: **Aug-May**
  - Windows: **Jul-Aug**, **Jan**
  - Cups: Coupe de France
  - Intl breaks: Sep, Oct, Nov, Mar

### 3.2 Europe — Others

- **Liga Portugal** (Primeira Liga)
  - Teams: 18, Matchdays: **34**
  - Season: **Aug-May**
  - Windows: **Jul-Aug**, **Jan**
  - Cups: Taça de Portugal, Taça da Liga (midweeks)
  - Intl breaks: Sep, Oct, Nov, Mar

- **Eredivisie**
  - Teams: 18, Matchdays: **34**
  - Season: **Aug-May**
  - Windows: **Jul-Aug**, **Jan**
  - Cups: KNVB Beker
  - Intl breaks: Sep, Oct, Nov, Mar

- **EFL Championship (England 2)**
  - Teams: 24, Matchdays: **46**
  - Season: **Aug-May**
  - Windows: **Jul-Aug**, **Jan**
  - Playoffs: Yes (May)
  - Intl breaks: Sep, Oct, Nov, Mar

- **LaLiga 2 (Spain Segunda)**
  - Teams: 22, Matchdays: **42**
  - Season: **Aug-Jun**
  - Windows: **Jul-Aug**, **Jan**
  - Playoffs: Yes (late May-Jun)

### 3.3 Americas

- **MLS (USA/Canada)**
  - Teams: ~28-30, Regular season ~**34** matches + playoffs
  - Season: **Feb-Oct/Nov**
  - Windows: primary **Feb-Apr**, secondary **Jul-Aug** (approx.)
  - Intl breaks: typically partial observance

- **Brasileirão Série A**
  - Teams: 20, Matchdays: **38**
  - Season: **Apr-Dec**
  - Windows: vary (mid‑year & year‑end local windows)
  - Cups: Copa do Brasil (midweeks)

### 3.4 Optional cups/internationals
If you simulate continental competitions (UEFA/Libertadores), reserve **midweeks** from Sep to May for group/knockout phases. Otherwise, keep midweek probability to ~0.30 for league catch‑ups.

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

