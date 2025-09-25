# Footy Star v1.0.1 – Skill Set (28 Core)

## Skills
**Note:** Confidence is a derived state (affects moment %) and is **not** trainable.

### Physical (9)
1. **Acceleration** – How fast you explode from a standstill.  
2. **Sprint Speed** – Top speed sustained over distance.  
3. **Agility** – Quick body turns and direction changes.  
4. **Body Strength** – Shielding the ball and winning shoulder duels.  
5. **Jumping** – Vertical leap and timing in aerials.  
6. **Stamina** – Ability to hold performance to 90’ (reduces late-game decay).  
7. **Power** – Leg strength for driving long shots and powerful passes.  
8. **Flexibility** – Range of motion, reducing injury risk and aiding control.  
9. **Recovery** – Ability to regain condition quickly between matches.  

### Technical (9)
10. **First Touch** – Clean first control (foot/chest), fewer bad receptions.  
11. **Dribbling** – Close control at pace; 1v1 take-ons.  
12. **Technique** – Skill moves, flair, and difficult ball manipulation.  
13. **Short Passing** – Accuracy and tempo up to ~20m.  
14. **Long Passing** – Driven/lofted accuracy beyond ~20m.  
15. **Vision** – Spotting and executing creative passes.  
16. **Finishing** – Precision in box finishing and 1v1 outcomes.  
17. **Short Shots** – Quick reactions and finishing in close-range or rebound situations.  
18. **Long Shots** – Shooting from distance, scaled with Shot Power.  
19. **Heading** – Direction and power on aerial contact.  

### Mental / Defensive (10)
20. **Anticipation** – Reading play to arrive first and intercept.  
21. **Positioning** – Being in the right spot (attack/defense context).  
22. **Marking** – Staying tight and body-oriented without fouling.  
23. **Tackling** – Winning the ball cleanly (includes slides).  
24. **Composure** – Decision-making under pressure; fewer chokes in key moments.  
25. **Consistency** – Reduces match-to-match performance volatility.  
26. **Leadership** – Impacts team morale, confidence, and captaincy influence.  
27. **Determination (Work Rate)** – Impacts selection, stamina application, and reputation growth.  
28. **Bravery** – Willingness to engage in risky challenges, aerial duels and blocks.  

---

## Derived Parameters
- **Shot Power** = `round(0.6*Power + 0.3*BodyStrength + 0.1*Stamina)` (0–100).  
- **Shot Accuracy** = `round(0.6*Finishing + 0.3*Composure + 0.1*FirstTouch)`.  
- **Pass Accuracy** = `round(0.45*ShortPassing + 0.35*LongPassing + 0.20*Vision)`.  
- **1v1 Take-ons** = `round(0.5*Dribbling + 0.2*Agility + 0.2*Acceleration + 0.1*Technique)`.  

---

## Moments (how each role uses skills)

### Forward (ST)
- **Box Finish**: Finishing 50, Short Shots 20, Composure 20, First Touch 10.  
- **1v1 vs GK**: Finishing 40, Composure 30, Dribbling 15, Technique 10, Acceleration 5.  
- **Offensive Header**: Heading 50, Jumping 25, Positioning 10, Body Strength 10, Bravery 5.  
- **Long Shot**: Long Shots 35, Power 25, Composure 20, Positioning 20.  

### Midfielder (MF)
- **Through Ball (short)**: Short Passing 35, Vision 30, Anticipation 20, Composure 10, Technique 5.  
- **Switch of Play**: Long Passing 40, Vision 30, Composure 20, Technique 10.  
- **Edge-of-Box Shot**: Long Shots 35, Power 20, Composure 20, First Touch 15, Technique 10.  

### Defender (DF)
- **Stand Tackle**: Tackling 50, Marking 20, Anticipation 15, Body Strength 5, Bravery 10.  
- **Interception**: Anticipation 40, Positioning 25, Agility 20, Determination 10, Vision 5.  
- **Aerial Clear**: Heading 45, Jumping 25, Body Strength 15, Bravery 15.  

