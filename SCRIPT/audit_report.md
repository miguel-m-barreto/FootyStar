# Audit FootyStar
_Gerado automaticamente. Ignorado: cores dentro de lib/core/theme/._

## 1) Icons diretos (usar AppIcons)

**lib/features/contracts/ui/contract_screen.dart**
- L57: `Icons.verified,`
- L124: `_BonusTile(label: l10n.perGoal, amount: bonusGoal, icon: Icons.sports_soccer),`
- L126: `_BonusTile(label: l10n.perAssist, amount: bonusAssist, icon: Icons.assistant),`
- L130: `_BonusTile(label: l10n.manOfTheMatch, amount: bonusMotm, icon: Icons.star),`

**lib/features/finance/ui/economy_screen.dart**
- L51: `icon: Icons.trending_up,`
- L60: `icon: Icons.trending_down,`
- L73: `icon: Icons.home,`
- L82: `icon: Icons.business,`
- L91: `icon: Icons.casino,`
- L157: `trailing: const Icon(Icons.chevron_right),`

**lib/features/finance/ui/finance_hub_screen.dart**
- L20: `Icons.construction,`

**lib/features/general/ui/general_hub_screen.dart**
- L29: `icon: Icons.person,`
- L35: `icon: Icons.group,`
- L41: `icon: Icons.emoji_events,`
- L47: `icon: Icons.swap_horiz,`
- L53: `icon: Icons.flag,`
- L59: `icon: Icons.sports_soccer,`
- L65: `icon: Icons.military_tech,`
- L71: `icon: Icons.bar_chart,`
- L105: `trailing: const Icon(Icons.chevron_right),`

**lib/features/home/ui/home_screen.dart**
- L24: `icon: const Icon(Icons.skip_next),`
- L74: `leading: const Icon(Icons.sports_soccer),`
- L201: `trailing: Icon(isRead ? Icons.mark_email_read : Icons.mark_email_unread),`

**lib/features/profile/ui/profile_screen.dart**
- L41: `icon: Icons.sports,`
- L51: `icon: Icons.handshake,`
- L66: `icon: const Icon(Icons.trending_up),`
- L71: `icon: const Icon(Icons.flight_takeoff),`
- L81: `icon: const Icon(Icons.description),`

**lib/features/squad/ui/squad_screen.dart**
- L29: `trailing: const Icon(Icons.chevron_right),`

**lib/features/store/ui/store_hub_screen.dart**
- L20: `icon: Icons.payment,`
- L29: `icon: Icons.timer,`
- L60: `trailing: const Icon(Icons.chevron_right),`

**lib/features/training/ui/training_screen.dart**
- L109: `icon: const Icon(Icons.health_and_safety),`
- L184: `icon: Icons.star,`
- L189: `icon: Icons.timeline,`
- L194: `icon: Icons.military_tech,`

## 2) Cores hardcoded (usar Theme.of(context).colorScheme.* ou tokens do tema)

**lib/features/finance/ui/economy_screen.dart**
- L52: `color: Colors.green,`
- L61: `color: Colors.red,`

**lib/features/skills/ui/skills_screen.dart**
- L131: `color: canAfford ? Colors.green : Colors.red,`

**lib/features/training/ui/training_screen.dart**
- L166: `color: Colors.green,`
- L174: `color: Colors.orange,`

## 3) Texto hardcoded (usar l10n)

**lib/main.dart**
- L23: `title: 'Footy Star',`
