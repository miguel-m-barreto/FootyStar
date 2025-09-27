# Refunds & Compliance — Footy Star (EN, final)

**Version:** 1.0 • **Last updated:** 2025‑09‑27  
This document defines refund‑safe wording, UX, and backend behaviours for real‑money store purchases and in‑game virtual‑currency spends. It is implementation guidance and not legal advice.

---

## 1 Scope & Definitions
- **Store purchases (real money):** Transactions processed by **Apple App Store**, **Google Play**, or **Steam**. Examples: Premium, cash packs, Rebirth.
- **Virtual currency (VC) & in‑game spends:** Operations paid with **in‑game money** (e.g., **Career Year Extension**, upgrades, conversions). No store transaction occurs.
- **Entitlement:** A server‑recorded right (e.g., Premium active, currency credited, item owned).
- **Reversal:** A refund/chargeback granted by the store; the platform’s decision overrides any in‑game policy.

---

## 2 Policy Statements (ready‑to‑paste)
### 2.1 Real‑money purchases (store)
> **All purchases are final except where required by applicable law or by the store’s policies (Apple/Google/Steam). Refund requests must be submitted through the store’s official flow.**

### 2.2 Virtual currency & in‑game spends (e.g., Career Year Extension)
> **Virtual‑currency spends are final and non‑refundable after confirmation.** (These are not store transactions.)

*(Use the exact wording above in the ToS, store listings, and in‑game receipts.)*

---

## 3 UX Requirements
- **Irreversible spend modal (VC):**  
  “**Buy +1 Year for $X (in‑game). This action is final.**”  
  *Requires explicit confirm; default button is Cancel.*
- **Receipts screen (store purchases):** Show each receipt with a **“Request a refund”** button that opens the platform’s official page/app.
- **Clear labels:** Distinguish **Store Purchase** vs **In‑game Spend** in the UI.
- **Offline behaviour:** Allow the user to attempt a store purchase offline, but **queue** the request and **credit only after verification** upon reconnect.
- **Regional hint (optional):** If the region demands it, show a one‑time consent that immediate delivery means the user may **lose withdrawal rights** under local law.

---

## 4 Backend Requirements
### 4.1 Receipt verification & idempotency
- Verify store receipts server‑side; enforce **unique `purchase_id`/nonce**; ignore duplicates.
- Credit entitlements **only after** successful verification.

### 4.2 Reversal (refund/chargeback) handling
- On reversal webhook/polling event:
  1) Mark receipt `reversed=true` (append‑only audit).  
  2) **Revoke** entitlements deterministically: turn off Premium; remove unspent purchased currency/items or clamp balances to non‑negative.  
  3) Add a **ledger** entry with negative amounts and `source="STORE_REVERSAL"`.
  4) Notify the player in Inbox: “Store refund processed; related entitlements have been adjusted.”

### 4.3 Economy ledger (in‑game)
- Tag sources precisely: `Exchange` ($↔SP), `CareerExtension`, `Promotion`, `Business`, `Sponsor`, `Award`, `IAP` (credited), `STORE_REVERSAL` (debited).

### 4.4 Data retention & auditing
- Keep receipts, ledger entries, and entitlement history for at least **24 months** (configurable).
- Log actor, timestamp, amounts, and reason for all entitlement changes.

---

## 5 Compliance Copy Blocks (drop‑in)

**Store listing / ToS:**  
“**All purchases are final except where required by applicable law or by the store’s policies (Apple/Google/Steam). Refund requests must be submitted through the store’s official flow.**”

**In‑game (VC spends):**  
“**Virtual‑currency spends are final and non‑refundable after confirmation.**”

**Irreversible spend modal:**  
“**Buy +1 Year for $X (in‑game). This action is final.**”

**Receipts helper text:**  
“To request a refund for a store purchase, use the platform’s official flow.”

---

## 6 QA Checklist
- [ ] Receipt verification (happy path) credits exactly once.  
- [ ] Duplicate receipts are ignored (idempotent).  
- [ ] Reversal revokes entitlements and posts negative ledger correctly.  
- [ ] VC spend modal blocks accidental taps (Cancel is safe default).  
- [ ] Receipts screen links to store refund pages.  
- [ ] Region toggle shows/records withdrawal‑rights consent where required.  
- [ ] Unit/integration tests cover purchase → credit → reversal → audit trail.

---

## 7 Notes
- Platform policies and local laws **override** in‑game wording where applicable.  
- Keep this file versioned alongside code changes that touch purchases, ledger, or ToS.
