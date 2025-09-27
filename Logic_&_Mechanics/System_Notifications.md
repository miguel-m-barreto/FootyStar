# Footy Star v1.0.1
## System Notifications - Calendar & System Feeds

Centralised, low‑noise notifications for key calendar/system events. Shown on Home and stored in a simple log. No emojis.

### Triggers
- **Transfer window opens/closes** (per league from League_Calendar).
  - “Transfer window is now OPEN (Jan 1–31).”
  - “Transfer window CLOSED.”
- **International break week** (from League_Calendar.intl_breaks_fifa).
  - “International break this week - reduced domestic fixtures/training volume.”
- **Cup round week** (from League_Calendar.domestic_cup).
  - “Domestic Cup Round this week.”
- **Match rescheduled to midweek** (based on midweek_probability scheduling).
  - “Midweek fixture added - training volume adjusted.”

### Display rules
- Max 2 calendar notifications per week.
- Sticky until dismissed or week ends.
- Links open relevant screen (Transfers Hub, Calendar).

### Other system feeds
- **Training**: “Training completed”; “[Skill] ready to promote.”
- **Investments**: “Business income credited: +$X.”; “Upgrade available: [Business], cost $Y.”
- **Random Events**: appear as separate event popups; only summary line goes to log.
- **Economy**: "Weekly statement ready: +$X / -$Y → $Z".
- **Sponsorships**: "Sponsor payout credited: +$X"; "New sponsor offer available".
- **Awards**: "League MVP won - +$N, +Rep credited".
- **Exchange**: “Bought **N SP** for **$X**” / “Sold **N SP** for **$Y**”

