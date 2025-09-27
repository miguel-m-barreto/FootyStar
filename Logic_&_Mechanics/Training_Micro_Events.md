# Footy Star v1.0.1
## Training - Micro‑Events Addendum (coach‑driven model)

Lightweight, occasional training micro‑events to break monotony. They plug into the coach‑driven Training System without adding menus or choices. Occur at most once per week with low probability (default 10%).

### Event pool (examples)
- **Coach praise**
  - Trigger: last match rating ≥ 7.5 or clear improvement in a weak skill.
  - Effect: CoachRelation +0.5, Confidence +0.2.

- **Extra drill**
  - Trigger: Determination ≥ 70 and minutes < 45 last match.
  - Effect: +6 XP to one focused skill this week.

- **Mentor huddle**
  - Trigger: Leadership of senior teammate ≥ 75.
  - Effect: +0.2 Reputation, +4 XP to Consistency, CoachRelation +0.3.

- **Film session highlight**
  - Trigger: Consistency < 50 or error leading to goal last match.
  - Effect: +5 XP to Positioning or First Touch (role‑dependent).

- **Minor knock (training)**
  - Trigger: random, low probability (1%).
  - Effect: miss next session (no training XP this week). Does not affect match availability unless injury system already would.

- **Set‑piece reps**
  - Trigger: recent corners/free‑kicks created.
  - Effect: +5 XP to Heading (DF/ST) or Long Passing (MF), +0.1 xG on set‑pieces for next match (temporary).

### Tuning
- Base chance per week: 10% (clamped to one micro‑event/week).
- Effects are small; XP awards in the 4–6 range, CoachRelation deltas in 0.3–0.5.
- All outcomes are logged in the weekly statement as a single line.

---

## Choice Events (training scenarios with decisions)

### TE-01 - Hard Tackle in Training
- **Trigger:** intense scrimmage; teammate with high Aggression/Bravery makes a deliberate hard tackle on you.
- **Prompt:** “A teammate goes in with a brutal tackle on purpose. How do you react?”

**Choices:**
1) **Go in equally hard next play**  
   - Effects: `Bravery +5 XP`, `CoachRelation −1.0`, small chance of minor knock (training only).

2) **Ignore and keep it professional**  
   - Effects: `Consistency +5 XP`, `CoachRelation +0.5`, `Confidence −0.2` (temporary, 1 week).

3) **Sneaky payback (hard but discreet)**  
   - Effects: `Bravery +5 XP`, `Consistency −5 XP`, no public reputation change unless caught (5% chance → `Reputation −0.5`).

4) **Throw a punch**  
   - Effects: `Confidence +1.0`, `Reputation −1.5`, possible 1‑match internal suspension (coach decision, 50% if CoachRelation < 50).

- **Cooldown:** event cannot repeat within 6 weeks.
- **Flags:** may set `training_fight=true`; if true, unlocks small narrative follow‑ups (press rumors, apology branch).
