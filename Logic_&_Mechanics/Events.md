# Footy Star v1.0.1
## Random Events System

Lightweight narrative events that occasionally occur to add personality and long‑term stories to a career. Events are optional, quick to resolve, and always provide clear choices and effects.

This spec defines triggers, categories, data schema, flags, tuning constants, and example events, including long‑arc outcomes (e.g., memorabilia sold years later).

---

## 1 Trigger model

- Events do not fire every week. Base weekly chance: **p_base = 0.15**.
- Cooldown after any event: **cd = 2 weeks** (no new event during cooldown).
- Multiple categories exist; per week, at most **1 event** can spawn.
- Weighted picker by category; weights can change with age, Reputation, recent form.
- Optional seasonal budget: no more than **N = 8** events per season.

### 1.1 Trigger weights (defaults)
- Social/Personal: **35%**
- Family: **20%**
- Career/Teammates/Coach: **20%**
- Lifestyle/Shopping/Pets: **15%**
- Items/Memorabilia/Collector: **10%**

### 1.2 Common preconditions
- Age ranges (e.g., memorabilia gift at 17 only).
- Reputation floors (invites, sponsors).
- OVR floors (recognition).
- Balance floors (to afford purchases).

---

## 2 Effects model

Each event yields immediate effects and can set persistent flags for future arcs.

Possible effects:
- Money: `+/- $` (Weekly Economy).
- Reputation: `+/- 0.1 … 2.0`.
- Confidence: `+/- 0.2 … 1.0` (temporary).
- CoachRelation: `+/- 0.5 … 2.0`.
- Skill flavor nudges: small one‑off XP (e.g., +5 XP First Touch) at most.
- Flags: boolean or counted markers saved to the career state.
- Debuffs/buffs: short timers (e.g., 1-2 weeks) to injury chance, selection noise, etc.

All effects must be brief and understandable in a single popup.

---

## 3 Data schema (event template)

```json
{
  "id": "EVENT_ID",
  "category": "social|family|career|lifestyle|item",
  "title": "Short headline",
  "text": "Narrative line, one or two sentences.",
  "choices": [
    {
      "id": "A",
      "label": "Choice text",
      "effects": {
        "money_delta": -200,
        "reputation_delta": 0.5,
        "confidence_delta": 0.3,
        "coachrelation_delta": 0.5,
        "skill_xp": { "First Touch": 5 },
        "flags_set": ["flag_name"],
        "timers": { "injury_risk_week_mul": 1.10, "weeks": 1 }
      }
    },
    {
      "id": "B",
      "label": "Choice text",
      "effects": { }
    }
  ],
  "preconditions": {
    "age_min": 16,
    "age_max": 40,
    "ovr_min": 0,
    "rep_min": 0,
    "flags_required": [],
    "flags_forbidden": []
  },
  "cooldown_weeks": 2,
  "weight": 1.0,
  "followups": [
    {
      "after_weeks_min": 52,
      "after_weeks_max": 260,
      "spawn_id": "FOLLOWUP_EVENT_ID",
      "condition_flags": ["flag_name"]
    }
  ]
}
```

---

## 4 Flags and long‑arc design

- Flags are named booleans or counters set by choices (e.g., `memorabilia_kept=true`, `has_pet=dog`).
- Follow‑up events reference flags with time windows to allow delayed payoffs (months/years later).
- Flags should be kept small and specific to avoid combinatorial explosion.
- Example flags: `memorabilia_kept`, `problem_gambler`, `owns_pet_dog`, `dating_active`, `loan_to_friend_open`.

---

## 5 Integration

- **League_Calendar**: roll event after match processing and training, before Weekly Economy closes.
- **Weekly Economy**: apply money deltas to the weekly statement.
- **Skills**: any XP nudges are small (≤ +5 XP) to avoid balance issues.
- **Match**: temporary buffs/debuffs set timers read by Match (e.g., confidence boost for 1 week).
- **Contracts**: no direct changes, except flavor Reputation changes.
- **UI**: one compact popup with title, text, 2-3 choices, and clear outcome lines.

---

## 6 Tuning constants (defaults)
- `p_base = 0.15`
- `cd = 2 weeks`
- `season_cap = 8 events`
- Reputation deltas typically in `±0.2 … ±1.0`
- Confidence deltas typically in `±0.2 … ±0.8`
- Money deltas scale with league tier; use ranges per category.
- Random offer magnitudes can be gated by Reputation and age.

---

## 7 Example events

