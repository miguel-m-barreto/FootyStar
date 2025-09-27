# Footy Star v1.0.1
## Relationships System — Coach, Agent, Family, Partner, Pets

Lightweight meters (0–100) with small gameplay hooks and narrative integration.

---

## 1. Entities & Meters
- **Coach** (0–100): selection & negotiation soft signal.
- **Agent** (0–100): quality of offers, fees, negotiation leniency.
- **Mother / Father** (0–100 each): narrative flavour; small Confidence effects when high.
- **Partner** (0–100, optional): narrative flavour; Events chain.
- **Pet** (Dog/Cat) happiness (0–100): small Confidence effect.

Meters clamp [0,100]; default neutral **50**.

---

## 2. Weekly Updates
```
Coach += f(performance, training, events) + noise
Agent += f(negotiations, payments, offers) + noise
Family/Partner += f(events, gifts, time) - neglect_decay
Pet += care - neglect_decay
```
- **Neglect decay** default **−0.2/week** if no positive interaction that week.
- All changes logged in **Inbox** (Relationships section).

---

## 3. Hooks
- **Coach** -> feeds Selection (Match.md) via CoachRelation already defined.
- **Agent** -> small chance of better sponsor offers & transfer terms (±2–5%).
- **Family/Partner** -> Events unlocks; Confidence +0.1 when high (≥75), −0.1 when low (≤25).
- **Pets** -> Confidence +0.1 (happy ≥70), −0.1 (sad ≤30).

---

## 4. Actions (Indirect)
The player does **not** micromanage actions; meters change through:
- **Performance/Training** (Coach)
- **Negotiations** (Agent)
- **Events choices** (Family/Partner/Pet)
- **Lifestyle** ownership/upkeep (Partner/Pet hooks)

Optional: simple one-tap **“Call home”** (cooldown 2 weeks) -> +2 Mother/Father.

---

## 5. Data & UI
- Store last change and reason `{source, delta}` for tooltips.
- UI shows current value and small trend arrow.
- Settings allow toggling Partner/Pet features.

---

## 6. Tunables (defaults)
- Weekly neglect decay: −0.2.
- Agent effect on terms: ±2–5% (capped).
- Family/Partner Confidence effect: ±0.1 (weekly).
- Pet happiness effect: ±0.1…0.3 (weekly).
