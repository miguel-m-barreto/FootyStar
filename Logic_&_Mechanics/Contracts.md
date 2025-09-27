# Footy Star v1.0.1

**Transfer windows are authoritative from `League_Calendar.md` per league/season.**  
Any week numbers shown here (e.g., **weeks 9–11** and **19–20** for MVP) are **defaults** only.

## Contracts System

I’ve concluded that generic “tiers” are weak for simulating real-world football. This system is fully **data-driven** by league, club and player.

### Contract object

#### 1 Each offer/contract contains
- `club_id`, `league_id`
- `weekly_wage`
- `role`: Bench | Rotation | Starter | Key
- `position`: ST | MF | DF
- `duration_weeks`: 20 (MVP)
- `bonuses`: `per_goal`, `per_assist`, `per_mom` (defaults below)
- `signing_on`: one-off fee (defaults below)
- `valid_until_week` (offer expiry)
- `starts_at_week`: `now` | `end_of_season` (pre-contract)

> In v1.0.1 all contracts are 1 season; multi-year comes later.

---

#### 2 Salary target (how the club computes what to pay)

Single pipeline; all knobs are data:

```
target_wage = round_to_50(
  * LeagueBasePos[league][position]          // league median per position (weekly)
  * ClubPercentileMult(percentile)           // club’s place in league wage distribution (0..1)
  * PlayerQualityMult(OVR, Rep, Potential, Consistency, Determination)
  * RoleMult(role)                           // Bench/Rot/Starter/Key
  * StrategicPriorityMult(SPP)               // how badly the club wants you (now includes Leadership/Consistency)
  * AuctionPressureMult(n_bidders)           // market competition
)
```

#### 2.1 League base (examples for a template league set)

These are league medians per position, weekly; to be replaced with real data later:
- League Three: ST $450, MF $400, DF $375
- League Two: ST $1,100, MF $1,000, DF $900
- Top Flight: ST $3,000, MF $2,800, DF $2,600
- Elite (continental): ST $7,000, MF $6,500, DF $6,000

#### 2.2 Club percentile multiplier

How rich the club is vs its league peers:

`ClubPercentileMult(p) = 0.6 + 0.8 * p`  -> `p ∈ [0..1]` -> `[0.6..1.4]`

#### 2.3 Player quality multiplier (OVR drives pay; rep/potential matter)

```
OVRn = clamp((OVR - 50) / 40, 0..1)          // 50->0, 90->1
REPn = Reputation / 100                       // 0..1
PROn = clamp((Potential - OVR) / 20, 0..1)    // “wonderkid gap”
PQI  = 0.50*OVRn + 0.25*REPn + 0.15*PROn
     + 0.05*(Consistency/100) + 0.05*(Determination/100)

PlayerQualityMult = 0.75 + 0.75*PQI           // 0.75..1.50
```

#### 2.4 Role multiplier

`Bench 0.8 • Rotation 1.0 • Starter 1.2 • Key 1.5`

#### 2.5 Strategic priority (club obsession)

When the club really wants you:

`None 1.00 • Hot 1.20 • Priority 1.35 • Obsessed 1.60`

SPP comes from **DesireScore** (need + fit + wonderkid + marketing **+ soft signals**). New soft signals:
- **Leadership ≥ 75** -> `+0.05` DesireScore.
- **Consistency ≥ 70** -> `+0.05` DesireScore.
- **CoachRelation**: if the head coach rates you highly -> small boost/penalty:
  - `CoachRelation ≥ 70` -> `+0.05`
  - `CoachRelation ≤ 30` -> `−0.05`

#### 2.6 Auction pressure (multiple big clubs bidding)

`AuctionPressureMult = 1.00 + 0.10 * (n_bidders - 1)` (cap at **1.30**)

#### 2.7 Hard constraints (reality checks)
- **Blocker:** `target_wage ≤ club.max_weekly_wage`
- **Blocker:** `target_wage ≤ club.wage_bill_room`

---

#### 3 Negotiation

- You get **3 counters** per offer.
- Asking up to **+10%** over `target_wage` is often accepted; **+20%** is unlikely; **>20%** needs SPP “Obsessed”.
- **Signing-on fee** = **2 × weekly_wage** (one-off).
- **Bonuses** (defaults; can vary by club later): Goal $200, Assist $100, MOM $400.
- Offer **expires in 2 weeks**; multiple offers can be active.

**Behavioral modifiers:**
- **Determination ≥ 70** -> player tolerates slightly lower final wage: accept-threshold `+2%` wider in club’s favor.
- **Consistency ≥ 70** -> asks for **fewer clauses** (no change in wage math; improves acceptance odds by a small factor internally).
- **Leadership ≥ 80** -> player may request a **captaincy premium** (`+5%` on wage expectation) if the club promises captain/vice role.

---

#### 4 Role affects minutes (after signing)