### 7.1 Social - Recognized on the street
- Preconditions: OVR ≥ 8 or Reputation ≥ 5.
- Text: "A fan recognizes you and asks for a quick selfie."
- Choices:
  - A) Accept the selfie. Effects: `Reputation +0.3`, `Confidence +0.2`.
  - B) Decline politely, you are in a rush. Effects: `Reputation -0.2`, `Confidence -0.1`.

### 7.2 Social - A date invite
- Preconditions: none.
- Text: "You receive an invitation for a casual date."
- Choices:
  - A) Go to the date. Effects: `Confidence +0.4`, `money -$60` (dinner); set `dating_active` for 2 weeks (no further date invites during that time).
  - B) Skip, focus on training. Effects: `CoachRelation +0.3`.

### 7.3 Lifestyle - Adopt a pet
- Preconditions: none.
- Text: "You consider adopting a pet."
- Choices:
  - A) Adopt a dog. Effects: `money -$200` upfront, set `owns_pet_dog`, `Confidence +0.3`.
  - B) Adopt a cat. Effects: `money -$150`, set `owns_pet_cat`, `Confidence +0.2`.
  - C) Not now. Effects: none.

### 7.4 Family - Birthday
- Preconditions: once per year.
- Text: "It is your birthday."
- Choices:
  - A) Host a small dinner. Effects: `money -$100`, `Confidence +0.4`.
  - B) Quiet day at home. Effects: `Confidence +0.1`.

### 7.5 Family - Parent’s birthday
- Preconditions: once per parent per year.
- Text: "It is your mother's birthday."
- Choices:
  - A) Buy a gift. Effects: `money -$80`, `Confidence +0.2`.
  - B) Call and send regards. Effects: `Confidence +0.1`.

### 7.6 Career - Teammate gift (boots)
- Preconditions: none.
- Text: "A teammate gives you a pair of signed boots."
- Choices:
  - A) Keep them. Effects: set `kept_signed_boots`.
  - B) Sell them. Effects: `money +$250`.
  - C) Donate them to charity. Effects: `Reputation +0.4`.

### 7.7 Items - Memorabilia at 17 (long arc)
- Preconditions: age == 17, `flags_forbidden`: `memorabilia_received`.
- Text: "You receive your first framed jersey, signed by the whole squad."
- Immediate effects: set `memorabilia_received`.
- Choices:
  - A) Sell now. Effects: `money +$200`. Close arc (`memorabilia_kept=false`).
  - B) Keep it. Effects: set `memorabilia_kept=true`.
  - C) Donate to charity. Effects: `Reputation +0.5`. Close arc.
- Follow‑up (collector offer):
  - Trigger window: **2-6 years** later (104-312 weeks), requires `memorabilia_kept=true`.
  - Text: "A collector offers to buy your framed jersey."
  - Offer value: random in `$100,000 - $250,000`, scaled by Reputation at time of offer.
  - Choices:
    - A) Accept. Effects: `money +$offer`; clear `memorabilia_kept`.
    - B) Keep it. Effects: none; another offer may occur 1-2 years later.

### 7.8 Finance - Friend asks for a loan
- Preconditions: balance ≥ $1,000.
- Text: "A close friend asks for a $500 loan."
- Choices:
  - A) Lend now. Effects: `money -$500`, set `loan_to_friend_open`.
  - B) Decline. Effects: `Confidence -0.1`.
- Follow‑up (6-20 weeks later):
  - 70% chance: friend repays `$600` (principal + $100), clears flag.
  - 30% chance: friend ghosts you (no repayment), clears flag.

### 7.9 Career - Coach feedback
- Preconditions: last match rating ≤ 5.8.
- Text: "Coach calls you in for frank feedback."
- Choices:
  - A) Take it on the chin. Effects: `CoachRelation +1.0`, `Consistency +5 XP`.
  - B) Push back. Effects: `CoachRelation -1.0`, `Confidence +0.2` (short‑term).

### 7.10 Lifestyle - Party invite before match
- Preconditions: match within 48h.
- Text: "You are invited to a party right before matchday."
- Choices:
  - A) Attend. Effects: `Confidence +0.3`, next match `rating_factor × 0.95` for one week.
  - B) Pass. Effects: `CoachRelation +0.5`.

---

## 8 Implementation notes

- Run trigger after match and training, before economy close.
- Respect cooldown and seasonal cap.
- Use weighted random for category selection, then pick a valid event by preconditions.
- Store effects in the weekly statement and show a single compact popup.
- Flags are persisted in player state with timestamps (for timed follow‑ups).
- Provide a developer toggle to force‑spawn an event for testing.

