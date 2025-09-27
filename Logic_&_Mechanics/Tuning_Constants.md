# Footy Star v1.0.1
## Tuning Constants - Central Registry

Single source of truth for tweakable parameters used across modules. Values are defaults and data‑driven.

---

## 1. Calendar & Leagues
- `xp_index ∈ {0.85, 1.00, 1.15, 1.30}`
- `midweek_probability` per league: 0.20–0.40
- Cup rounds hints density: per league

## 2. Match
- Moments base (ST/MF/DF): 4.0 / 3.0 / 2.5
- Jitter: ±0.8
- k_league = 6
- Confidence range ±5
- Team leadership aura cap +2.0
- Injury base 4% (clamp 1–10%)
- Consistency noise σ ∈ [0.25, 0.50]
- CoachRelation weekly clamp [−3, +3]
- SP per match: base 5 +2 goal +1 assist +1 MOM

## 3. Skills & Progression
- XP cap anchors: X0=30, X1=350
- Cost anchors: C0=$300, C1=$13,000
- MMR anti‑farm: 1/(1 + 0.015*ΔOVR²)
- Banked Progress: on/off toggle

## 4. Training
- base_xp bands: 22/28/34/38
- det_boost slope 0.004 (±20% cap)
- Touch 2–5 skills per week

## 5. Contracts
- ClubPercentileMult(p) = 0.6 + 0.8p
- RoleMult: 0.8/1.0/1.2/1.5
- SPP: 1.00/1.20/1.35/1.60
- Auction cap: 1.30
- Bonuses: Goal $200, Assist $100, MOM $400
- Signing‑on: 2× weekly_wage

## 6. Transfers
- Enquiry / Offer thresholds: 60 / 80
- Decay weekly: −8% (out), −3% (in window)
- Reject cooldown: 3 days unless +10% fee
- Auction pressure cap: +20% ask
- Scouting error: ±2 OVR (±3 low‑budget)

## 7. Economy
- Business step β=0.125 (ΔW=1.125×W0)
- Upgrade costs rule ×1.5 (round up from U2)
- Casino edges: Slots 5%, BJ 2%, Sports 4–7%
- Weekly casino cap: min($5,000, 0.5×salary)

## 8. Sponsorships & Lifestyle
- Sponsor slots: 2 base, +1 at Rep 60, +1 at Rep 80 (cap 4)
- Offer duration 8–20 weeks
- Add‑ons: Goal 100–400, Assist 50–200, MOM 200–600
- Lifestyle upkeep 0–$2,000/week; overspending flag at >40% salary for 3 weeks

## 9. Relationships
- Meters 0–100; weekly decay 0.2 if <activity>; clamp [0,100]
- Coach selection bonus mapped to meter via Match rules
- Pet happiness -> Confidence ±0.1…0.3

## 10. Endgame
- Soft decline start age 30; hard cap 40
- Seasonal decline physicals −0.5…−1.0 level/year
- Technical/mental plateau ~34

---

## 11. Monetization & Exchange
[Monetization.SP_Exchange]
alpha_buy_fraction = 0.30
sell_fraction_beta  = 0.20
buy_price_min       = 35
buy_price_max       = 110
weekly_cap_buy_sp   = 100
weekly_cap_sell_sp  = 40
sell_ratio_of_earned_week = 0.5
surge_threshold_sp  = 200
surge_markup        = 0.25
iap_sp_sellable     = false

[Monetization.Products]  # (se aplicável no teu build atual)
enable_year_extension = true   # se fores reintroduzir do Endgame
max_year_extension    = 7

## (Atualizar Sponsors se mantiveres 10 slots)
[Monetization.Sponsorships]
base_slots = 2
max_slots  = 10
slot_price_base = 5000
slot_price_growth = 1.5   # cada slot adicional custa 1.5× o anterior

[Career.YearExtension]
# Price per extra year (in‑game $),
base_cost           = 1000000
cost_growth_per_ext = 2.5        # 2.5x each extension
round_to            = 1000       # round to $1,000
max_extensions      = 7          # 33 → 40
price(n) = round_to * round( base_cost * (cost_growth_per_ext)^(n-1) / round_to )


# Effective price:
# price(n) = price(n-1)*2.5
# where n = year_extensions_owned + 1 (the extension being purchased)

---

> **NOTE FOR ME** Keep this file updated whenever a module adds a new tunable.
