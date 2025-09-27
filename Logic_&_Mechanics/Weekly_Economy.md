# Footy Star v1.0.1

## Weekly Economy (integrated with Skills, Contracts, Investments)

This module governs the **cashflow cycle** of the player. Money is earned mainly via football (Contracts, Matches, Competitions) and can be spent on **Skill promotions**, **Business investments**, and **Casino**. Lifestyle, sponsorships and taxes are placeholders for future expansion.

---

## 1. Income (weekly inflows)
- **Salary** - From active contract (Contracts.md).
- **Performance bonuses** - Per goal/assist/MOM as defined in contract.
- **Competition prizes** - Club payouts for wins, cups, progression in tournaments.
- **Business income** - Weekly fixed returns from owned businesses (see Investments.md).
- **Sponsorships** - Sponsorships & Lifestyle
- **IAP / Cash packs** - Purchases in the SHOP
- **Awards payouts** - Season close   
- **Exchange inflows** (SP→$)

*(Future)*  
- **Sponsorships / endorsements** - Scale with Reputation, OVR and Social presence.  
- **Media/social bonuses** - Paid appearances, streaming, events.

---

## 2. Expenses (weekly outflows)
- **Skill promotions** - Main sink. Use cost curve from Skills.md; promotions require $.
- **Business purchases / upgrades** - Capital outflow when buying/upgrading a business (Investments.md).
- **Casino bets** - Money staked in casino games; resolved immediately (see Investments.md).
- **Exchange outflows** ($→SP)

*(Future)*  
- **Lifestyle** - Housing, vehicles, luxury, social spending (flavor + Confidence/CoachRelation effects).  
- **Agent fees** - Fixed percentage (e.g. 10%) of salary/transfer bonuses.  
- **Taxes** - League/country dependent percentage deduction.

- **TO THINK** - Lifestyle upkeep (Sponsorships & Lifestyle) 

### Conversions (Conversion Center)
- **$→SP (Buy SP):** price shown in UI (from Tuning_Constants ▸ SP_Exchange); respects weekly caps and surge rules.
- **SP→$ (Sell SP):** only SP **earned in‑game**; applies spread and weekly caps.
- Ledger tag: `source="Exchange"` for both operations.


### Notifications
- “Weekly statement ready: +$X / -$Y → $Z”
- “Exchange: +N SP for $X / +$Y for N SP”


---

## 3. Cashflow formula
```
balance_next = balance_current 
             + (salary + bonuses + prizes + business_income) 
             - (promotions + business_purchases + casino_losses + lifestyle + agent + taxes)
```

---

## 4. Weekly cycle (integration)
- Monday: Salary credited.
- After matches: Bonuses/prizes applied.
- End of week: Income from businesses credited, expenses deducted (skill promotions, business upgrades, casino net).  
- Home screen: Notification “Weekly statement ready: +$X income, -$Y expenses, new balance $Z”.
- Home: Notification “Weekly statement ready: +$X, -$Y, balance $Z”.
- Ledger tags: source="Salary|Bonus|Prize|Business|Sponsor|Award|IAP|Promotion|Upgrade|Casino|Lifestyle".

---

## 5. Hooks to other systems
- **Skills.md** - Promotions cost money.
- **Match.md** - Determines bonuses and performance prizes.
- **Contracts.md** - Source of salary.
- **Investments.md** - Outflow (business purchases, casino bets) and inflow (business income, casino wins).
- **League_Calendar.md** - Defines when matches/prizes occur.

---

## 6. Examples
- **Lower‑league bench DF**: Salary $300/week, no bonuses -> Balance grows slowly; can only afford rare skill promotions, saves for a Café.  
- **Elite starter MF**: Salary $20k/week + bonuses -> Rapid growth; can buy Spa/Gym quickly and stack income.  
- **Casino addict**: Bets 50% of salary each week; volatile results, sometimes broke, sometimes jackpot.  
- **Investor**: Focuses on business upgrades; compound income over the season yields steady growth.

---

## 7. Future extensions
- Sponsorship & endorsements scaling with Reputation.  
- Lifestyle affecting Confidence/CoachRelation (positive if moderate, negative if excessive).  
- Taxes & agent fees reducing net income depending on league/country.  
- Loans/credit (borrow to promote skills earlier, repay later).  
- Gambling addiction / scandals (flavor events, affect Reputation).

---

## 8. Tuning constants
- Skill promotion cost curve: see Skills.md (X0=30, X1=350 XP; C0=$300, C1=$13k).  
- Contract bonuses: Goal $200, Assist $100, MOM $400 (default).  
- Business rules: see Investments.md (C0, W0, ΔW = 1.125×W0, upgrades cost factor u=0.5, growth 1.25).  
- Casino: slots house edge ~5%, blackjack ~2%, sportsbook margin 4-7%; weekly cap = min($5,000, 0.5×salary).  
- Lifestyle/agent/taxes: not implemented in v1.0.1.

---

## 9. Implementation notes (dev)
- Weekly tick: process salary/bonuses first, then business income, then apply casino results, then deduct expenses (promotions, upgrades).  
- Businesses stored per player `{business_id, level, invested_total}`.  
- Casino outcomes recorded per bet `{game, stake, outcome, net}`.  
- Cashflow log kept as **Weekly Statement** for player review.

