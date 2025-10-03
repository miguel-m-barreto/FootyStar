// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get activeContract => 'Active Contract';

  @override
  String get addDemoMessage => 'Add demo message';

  @override
  String get advanceWeek => 'Advance Week';

  @override
  String ageAge(int age) {
    return 'Age $age';
  }

  @override
  String get annual => 'Annual';

  @override
  String get cancel => 'Cancel';

  @override
  String get careerStatistics => 'Career statistics';

  @override
  String get careerStats => 'Career Stats';

  @override
  String get casino => 'Casino';

  @override
  String get casinoAllIn => 'Casino — All In';

  @override
  String casinoLoss(double loss, double cash) {
    return 'Casino loss! You lost $loss. New cash: $cash';
  }

  @override
  String get casinoPlaceBet => 'Casino — Place Bet';

  @override
  String casinoWin(double delta, double cash) {
    return 'Casino win! You won $delta. New cash: $cash';
  }

  @override
  String get cash => 'Cash';

  @override
  String get clauses => 'Clauses';

  @override
  String get clearAll => 'Clear all';

  @override
  String get contractDetails => 'Contract Details';

  @override
  String get costs => 'Costs';

  @override
  String get delta => 'Delta';

  @override
  String get duration => 'Duration';

  @override
  String get economy => 'Economy';

  @override
  String get enterAnyAmount => 'Enter any amount (up to your cash)';

  @override
  String get finance => 'Finance';

  @override
  String get general => 'General';

  @override
  String get goToMatches => 'Go to Matches';

  @override
  String get home => 'Home';

  @override
  String get income => 'Income';

  @override
  String get language => 'Language';

  @override
  String get languageChanged => 'Language changed';

  @override
  String get leagueTable => 'League table';

  @override
  String get loyaltyBonus => 'Loyalty Bonus';

  @override
  String lvLevel(int level) {
    return 'Lv $level';
  }

  @override
  String matchPlayedFriendly(Object home, Object away) {
    return 'Match played\n$home vs $away (friendly/unscheduled)';
  }

  @override
  String matchResult(int week, Object home, int hg, int ag, Object away) {
    return 'Match result — Week $week\n$home $hg - $ag $away';
  }

  @override
  String get matchScheduled => 'Match scheduled';

  @override
  String get myTeam => 'My Team';

  @override
  String get nationalStandings => 'National Standings';

  @override
  String get negotiate => 'Negotiate';

  @override
  String get nextMatch => 'Next match';

  @override
  String nextOpponent(Object opponent) {
    return 'Next opponent: $opponent';
  }

  @override
  String get noFixturesScheduled => 'No fixtures scheduled';

  @override
  String get noNotifications => 'No notifications yet';

  @override
  String get noStandingsYet =>
      'No standings yet. Play a match to populate the table.';

  @override
  String get notifications => 'Notifications';

  @override
  String get ok => 'OK';

  @override
  String get perAssist => 'Per Assist';

  @override
  String get perGoal => 'Per Goal';

  @override
  String get performanceBonuses => 'Performance Bonuses';

  @override
  String get play => 'Play';

  @override
  String get playAdvance => 'Play & Advance';

  @override
  String get playersStandings => 'Players Standings';

  @override
  String get preview => 'Preview';

  @override
  String get previewSubtitle => 'Quick preview of common labels';

  @override
  String raiseApproved(double inc, double next) {
    return 'Raise approved (+$inc/week). New salary: $next/week.';
  }

  @override
  String get raiseDenied =>
      'Raise denied for now. Improve your form & reputation to increase chances.';

  @override
  String get reject => 'Reject';

  @override
  String get releaseClause => 'Release Clause';

  @override
  String get requestSalaryRaise => 'Request Salary Raise';

  @override
  String get requestTransfer => 'Request Transfer';

  @override
  String resultScore(int hg, int ag) {
    return 'Result: $hg - $ag';
  }

  @override
  String get restAllSquad => 'Rest All Squad';

  @override
  String get salary => 'Salary';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get settings => 'Settings';

  @override
  String get skills => 'Skills';

  @override
  String statusPercent(Object status, int value) {
    return 'Status: $status ($value%)';
  }

  @override
  String get store => 'Store';

  @override
  String get topAssists => 'Top Assists';

  @override
  String get topScorers => 'Top Scorers';

  @override
  String get train => 'Train';

  @override
  String get trophiesMilestones => 'Trophies & milestones';

  @override
  String get tryYourLuck => 'Try your luck';

  @override
  String get viewContract => 'View Contract';

  @override
  String wWeek(int week) {
    return 'W$week';
  }

  @override
  String get wagerAmount => 'Wager amount';

  @override
  String get week => 'Week';

  @override
  String get weekly => 'Weekly';

  @override
  String get weeklyCosts => 'Weekly Costs';

  @override
  String get weeklyIncome => 'Weekly Income';
}
