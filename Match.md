# Footy Star v1.0.1
## 1. Match & Moments Engine

### 1.1 Number of moments per match
- Base by role (for 90’): ST 4.0, MF 3.0, DF 2.5.  
- Scaled by minutes: `exp = base * minFactor`, where `minFactor = clamp(min/90, 0.3..1.0)`.  
- Jitter: ±0.8 random (normal), rounded to integer ≥ 1.  
- Type distribution (ST): Box Finish 0.45, Header 0.25, 1v1 0.15, Long Shot 0.15.  
- (MF): Through Ball 0.45, Switch 0.25, Edge Shot 0.30.  
- (DF): Stand Tackle 0.50, Interception 0.30, Aerial Clear 0.20.

### 1.2 Success calculation (with new skills)

#### Player score for the moment
`S = Σ(weight_i * skill_i) + m_confidence + m_context`  

- `m_confidence = −5…+5` (derived from the average of the last 3 ratings).  
- `m_context` aggregates small, type-specific bonuses from new skills (caps noted below).  

**Context bonuses (apply only to relevant moment types; each capped at +2):**
- **Bravery**: +`0.04*(Bravery − 50)` to **Stand Tackle** and **Aerial Clear**. (cap +2)  
- **Technique**: +`0.03*(Technique − 50)` to **1v1 vs GK** and **Edge Shot** ball control phases. (cap +1.5)  
- **Vision**: +`0.05*(Vision − 50)` to **Through Ball** and **Switch of Play**. (cap +2)  
- **Power**: +`0.04*(Power − 50)` to **Long Shot**. (cap +2)  
- **Leadership (captain on pitch)**: team aura adds `+team_lead` to every teammate’s `m_confidence`, where `team_lead = clamp( (CaptainLeadership − 60)/10, 0..2 )`.

#### Difficulty (D) is continuous
`D = baseD(type) + OppFac + k_league * (xp_index - 1.0) + TimeFatigue`  

- `xp_index` comes from league JSON (0.85/1.00/1.15/1.30).  
- `k_league` controls the impact of xp_index on difficulty (default **6**).  
- `OppFac = clamp((OppTeamRating - 60) / 2, -10, +15)` (MVP uses opponent’s team OVR).  
- `TimeFatigue = max(0, (minute - 70)/20) * clamp(15 - 0.1*Stamina, 0, 15) * (1 - 0.15*Recovery/100)`  
  (Recovery slightly mitigates late-match decay; at 100 Recovery, TimeFatigue is ~15% lower).

#### Probability (logistic)
`p = clamp( sigmoid((S - D)/6), 0.05, 0.95 )`

#### Effects
- Offensive success produces a goal in Box/1v1/LongShot (100% of “success” = finish).  
- Offensive header: 85% goal, 15% wide (still counts as a “big chance”, rating +0.3).  
- Through Ball: 60% **assist**, 40% “key pass” (no goal).  
- Switch: “successful switch” (rating +0.2).  
- Edge Shot: 55% goal on success; otherwise “on target” (rating +0.2).  
- Stand Tackle / Interception / Aerial Clear successes grant rating +0.5 / +0.4 / +0.3 respectively.  
- **Brave Block** (DF only): if a shot is blocked within 10m of goal and Bravery ≥ 70, extra rating **+0.2**.

### 1.3 XP/SP per moment (before global multipliers)
- Offensive success: **+8 XP** to the primary skill, **+4 XP** to a secondary.  
- Offensive failure: **+3 XP** to the primary.  
- Defensive success: **+6 XP** (Tackling/Interception/Heading accordingly).  
- **Vision moments** (Through Ball/Switch): +1 bonus XP to Vision on success.  
- **Bravery moments** (Stand Tackle/Aerial Clear/Brave Block): +1 bonus XP to Bravery on success.  
- Then apply: `minFactor * rateFactor * xp_index * mmrFactor`.  
- **SP per match** (at the end): `base 5 + 2 per goal + 1 per assist + 1 if MOM`, also multiplied by `minFactor * rateFactor * xp_index * mmrFactor`.

### 1.4 Match rating (1–10) with Consistency
- Base 6.0.  
- Positive events: Goal +1.2, Assist +0.8, Key Pass +0.3, Good Switch +0.2, Brave Block +0.2.  
- Defensive events: Stand Tackle +0.5, Interception +0.4, Aerial Clear +0.3.  
- Negative events: Clear missed 1v1 −0.4, bad First Touch that kills a play −0.3.  
- **Consistency reduces volatility** of rating noise: `σ = σ_base * (1 − 0.007*(Consistency − 50))`, clamp `σ ∈ [0.25, 0.50]` with `σ_base = 0.45`.  
- Clamp final rating **4.5–10.0**. MOM = highest rating; ties broken by offensive contribution.

---

## 2. Minutes / Selection (no energy)

### Weekly Selection Score (with Determination, Leadership & CoachRelation)
`Sel = 0.55*RoleOVR + 0.18*Reputation + 0.15*CoachRelation + 0.07*Determination + 0.03*Leadership + ε`

- `ε` is normal noise ±2, **scaled by Consistency** using the same `σ` rule as above.  
- Injury/ban zeroes it (see §3).

### 2.1 CoachRelation evolution
Weekly change:  
```
ΔCoachRelation = BaseEvent
               + 0.01*(Consistency - 50)
               + 0.015*(Determination - 50)
               + team_lead_bonus
```
- **BaseEvent** = +1 for good training (rating ≥7.0) / −2 for negative events or skipped training.  
- **Consistency** → improves odds of stable positive relation.  
- **Determination** → boosts effect of training & effort (up to ±1.5 swing).  
- **Leadership** → if Leadership ≥ 75, teammates gain +0.1 each (team_lead_bonus).  
- Clamp total Δ to [−3, +3] per week.

### Minutes played (unchanged)
- If `Sel >= 70` -> **90’**.  
- 60–69 -> **75–85’** (random).  
- 50–59 -> **45–70’**.  
- <50 -> **0–30’** (bench).

### RoleOVR
Weighted average of the skills per role (see **Skills** doc).

---

## 3. Injuries & knocks (unchanged from v1.0.2)
- Risk uses Bravery (↑), Flexibility (↓).  
- Downtime reduced by Recovery.  
- Post-injury: Sel=0 until healed; −1 confidence in return match.

---

## 4. Reputation & leadership hooks

### 4.1 Reputation change (per match)
`rep_delta = clamp( k_rep * (rating - 6.8) * minFactor * xp_index, -2, +2 )` with `k_rep = 1.2`.

**Modifiers:**
- **MOM**: +1.0  
- **Goal/Assist**: +0.5 (max +1.0 from events)  
- **Determination**: reduces negative swings: multiply negative `rep_delta` by `(1 − 0.3*Determination/100)` (up to −30%).  
- **Leadership (captain + win)**: +0.2 bonus.  

### 4.2 Confidence (teamwide)
- Per §1.2, captain’s Leadership adds a small team-wide confidence bonus `team_lead` while on the pitch.

---

## 5. Tuning constants (v1.0.1 defaults)
- `k_league = 6`  
- Confidence range ±5  
- Team leadership aura cap = **+2.0** confidence  
- TimeFatigue Recovery mitigation = **15%** at Recovery=100  
- Injury base chance **4%**, risk clamp **[1%,10%]**  
- Consistency volatility cap: `σ ∈ [0.25, 0.50]`  
- CoachRelation Δ clamp: [−3, +3] per week  
