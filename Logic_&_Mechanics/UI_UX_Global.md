# Footy Star v1.0.1
## UI/UX Global - Navigation, Screens & Flows

This document centralises the player-facing experience: menu structure, home/dashboard, stats, reports, and navigation between modules.

---

## 1. Navigation Map (Top-Level)
- **Home** (Dashboard)
- **Match** (Play / Watch / Summary)
- **Skills**
- **Training** (read-only status)
- **Career** (Contracts, Transfers & Market)
- **Economy** (Weekly Statement, Businesses, Casino)
- **Stats** (Leaderboards Local/Global, Season Report)
- **Calendar**
- **Inbox** (System Notifications & Events log)
- **Relationships** (Coach, Agent, Family, Pets) *(read-only meters + narrative hooks)*
- **Settings** (Accessibility, Speed, Language)

All tabs are accessible via top nav (mobile) or left rail (tablet/desktop) (FUTURE).

---

## 2. Home / Dashboard
**Purpose:** One-glance weekly state and quick actions.

**Header widgets**
- **Next Fixture card**: opponent, date, venue; buttons: *Play* / *Sim*.
- **Form & Fitness**: last 3 ratings, injury/ban status.
- **Coach Note** (if any): short tip; click opens Relationships -> Coach.
- **Balance**: current $ balance + delta vs last week; link to Economy.

**Feed**
- **System notifications** (calendar, windows, intl break).
- **Training**: “Skill ready to promote” entries (tap opens Skills at that skill).
- **Events**: latest narrative outcomes (one line; tap to open details).
- **Awards** (when season closes): summary card with rewards claimed.

Actions surfaced:
- **Promote Skills** (if any queued)
- **Open Transfer Hub** (if window open or Inbox has offers)
- **Invest/Upgrade** (if any business has upgrade available)

---

## 3. Match Flow (Watch / Skip)
- From Home or Calendar, tap Next Fixture -> **Match Presentation** (2D) or **Skip to Summary**.
- **Summary screen** always shows: score, stats, ratings, XP/SP, Rep change, MOM.
- “Continue” returns to Home; engine then runs Training, Events, Economy close.

---

## 4. Skills Screen
- List of 28 skills with current **Level**, **XP bar**.
- Buttons: in the row of the skill -> **Promote (1)**, top button -> **Promote All**. Shows total $ before confirm.
- OVR/RoleOVR panel (read-only). Tooltip explains that OVR changes only after promotion.

---

## 5. Training Screen (read-only)
- Current **week outcome**: XP applied (top 3 skills only), “Training completed”, injuries.
- Toggle to view **Micro-events** (if any) and their effects.
- Link: “How training works” (opens help). No manual routines.
- Selector: **Auto** (default), **Attack**, **Midfield**, **Defense**, **Recovery** (optional).
- Bias: up to **20%** of weekly training XP towards the chosen cluster. Coach logic drives the remaining ≥80%.
- Congestion/Intl breaks may reduce the bias automatically (injury risk management).

---

## 6. Career
### 6.1 Contracts
- Current contract card (club, role, wage, bonuses, ends in X weeks).
- Offers inbox (if any) with **Accept / Counter / Decline**.
- Market Value read-only (from Contracts).

### 6.2 Transfers & Market
- Tabs: **Inbox**, **Shortlist**, **Market Radar**, **Deadlines**.
- Offer viewer shows fee, wage expectation, role projection, acceptability meter.

---

## 7. Economy
- **Weekly Statement** list (chronological). Entry shows: `Income +$X / Expenses -$Y -> Balance $Z`.
- Drill into a week to see **line items** (salary, bonuses, prizes, business income, promotions, bets, etc.).
- **Businesses**: owned items with Level, Next Upgrade $ and resulting income.
- **Casino**: simple panel with caps and responsible play notice.
- **Conversion Center**
    - **Buy SP** (in‑game $ → SP): shows current price, caps, and spread.
    - **Sell SP** (SP → in‑game $): shows current price, caps, and origin rule (only SP earned in‑game sellable).
    - Live indicator of **weekly caps** and **surge pricing** if SP_balance is high.
    - Ledger summary for each conversion (“Exchange: +N SP for $X / +$Y for N SP”).


---

## 8. Stats
- **Leaderboards**: tabs per League + **Global**; filters (position, min minutes, per‑90).
- **Season Report** (per league): your season summary + awards + graph of ratings over time.
- **Career History**: accumulated awards, transfers, milestones.

---

## 9. Calendar
- Month view with icons: League, Cup, Intl Break, Training, Awards.
- Clicking a week opens its details (fixtures, expected training load, cup rounds).

---

## 10. Inbox
- Merged feed: **System Notifications**, **Events** decisions history, **Awards** claim receipts.
- Max 2 sticky system notices per week; others collapse into the log.

---

## 11. Relationships (read-only meters)
- **Coach**: 0–100, affected by performance/training/events.
- **Agent**: 0–100, affected by negotiations, payments, loyalty choices.
- **Family**: separate meters (Mother, Father) 0–100 via Events.
- **Partner** *(optional feature toggle)*: 0–100; narrative only.
- **Pets**: happiness 0–100; affects Confidence small.
- Each meter shows current value, last change, and potential hooks (“High Coach -> selection boost”).

---

### Career ▸ **Endgame**
- Panel shows: current **age**, **cap** (`33 + year_extensions_owned`), and **Extensions owned** (0..7).  
- Button **“Buy +1 Year (in‑game $)”** — disabled if cap=40.  
- If at cap on season end, the **Retirement Prompt** offers: Continue 1 year (requires purchase) / New league / Retire.

---

## 12. Accessibility & QoL
- Speed controls for Match (x1–x4).
- Color‑blind safe palette.
- Number formatting by locale; language toggle (EN/PT).
- Autosave after each weekly close.

---

## 13. Dev Notes
- UI strings come from locale files; no hard‑coded text in logic.
- All screens are **data‑driven**; state pulled from the core engine tick.
