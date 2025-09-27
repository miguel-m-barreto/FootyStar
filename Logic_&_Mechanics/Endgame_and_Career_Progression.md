# Footy Star v1.0.1
## Endgame & Career Progression

Defines late‑career arcs (decline, milestones, retirement) and post‑player paths (coach, investor).

---

## 1. Ageing & Decline
- **Soft caps** start at age **30**; gradual −0.5 to −1.0 level/year across select physicals (Sprint, Agility, Jumping, Stamina, Recovery, Flexibility).  
- Technical/mental can still improve slowly via training and play until **40**; then plateau.  
- Hard cap at **40** (forced retirement event).

Decline applies **only** on season close to avoid micro-noise.


### Rebirth
- `rebirth_18`: sets age to **18**; progress intact.
- **Year Extensions persist** across Rebirth and apply again upon reaching 33.~
- Ageing Skill decline stops until 30 again

---

## 2. Milestones
- Milestones can be claimed as milestone trophies and they give money.
- 100/200/300 apps, 50/100/150 goals, 50/100 assists, Reputation, overall, etc, bumps and commemorative **Events**.
- League title / cup wins -> bigger Rep bumps; trophy cabinet in **Career History**.

---

## 3. Retirement Decision
- Base retirement at 33, offer menu starts appearing at 30
- Offer menu:
  - **Continue 1 more season** (risk of further decline; coach selection harder).
  - **Test new league** (lower xp_index, new cultural Events).  
  - **Retire** -> choose **Post‑Career Path**.
- **Year Extensions (in‑game purchase):** cap = **33 + year_extensions_owned** (max **40**).

### How to buy a Year Extension (in‑game money)
- Trigger points:  
  1) At the **Retirement Prompt** (when reaching the cap), or  
  2) From **Career → Endgame** panel (off‑season).  //TO CHECK
- Price scales with your **weekly wage** and number of extensions already owned (see Tuning_Constants ▸ Career.YearExtension).  
- On purchase: post **Expense** to Weekly Economy (`source="CareerExtension"`); increase `year_extensions_owned` by +1; update cap immediately.

### Rebirth
- `rebirth_18`: sets age to **18**; progress intact.  
- **Year Extensions persist** across Rebirth and apply again upon reaching 33.

### Milestones, Epilogue & Post‑Career
- Unchanged from base doc (trophies, narrative epilogue, optional paths Coach/Investor/Media).

---

## 4. Post‑Career Paths (v1.0.1 lightweight)
- Gain career points in the main menu of the game to unlock percks for the next new saves such as:
  - TODO

---

## 5. Epilogue & Save Wrap‑Up
- Final **Season Report** + **Career Totals** + Awards.
- Narrative summary using top 5 milestones.
- Exportable summary card (image/pdf).

---

## 6. Dev Notes
- Ageing deltas applied on season close; use seeds for reproducibility.
- Ensure no hard lock if the user refuses retirement repeatedly (allow continue with steeper decline).