*(Weights are percentages that sum to 100; they feed the match engine.)*

---

## Costs, XP and progression

### Option 1 - Progress with limits

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
- **League:** `xp_index ∈ {0.85, 1.00, 1.15, 1.30}` - comes from the league JSON and represents the league’s relative difficulty/reward (e.g., 0.85/1.00/1.15/1.30)  
- **MMR anti-farm:** `1/(1 + 0.015*ΔOVR^2)` (if you play far below your level)

#### Minutes selection (no energy, consistent)
`Selection Score = 0.6*RoleOVR + 0.2*Reputation + 0.2*CoachRelation (+ injury gates)`  
Rep ≥ 40 → tends to 90’. Stamina only reduces late-match decay; it’s not “energy”.

---

### Option 2 - **Banked Progress** (Promotion Queue)
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
- MMR, league, minutes, rating multipliers stay - they only affect **how fast** you fill the queue, not promotion.  
- Training = SP→XP efficiency bonus; same queue.  
- OVR/Selection ignores VL; you must **pay** to apply.

**Risks & safeguards**  
- Late-game “+20 levels at once”: intentional and controlled by the **cost curve**. If too fast, raise `C1` (e.g., to £16–18k).  
- Feeling “I’m better but not stronger”: solved by clear UI + one-tap **Promote All**.  
- At cap 100: extra XP converts to SP at 50%; encourages spreading.

---

## RoleOVR & OVR
**RoleOVR(role)** is a weighted average of the 28 skills; weights differ per role (sum to 100).

### Weights (v1.0.1 proposal)
- **ST (Forward):** Finishing 15, Short Shots 6, Composure 7, Positioning 5, Dribbling 9, First Touch 7, Acceleration 7, Sprint 5, Agility 5, Long Shots 5, Power 6, Heading 6, Jumping 3, Body Strength 3, Short Passing 3, Long Passing 1, Vision 1, Anticipation 1, Tackling 1, Stamina 1.  
- **MF (Midfielder):** Short Passing 11, Long Passing 10, Vision 10, Anticipation 7, Positioning 7, Composure 6, Determination 6, Dribbling 6, First Touch 6, Stamina 6, Acceleration 4, Agility 3, Sprint 3, Long Shots 5, Finishing 3, Body Strength 2, Tackling 2, Heading 2, Jumping 1, Technique 2.  
- **DF (Defender):** Tackling 15, Marking 12, Positioning 9, Anticipation 8, Body Strength 7, Heading 7, Jumping 5, Stamina 5, Acceleration 3, Agility 3, Sprint 3, Determination 4, Leadership 3, Bravery 4, Short Passing 2, First Touch 1, Long Passing 1, Composure 1.  

### OVR Calculation
1. **Locked Role OVR** (recommended for MVP): `OVR = RoleOVR(player_primary_role)`.  
2. **Best-of-three**: `OVR = max(RoleOVR(ST), RoleOVR(MF), RoleOVR(DF))`.  

Store all three RoleOVR for selection and contracts, even if OVR is locked to the primary role.  

---

## Translation (PT -> EN) for future UI term mapping

Aceleração → Acceleration  
Agilidade → Agility  
Antecipação → Anticipation  
Bravura → Bravery  
Cabeceio → Heading  
Carrinho → Tackling  
Chuto curto → Finishing  
Remates curtos → Short Shots  
Chuto longo → Long Shots  
Compostura → Composure  
Concentração → Consistency  
Controlo → First Touch  
Criatividade → Vision  
Determinação → Determination (Work Rate)  
Domínio de peito → First Touch  
Drible → Dribbling  
Flexibilidade → Flexibility  
Recuperação → Recovery  
Força – corpo → Body Strength  
Força – perna → Power (Leg Strength)  
Liderança → Leadership  
Marcação → Marking  
Passe curto → Short Passing  
Passe longo → Long Passing  
Posicionamento → Positioning  
Salto → Jumping (Reach)  
Velocidade → Sprint Speed  
Técnica → Technique  
Vigor → Stamina  
Pontaria → (split into Finishing / Passing Accuracy)  