- Selection bonus to weekly **Selection Score**: Bench +0, Rotation +5, Starter +10, Key +20.
- Typical minute floors (health permitting): Bench 0-30’, Rotation 45-75’, Starter 75-90’, Key ~90’.

> `CoachRelation` follows the evolution rules in **Match.md v1.0.1** and feeds into selection and SPP soft signals.

---

#### 5 Live market & agent (interest over time)

- Weekly update of **Interest** (0-100) for you per club.
- **States by threshold**: Monitoring ≥40 -> Enquiry ≥60 -> Offer ≥80.
- **Decay**: −8%/week if ignored. **Max 2** new Enquiries/week.
- **Windows** (MVP): **Weeks 9-11** and **19-20**. Pre-sign for end of season anytime.
- **Agent controls**: Satisfied / Explore / Actively Seeking (adds 0.0 / +0.2 / +0.4 to Interest), favorites/no-go lists, wage expectation (×0.9…×1.3).

**Interest drivers (reweighted):**
- 30% **Performance** (avg last 5 ratings × minutes factor)
- 20% **RoleNeed** (club needs your role)
- 15% **Reputation**
- 10% **Fit** (club playstyle vs your skill mix)
- 10% **AgentPush** (+ “Show Interest” ping)
- 5% **Favorite** (club is on your list)
- 5% **CoachRelation** (coach signals/endorsement)
- −10% **WagePressure** (expectation vs max pay)
- +Affordability gate (wage room & fee budget)

---

#### 6 Transfer fees (simple but realistic)

**MarketValue:**
```
MV = BasePosValue[pos] * exp(0.035*(OVR - 60)) * age_fac * club_prestige_fac
BasePosValue: ST $1.2M • MF $1.0M • DF $0.8M
age_fac: 18->0.9 … 26->1.2 … 34->0.7
club_prestige_fac: 0.9..1.2 (selling club)
```

**Leadership/Consistency/Determination multipliers (small, capped):**
```
MV *= (1 + clamp(0.002*(Consistency - 50), -0.10, +0.10))
MV *= (1 + clamp(0.002*(Determination - 50), -0.10, +0.10))
MV *= (1 + clamp(0.003*(Leadership - 50),  -0.15, +0.15))
```
*(At most ~+20% combined uplift for elite profiles.)*

**Contract leverage:**
```
fee = MV * (0.8 + 0.15 * years_left)  // 0y=0.8…3y=1.25, ±10% noise
```
**Bosman:** ≤6 weeks remaining -> pre-contract (free transfer at season end).

---

#### 7 Examples (sanity check)

- **Lower-league bench DF, OVR 62, Rep 30, poor club (p=0.2), Cons 55, Det 60, Lead 45**  
  Base $375 -> Club 0.76 -> PQM ~1.00 -> Role 0.8 -> **~$260-$310/week**
  
- **Elite club starter MF, 17yo wonderkid, OVR 70, Potential 90, Rep 55, Cons 72, Det 78, Lead 68, CoachRel 75**  
  Base $6,500 -> Club ~1.384 -> PQM ~1.22 (Cons/Det help) -> Role 1.2 -> **~$13.4k**  
  SPP Priority (+Leadership/Consistency, +CoachRel soft) ×~1.40 -> **~$18.8k**  
  Auction (2 bidders) ×1.15 -> **~$21.6k/week** (Key role could push **$26-30k**).

---

#### 8 Data schema (plug-and-play with real leagues)

**League JSON (per league)**
```json
{
  "league_id": "ELITE",
  "base_weekly": { "ST": 7000, "MF": 6500, "DF": 6000 },
  "xp_index": 1.30
}
```

**Club JSON (per club)**
```json
{
  "club_id": "FCB",
  "league_id": "ELITE",
  "wage_percentile": 0.98,
  "max_weekly_wage": 350000,
  "wage_bill_room": 120000,
  "role_need": { "ST": 0.40, "MF": 0.80, "DF": 0.30 },
  "style_fit_weights": { "Heading": 0.2, "LongPassing": 0.3, "Dribbling": 0.1, "Finishing": 0.1, "Anticipation": 0.3 },
  "transfer_budget": 50000000,
  "prestige_fac": 1.2
}
```
*(CoachRelation & SPP soft signals are computed runtime; no new fields required.)*

---

#### 9 Defaults locked for v1.0.1

- **RoleMult**: 0.8 / 1.0 / 1.2 / 1.5  
- **ClubPercentileMult(p)**: 0.6 + 0.8p  
- **SPP**: 1.00 / 1.20 / 1.35 / 1.60  
- **Auction cap**: 1.30  
- **Bonuses**: Goal $200, Assist $100, MOM $400  
- **Signing-on**: 2× weekly_wage  
- **Windows**: weeks 9-11 and 19-20; expiry 2 weeks; max 2 new Enquiries/week  