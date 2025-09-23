# Footy Star v1.0.1
## 1. Match & Moments Engine

### 1.1 Number of moments per match

- Base by role (for 90’): ST 4.0, MF 3.0, DF 2.5.
- Scaled by minutes: `exp = base * minFactor`, where `minFactor = clamp(min/90, 0.3..1.0)`.
- Jitter: ±0.8 random (normal), rounded to integer ≥ 1.
- Type distribution (ST): Box Finish 0.45, Header 0.25, 1v1 0.15, Long Shot 0.15.
- (MF): Through Ball 0.45, Switch 0.25, Edge Shot 0.30.
- (DF): Stand Tackle 0.50, Interception 0.30, Aerial Clear 0.20.

### 1.2 Success calculation

#### Player score for the moment

- `S = Σ(weight_i * skill_i) + m_confidence`
- `m_confidence = −5…+5` (derived from the average of the last 3 ratings).

#### Difficulty (D) is continuous

- `D = baseD(type) + Lfac + OppFac + TimeFatigue`
- `baseD` (defaults): Box 50, 1v1 56, Header 54, LongShot 62, ThroughBall 55, Switch 52, EdgeShot 58, StandTackle 56, Interception 54, AerialClear 52.
- `Lfac = (leagueTier - 2) * 3` ⇒ Tier1: −3, Tier2: 0, Tier3: +3, Tier4: +6.
- `OppFac = clamp((OppTeamRating - 60) / 2, -10, +15)` (uses opponent’s team rating; MVP: team overall).
- `TimeFatigue = max(0, (minute - 70)/20) * clamp(15 - 0.1*Stamina, 0, 15)`.

#### Probability (logistic)

`p = clamp( sigmoid((S - D)/6), 0.05, 0.95 )`

#### Effects

- Offensive success produces a goal in Box/1v1/LongShot (100% of “success” = finish).
- Offensive header: 85% goal, 15% wide (still counts as a “big chance”, rating +0.3).
- Through Ball: 60% **assist**, 40% “key pass” (no goal).
- Switch: “successful switch” (rating +0.2).
- Edge Shot: 55% goal on success; otherwise “on target” (rating +0.2).
- Stand Tackle / Interception / Aerial Clear successes grant rating +0.5 / +0.4 / +0.3 respectively.

### 1.3 XP/SP per moment (before global multipliers)

- Offensive success: **+8 XP** to the primary skill, **+4 XP** to a secondary.
- Offensive failure: **+3 XP** to the primary.
- Defensive success: **+6 XP** (Tackling/Interception/Heading accordingly).
- Then apply: `minFactor * rateFactor * leagueFactor * mmrFactor`.
- **SP per match** (at the end): `base 5 + 2 per goal + 1 per assist + 1 if MOM`, also multiplied by `minFactor * rateFactor * leagueFactor * mmrFactor`.

### 1.4 Match rating (1–10)

- Base 6.0.
- Goal +1.2, Assist +0.8, Key Pass +0.3, Good Switch +0.2.
- Stand Tackle +0.5, Interception +0.4, Aerial Clear +0.3.
- Clear missed 1v1 −0.4, bad First Touch that kills a play −0.3.
- Clamp 4.5–10.0. MOM = highest rating; ties broken by offensive contribution.

This connects 1:1 to the **moment weights** already defined.

## 2. Minutes / Selection (no energy)

### Weekly Selection Score

`Sel = 0.6*RoleOVR + 0.2*Reputation + 0.2*CoachRelation + ε`

`ε` is normal noise ±2. Injury/ban zeroes it.

### Minutes played

- If `Sel >= 70` ⇒ **90’**.
- 60–69 ⇒ **75–85’** (random).
- 50–59 ⇒ **45–70’**.
- <50 ⇒ **0–30’** (bench).

### RoleOVR

For ST/MF/DF = weighted average of the 18 skills (different weights per role; to be locked separately).

### Reputation

Goes up if rating > 6.8; goes down if < 6.0 (scaled by `leagueFactor`).

### CoachRelation

+1 for consistent training and matches ≥ 7.0; −2 if you skip training / negative events.
