# Footy Star v1.0.1 — Skill Set (18 Core)

## Skills
**Note:** Confidence is a derived state (affects moment %); it is **not** trainable.

### Physical (6)
1) **Acceleration** — How fast you explode from a standstill.
2) **Sprint Speed** — Top speed sustained over distance.
3) **Agility** — Quick body turns and direction changes.
4) **Strength** — Shielding the ball and winning shoulder duels.
5) **Jumping** — Vertical leap and timing in aerials.
6) **Stamina** — Hold performance to 90’ (late-game decay reducer).

### Technical (7)
*Derived parameter:* **Shot Power** = `round(0.7*Strength + 0.3*Stamina)` (0–100, clamped).

7) **First Touch** — Clean first control (foot/chest), fewer bad receptions.  
8) **Dribbling** — Close control at pace; 1v1 take-ons.  
9) **Short Passing** — Accuracy and tempo up to ~20m.  
10) **Long Passing** — Driven/lofted accuracy beyond ~20m.  
11) **Finishing** — Quick box finishing and 1v1 outcomes.  
12) **Long Shots** — Shooting from range; scales with Shot Power.  
13) **Heading** — Direction and power on aerial contact.

### Mental/Defensive (5)
14) **Anticipation** — Reading play to arrive first and intercept.  
15) **Positioning** — Being in the right spot (attack/defense context).  
16) **Marking** — Staying tight and body-orienting without fouling.  
17) **Tackling** — Winning the ball cleanly (includes slides).  
18) **Composure** — Decisions under pressure; fewer chokes in key moments.

------

## Moments (how each role uses skills)

### Forward (ST)
- **Box Finish**: Finishing 60, Composure 20, First Touch 10, Positioning 10.  
- **1v1 vs GK**: Finishing 45, Composure 35, Acceleration 10, Dribbling 10.  
- **Offensive Header**: Heading 55, Jumping 25, Positioning 10, Strength 10.  
- **Long Shot**: Long Shots 45 (with **Shot Power** bonus), Composure 20, Dribbling 10, Positioning 25.

### Midfielder (MF)
- **Through Ball (short)**: Short Passing 55, Anticipation 20, Composure 15, Dribbling 10.  
- **Switch of Play**: Long Passing 60, Anticipation 20, Composure 20.  
- **Edge-of-Box Shot**: Long Shots 50, Composure 25, First Touch 15, Dribbling 10.

### Defender (DF)
- **Stand Tackle**: Tackling 55, Marking 25, Anticipation 15, Strength 5.  
- **Interception**: Anticipation 50, Positioning 30, Agility 20.  
- **Aerial Clear**: Heading 50, Jumping 30, Strength 20.

*(Weights are percentages that sum to 100; they feed the moment engine.)*

---

## Costs, XP and progression

### Option 1 — Progress with limits

### Progression & Rewards (hooked to XP/SP/£)
- **XP cap per level (5→100)**: continuous exponential with anchors:  
  `XPcap(L) = round( X0 * (X1 / X0)^((L - 5)/95) )`  
  Recommended: `X0 = 30`, `X1 = 350` (≈ +2.6%/level).

- **Promotion cost (£)**:  
  `Cost(L) = round( C0 * (C1 / C0)^((L - 5)/95) )`  
  Recommended: `C0 = £300`, `C1 = £13,000` (≈ +4.0%/level).

- **SP per match** (before multipliers): `base 5 + 2 per goal + 1 per assist + 1 if MOM`.  
  Conversion: **1 SP = 10 XP** (no cap; SP does **not** promote).

#### Multipliers
- **Minutes:** `minFactor = clamp(min/90, 0.3..1.0)`  
- **Rating:** `rateFactor = 0.6 + 0.1*rating` (5.0→1.1, 8.0→1.4)  
- **League:** `xp_index ∈ {0.85, 1.00, 1.15, 1.30}` — comes from the league JSON and represents the league’s relative difficulty/reward (e.g., 0.85/1.00/1.15/1.30)  
- **MMR anti-farm:** `1/(1 + 0.015*ΔOVR^2)` (if you play far below your level)

#### Minutes selection (no energy, consistent)
`Selection Score = 0.6*RoleOVR + 0.2*Reputation + 0.2*CoachRelation (+ injury gates)`  
Rep ≥ 40 → tends to 90’. Stamina only reduces late-match decay; it’s not “energy”.

---

### Option 2 — **Banked Progress** (Promotion Queue)
- When a skill fills its XP bar, it **does not stop**. Extra XP keeps accumulating for subsequent levels of that skill, **without limits**, up to 100.
- You get a **promotion queue**: `+N levels ready` **plus** partial XP for the next level.
- Nothing levels up or affects OVR until you **pay**. When you have £, promote one, many, or all at once.

