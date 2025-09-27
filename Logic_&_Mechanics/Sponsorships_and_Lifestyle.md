# Footy Star v1.0.1
## Sponsorships & Lifestyle (Economy Extensions)

Adds mid‑to‑late game income sources (sponsors) and flavourful spending (lifestyle) with light gameplay effects. Integrates with **Weekly_Economy**, **Events**, and **Relationships**.

---

## 1. Sponsorships

### 1.1 Sponsor Score (SS)
`SS = 0.55*Reputation + 0.25*OVR + 0.10*AwardsTier + 0.10*SocialTier` (0–100)

- **AwardsTier**: 0 (none), 1 (League award), 2 (Global award), 3 (MVP/ToY).  
- **SocialTier**: proxy 0–3 (events & performance can bump it).

### 1.2 Contract Types
- **Boots/Apparel**: fixed weekly + small per‑goal bonus.
- **Drink/Energy**: fixed + MOM bonus.
- **Streaming/Media**: variable (spikes after big matches/events).
- **Local Brand**: small fixed, easier to unlock; early game.

Each sponsor occupies a **slot**. Defaults: **2 slots base**; you may **buy extra slots** with $,
price grows ×1.5 per slot purchased. **Max 10** slots. (Apparel remains exclusive.)

### 1.3 Offer Generation
Weekly check:
- If `SS ≥ thresholds[type]` and slot free -> create Offer (duration 8–20 weeks).
- Higher SS -> better pay and chance of **Performance Add‑ons** (+$ per Goal/Assist/MOM).

### 1.4 Payouts
- Fixed amounts credited in **Weekly_Economy Income**.
- Add‑ons triggered by Match results (goals/assists/MOM).

### 1.5 Exclusivity & Conflicts
- Apparel conflicts (one at a time). Others can stack.
- Early termination penalty (−2 weeks of pay) if cancelled.

---

## 2. Lifestyle

### 2.1 Categories
- **Housing** (Rent -> Apartment -> House -> Penthouse)
- **Vehicles** (Used -> New -> Luxury)
- **Leisure** (Holidays, Clubs, Dining)
- **Gadgets**
- **Pets** (costs & small Confidence effects)

### 2.2 Effects
- Confidence: small weekly `±0.1…±0.4` based on moderation.  
- CoachRelation: negative if **excessive partying** before matches.  
- Events hooks: unlocks related narratives (parties, paparazzi, gifts).

### 2.3 Upkeep & Caps
- Upkeep paid weekly via **Expenses**.  
- Soft cap: if Lifestyle upkeep > 40% of salary for 3 weeks -> `over_spending=true` -> Events may trigger interventions; Confidence may drop.

---

## 3. Integration & UI
- **Economy**: Sponsorships show under **Income**; Lifestyle under **Expenses** with category labels.
- **Inbox**: sponsor offers, renewals, termination notices.
- **Relationships**: sponsors mildly influence **Agent** meter (negotiations), Lifestyle choices can affect **Family/Partner** via Events.
- **Settings**: toggle to **disable Sponsorships** for a purist mode.

---

## 4. Tunables (defaults)
- Slots: 2 base, Max 10.
- Offer durations: 8–20 weeks; renewal chance scales with SS.
- Add-on rates: Goal $100–$400, Assist $50–$200, MOM $200–$600 by tier.
- Lifestyle upkeep: 0–$2,000/week scaled by item tier and league level.

---

## 5. Notes
- Keep sponsor math simple and deterministic with small noise.
- Store contracts `{type, weekly, add_ons, weeks_left, exclusivity}`.
- Lifestyle owned `{category, tier, upkeep}`; effects computed weekly.
