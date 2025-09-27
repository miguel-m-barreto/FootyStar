# Footy Star v1.0.1
## Monetization & IAP (Design Spec)

Optional in‑app products that extend playtime and offer quality‑of‑life. All IAP are **data‑driven**, server‑verified, and integrated with Economy/Skills/Endgame.

*Scope:** Optional, server-verified purchases with real money. **Career Year Extension is NOT an IAP** — it is bought with **in‑game money** (see Economy/Endgame).

---

## 0. Goals & Principles
- **Fair & optional:** Core loop fully playable without purchases.
- **Transparent effects:** Every product lists exactly what it changes.
- **No forced timers:** Premium removes ads/waits; non‑premium can still play normally.
- **Server‑authoritative:** Receipts verified; entitlements tracked on server; restores supported.
- **Leaderboards clarity:** Small “IAP” badge for certain effects; optional **Pure** (no‑IAP) board.

---

## 1. Products & Entitlements (SKUs)

> Names are suggestions; final SKUs can be adapted to platform guidelines.

### 1.1 `cash_pack_{S,M,L,XL}`
- **Effect:** Grants **$** (player balance). Posts as **Income** in Weekly Economy. 
- **Use cases:** Promotions, business upgrades, transfers fees (sign‑on spending), lifestyle.  

### 1.2 `rebirth_18`
- **Effect:** Sets **age = 18** while **keeping all skills/OVR/Rep/awards/contracts/money**. Only the age value changes.  
- **Tags:** Career flagged `REBORN` (shows in Career History; optional filter on leaderboards).  
- **Edge cases:** If already ≥ 33 with purchased year extensions, the **extensions remain owned** but are irrelevant until player reaches 33 again.
- **UI copy:** “Rebirth: your age resets to 18. Progress is untouched.”

### 1.3 `premium_upgrade`
- **Effect:** Removes **ads** and **waitings**; unlocks **Skip/Sim** QoL without ad gates.  
- **Also:** Optional perks like extra **Inbox filters**, **cosmetic themes**. No gameplay stat change.  
- **Entitlement:** Non‑consumable, persistent across devices (via login/restore).  
- **UI copy:** “Premium — no ads, no waits, QoL unlocked.”

> **Starter bundle** combining small Cash + Premium. (Discount)
> **Premium starter bundle** combining large Cash + Premium. (Discount)

### Non‑IAP (in‑game money) — for clarity
- **Career Year Extension** — **+1 year** to age cap (base **33**), stack up to **40**.  
  - Bought with **in‑game $** via **Endgame menu** or **Career → Conversion Center** shortcut.  
  - Server tracks `year_extensions_owned` (0..7). Posts as **Expense** in Weekly Economy with `source="CareerExtension"`.  
  - Cap is computed as: `33 + year_extensions_owned` (≤ 40).


---

## 2. Integrations

- **Weekly_Economy.md**  
  - Cash packs post under **Income** -> “IAP: Cash Pack”.  
  - Premium removes “watch ad to skip” style waits (if implemented).  
  - Lifestyle purchases & Business upgrades unaffected (player choice).

- **Skills.md**  
  - Promotions still spend **$**; Banked Progress logic unchanged.

- **Endgame_and_Career_Progression.md**  
  - Rebirth sets age to 18; decline schedule resets by age only.

- **Leaderboards_and_Awards.md**  
  - Display small **IAP** badge for Cash/Rebirth (toggleable).  
  - **Pure** board hides careers with these flags (server filter).

- **System_Notifications.md**  
  - “Purchase successful: +$X added.”   
  - “Premium activated — no ads & waits.”  
  - “Rebirth applied — age set to 18.”

- **UI_UX_Global.md**  
  - **Store** entry: list products, prices, caps, entitlements screen (Premium ON/OFF, Years Unlocked N/7, Rebirth used? Yes/No).

---

## 3. UX Flows

### 3.1 Store Page
- Sections: **Featured**, **Cash**, **Rebirth**, **Premium**.  
- Each card: effect, limits, price, “Learn more”.  
- **Confirm** modal shows: effect summary, caps, refund policy link, platform ToS.  
- **Restore purchases** button (platform‑standard).

### 3.2 Rebirth
- Warning modal: “Age resets to 18. Progress remains. This action is tagged **REBORN**.”  
- Confirm -> server sets `age=18`, writes `career_flags.add("REBORN")`, logs event.

### 3.3 Premium
- Purchase -> enable **no ads / no waits** immediately. Update entitlement panel.  
- Show one‑time “Thanks for supporting” card.

### 3.4 Cash/SP Packs
- After purchase, credit immediately; show toast + Inbox receipt.  
- If weekly cap reached, disable further purchases or apply diminishing returns message.

---

## 5. Data Model (server‑side)

```jsonc
// Purchase receipt (append-only)
{
  "purchase_id": "...",
  "user_id": "...",
  "sku": "cash_pack_M",
  "platform": "ios|android|steam",
  "value": 50,                      // Cash $ amount
  "currency": "USD",
  "credited_at": "2025-09-27T12:00:00Z",
  "verified": true,
  "reversed": false
}
```

Economy ledger entries carry a `source="IAP"` tag for transparency.

---

## 6. Server & Anti‑Fraud
- **Receipt verification** with platform servers; signed payloads; expiry & nonce checks.
- **Idempotency**: `purchase_id` unique; repeated posts do not double‑credit.
- **Rate limits**: throttle purchases per minute; monitor anomaly spikes.
- **Restore**: on login, sync entitlements from server to device.

---

## 7. Tuning Defaults (hooks for Tuning_Constants.md)
- Cash packs: $0.99 / $1.99 / $3.99 / $5.99 / $8.99 / $14.99 (values tuned per economy).  
- Rebirth: $1.99.
- Premium: $3.99 (one‑time).  
- Leaderboards: Pure board filter OFF/ON (default ON for competitive tabs).

> Add these under **Tuning_Constants.md ▸ Monetization** section.

---

## 8. Edge Cases
- **Rebirth with active suspension/injury** -> age resets, status unchanged.  
- **Contracts during Rebirth** -> unchanged (age affects future offers naturally).  
- **League awards after Rebirth** -> tagged; history remains continuous.  
- **Offline purchases** -> Not allowed.

---

## 9. Copy Examples (in‑game)
- “**Premium Active** — ads removed; instant Skip/Sim enabled.”  
- “**Rebirth Applied** — age set to **18**. Your progress remains.”  
- “**$500,000 Added** to your balance.” 

---

### Notes
- All conversions $↔SP are in‑game (not IAP) and handled in **Conversion Center**.
- IAP receipts are server-verified and idempotent;
