# Footy Star v1.0.1

## Training System - Coach‑Driven, Zero Micromanagement

**Principle:** Training is fully managed by the **coach (game engine)**. Players do **not** pick routines. There are **no $ costs** for training. The user only sees **progress notifications** and **injury/availability** status.

This version is compatible with **Skills.md (28 skills)** and **Match.md v1.0.1** (CoachRelation, Consistency, Recovery/Flexibility/Bravery, injuries).

---

## 1 Ownership & Visibility
- **Coach‑driven:** Each week the coach selects sessions based on role, weaknesses, last match performance, fitness and calendar.
- **Invisible plan:** The user does **not** see which routines were chosen.
- **What the user sees:** Only lightweight outcomes on the **Home** screen:
  - “**{Skill}** reached 100% XP - ready to promote.”
  - “**Injured** - you missed this week’s training.”
  - “Training completed - progress applied.” (optional toast)

> All internal distributions (which skills got XP) are opaque by design to avoid micromanagement.

---

## 2 Weekly Flow (calendar hook)
- Each **game week** (see League_Calendar.md) runs: team sessions + coach-decided work.
- International breaks & midweek cups adjust internal volume automatically (no user action).
- If **injured/ban**, the player **misses training** for that week (no XP from training).

---

## 3 XP Generation (opaque rules, deterministic with noise)
The engine assigns XP to skills using these signals (hidden from user):
1. **RoleOVR weights** (baseline spread by primary role).
2. **Weakest‑cluster boost** inside the role (help the player round out gaps).
3. **Performance feedback** from last match (e.g., bad headers -> more Heading/Jumping/Bravery; missed 1v1 -> Finishing/Composure/First Touch; lost duels -> Body Strength/Tackling).
4. **Fitness & risk** (recent injuries push Recovery/Flexibility/Stamina top‑ups).
5. **Consistency & Determination** as multiplicative gain factors (small, capped), mirroring Match.md.

### 3.1 XP numbers (post‑rework, simple)
To keep balance with match XP/SP, the **total weekly training XP** is modest and auto‑scaled:
```
XP_week = base_xp * league_xp_index * minutes_factor * rating_factor * mmr_anti_farm * det_boost
Where:
  base_xp ∈ [22 .. 38]            // coach chooses volume band by schedule/load
  league_xp_index ∈ {0.85,1.00,1.15,1.30}
  minutes_factor = clamp(min/90, 0.3..1.0)   // last match minutes
  rating_factor  = 0.6 + 0.1*rating          // 5.0->1.1, 8.0->1.4
  mmr_anti_farm  = 1/(1 + 0.015*ΔOVR^2)      // league mismatch
  det_boost      = (1 + 0.004*(Determination−50))  // ±20% cap
```
The coach allocates **XP_week** across a small set of skills (2-5 per week) using the hidden signals above.

> **SP is not granted by training.** SP remains match/end‑of‑match only (see Match.md).

---

## 4 Banked Progress & Promotions
Compatible with both **Option 1 (Limits)** and **Option 2 (Banked Progress)** from Skills.md.
- Training XP fills the current bar and continues to **overflow** across future levels **only** if Banked Progress is active.
- The user receives a **Home notification** whenever **any skill reaches 100% XP** (i.e., a level is now payable/promotable).
- Promotions still require **$** (see Skills.md cost curve). Training itself has **no $ cost**.

**Notification copy examples:**
- “**Dribbling** ready to promote (+1 level).”
- “**Vision** ready (+2 queued levels).” *(if Banked Progress shows queued)*

---

## 5 Injuries & Availability (align with Match.md §3)
- If **injured** this week -> **missed training**, no training XP added. (Match XP still applies from any minutes actually played.)
- **Recovery/Flexibility** still reduce risk and downtime via Match.md rules; that logic remains in Match, not here.
- First match after return still gets the **−1 confidence** transient (Match.md).

---

## 6 CoachRelation (quiet hook)
- CoachRelation evolves weekly per **Match.md v1.0.1**, considering attendance and performance.
- Training **does not show** explicit +/− to the user; it quietly feeds the evolution model.
- Following injuries, missed sessions don’t cause extra penalty beyond the availability logic in Match.md.

---

## 7 UI/UX Minimal
- **Home feed only**:
  - List of **skill ready** notifications (click -> opens Skills screen at that skill).
  - Small badge “Training completed” (optional).
  - Injury banner if applicable.
- **Skills screen**: Bars update; if Banked Progress is active, queued levels are visible; buttons to **Promote** remain the same.
- **No training menu** exists. The coach works in the background.

---

## 8 Tuning Defaults (v1.0.1)
- `base_xp`: default bands -> Normal 28, Light 22 (heavy schedule), Heavy 34 (no midweek), Peak 38 (international break).
- `det_boost` slope: 0.004 (cap ±20%).
- Minutes & rating multipliers exactly as **Match.md** for parity.
- League `xp_index` as per league JSON.
- Allocation per week: **2-5 skills** touched; at most **1** purely defensive and **1** purely aerial per week (keeps identity).

---

## 9 Future Hooks
- **Investments.md** (crypto/stocks/casino): *no impact on training*. Money is used for **promotions** and other economy systems, not to buy training.
- Optional v1.1 idea: **Appeal to coach** (rare event) -> small chance to nudge focus, with CoachRelation check.

---

### Implementation Notes
- Engine tick: after match processing and injuries, compute `XP_week`, choose target skills, apply XP, emit notifications for any bar that hits 100% (and queue, if enabled).
- Store only outputs (XP deltas & which skills changed) - keep the selection rationale internal to allow future re‑tuning without migration.