**Per-skill state:**  
- **Level (L):** 5…100.  
- **XP_current:** 0…`XPcap(L)` (if queue is empty).  
- **QueuedLevels (QL):** integer count of fully “payable” levels.  
- **QueuedXP:** partial progress of virtual level `(L + QL)` (0…`XPcap(L+QL)`).  
- **Virtual Level (VL):** `VL = L + QL` (UX only; **not** used for OVR until you promote).  
- At **100**: if `VL == 100` and you earn more XP/SP, **convert 50% to SP** (no loss; encourages investing in other skills).

**How XP/SP flows in**  
- Match XP (moments with multipliers) and SP→XP always advance across the sequence:  
  `L → L+1 → L+2 → …` (you can “fill” multiple levels in one go; nothing is wasted).  
- SP remains: **1 SP = 10 XP**, no ceiling. You can fill 100% via SP and bank any number of levels.

**Promotion (pay to apply)**  
- `Cost(L)` uses the same exponential curve.  
- **Promote 1**: pay `Cost(L)`, apply `L := L+1`.  
- **Promote All**: pay `Σ_i Cost(L + i)` for `i = 0…QL-1`, apply in one shot.  
- **Partial** remains: `QueuedXP` stays as progress for the next level.

**UI/UX**  
- Each skill shows: `Level 62  (+3 queued)` and a bar **“Next (partial)”**.  
- Buttons: **Promote (1)**, **Promote ×N** (dropdown with total), **Promote All**.  
- Tooltip: “Stats only count when you promote.”

**Example**  
- You’re at **L=5**, `XPcap(5)=30`. After a strong match + SP spend, you inject **380 XP** into the same skill.  
- It advances across levels as expected, ending with **`QL=9`** and **`QueuedXP=71`** toward **L14**.  
- With £0 today, you can later pay **9 promotions** in one go; `QueuedXP` remains.

**Impact**  
- If **Option 2 (Banked Progress)** is active, **remove** the “Overflow → SP 25%” rule from Option 1 to avoid conflicts.  
- MMR, league, minutes, rating multipliers stay — they only affect **how fast** you fill the queue, not promotion.  
- Training = SP→XP efficiency bonus; same queue.  
- OVR/Selection ignores VL; you must **pay** to apply.

**Risks & safeguards**  
- Late-game “+20 levels at once”: intentional and controlled by the **cost curve**. If too fast, raise `C1` (e.g., to £16–18k).  
- Feeling “I’m better but not stronger”: solved by clear UI + one-tap **Promote All**.  
- At cap 100: extra XP converts to SP at 50%; encourages spreading.

---

## RoleOVR & OVR
**RoleOVR(role)** is a weighted average of the 18 skills; weights differ per role (sum to 100).

### Weights (v1.0.1 defaults)
- **ST (Forward):** Fin 19, Comp 9, Pos 7, Drib 10, First 8, Acc 8, Sprint 6, Agil 5, LongS 5, Head 6, Jump 3, Str 4, ShortP 4, LongP 1, Ant 2, Mark 1, Tack 1, Stam 1.  
- **MF (Midfielder):** ShortP 14, LongP 12, Ant 9, Pos 8, Comp 8, Drib 7, First 7, Stam 6, Acc 4, Agil 4, Sprint 3, LongS 5, Fin 3, Str 3, Mark 2, Tack 2, Head 2, Jump 1.  
- **DF (Defender):** Tack 18, Mark 16, Pos 12, Ant 10, Str 10, Head 9, Jump 5, Stam 5, Acc 4, Agil 3, Sprint 3, ShortP 2, First 1, LongP 1, Comp 1.

### OVR calculation
Pick one policy for the build:
1) **Locked Role OVR** (recommended for MVP): `OVR = RoleOVR(player_primary_role)`  
2) **Best-of-three**: `OVR = max( RoleOVR(ST), RoleOVR(MF), RoleOVR(DF) )`  

Store all three `RoleOVR` for Selection and market interest even if OVR is locked to the primary role.


---

## Translation (PT -> EN) for future UI term mapping

Aceleração -> Acceleration  
Agilidade -> Agility  
Antecipação -> Anticipation  
Aproximação -> (covered by Acceleration/Positioning/Marking)  
Bravura -> (future trait; small bonus to Tackling/Heading)  
Cabeceio -> Heading  
Carrinho -> Tackling  
Chuto curto -> Finishing  
Chuto longo -> Long Shots  
Compostura -> Composure  
Concentração -> (future trait “Consistency”)  
Confiança -> Confidence (derived state, not a skill)  
Controlo -> First Touch  
Criatividade -> (v1.1: Vision)  
Determinação -> (future trait “Work Rate/Drive”)  
Domínio de peito -> First Touch  
Drible -> Dribbling  
Força – corpo -> Strength  
Força – perna -> (Shot Power internal, bonus)  
Liderança -> (future trait)  
Marcação -> Marking  
Passe curto -> Short Passing  
Passe longo -> Long Passing  
Posicionamento -> Positioning  
Salto -> Jumping (Reach)  
Velocidade -> Sprint Speed  
Técnica -> (cut from MVP)  
Vigor -> Stamina  
Pontaria -> (split into Finishing/Passing)