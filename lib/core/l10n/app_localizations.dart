import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @activeContract.
  ///
  /// In en, this message translates to:
  /// **'Active Contract'**
  String get activeContract;

  /// No description provided for @addDemoMessage.
  ///
  /// In en, this message translates to:
  /// **'Add demo message'**
  String get addDemoMessage;

  /// No description provided for @advanceWeek.
  ///
  /// In en, this message translates to:
  /// **'Advance Week'**
  String get advanceWeek;

  /// No description provided for @ageAge.
  ///
  /// In en, this message translates to:
  /// **'Age {age}'**
  String ageAge(int age);

  /// No description provided for @annual.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get annual;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @careerStatistics.
  ///
  /// In en, this message translates to:
  /// **'Career statistics'**
  String get careerStatistics;

  /// No description provided for @careerStats.
  ///
  /// In en, this message translates to:
  /// **'Career Stats'**
  String get careerStats;

  /// No description provided for @casino.
  ///
  /// In en, this message translates to:
  /// **'Casino'**
  String get casino;

  /// No description provided for @casinoAllIn.
  ///
  /// In en, this message translates to:
  /// **'Casino — All In'**
  String get casinoAllIn;

  /// No description provided for @casinoLoss.
  ///
  /// In en, this message translates to:
  /// **'Casino loss! You lost {loss}. New cash: {cash}'**
  String casinoLoss(double loss, double cash);

  /// No description provided for @casinoPlaceBet.
  ///
  /// In en, this message translates to:
  /// **'Casino — Place Bet'**
  String get casinoPlaceBet;

  /// No description provided for @casinoWin.
  ///
  /// In en, this message translates to:
  /// **'Casino win! You won {delta}. New cash: {cash}'**
  String casinoWin(double delta, double cash);

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @clauses.
  ///
  /// In en, this message translates to:
  /// **'Clauses'**
  String get clauses;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @contractDetails.
  ///
  /// In en, this message translates to:
  /// **'Contract Details'**
  String get contractDetails;

  /// No description provided for @costs.
  ///
  /// In en, this message translates to:
  /// **'Costs'**
  String get costs;

  /// No description provided for @delta.
  ///
  /// In en, this message translates to:
  /// **'Delta'**
  String get delta;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @economy.
  ///
  /// In en, this message translates to:
  /// **'Economy'**
  String get economy;

  /// No description provided for @enterAnyAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter any amount (up to your cash)'**
  String get enterAnyAmount;

  /// No description provided for @finance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get finance;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @goToMatches.
  ///
  /// In en, this message translates to:
  /// **'Go to Matches'**
  String get goToMatches;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed'**
  String get languageChanged;

  /// No description provided for @leagueTable.
  ///
  /// In en, this message translates to:
  /// **'League table'**
  String get leagueTable;

  /// No description provided for @loyaltyBonus.
  ///
  /// In en, this message translates to:
  /// **'Loyalty Bonus'**
  String get loyaltyBonus;

  /// No description provided for @lvLevel.
  ///
  /// In en, this message translates to:
  /// **'Lv {level}'**
  String lvLevel(int level);

  /// No description provided for @matchPlayedFriendly.
  ///
  /// In en, this message translates to:
  /// **'Match played\n{home} vs {away} (friendly/unscheduled)'**
  String matchPlayedFriendly(Object home, Object away);

  /// No description provided for @matchResult.
  ///
  /// In en, this message translates to:
  /// **'Match result — Week {week}\n{home} {hg} - {ag} {away}'**
  String matchResult(int week, Object home, int hg, int ag, Object away);

  /// No description provided for @matchScheduled.
  ///
  /// In en, this message translates to:
  /// **'Match scheduled'**
  String get matchScheduled;

  /// No description provided for @myTeam.
  ///
  /// In en, this message translates to:
  /// **'My Team'**
  String get myTeam;

  /// No description provided for @nationalStandings.
  ///
  /// In en, this message translates to:
  /// **'National Standings'**
  String get nationalStandings;

  /// No description provided for @negotiate.
  ///
  /// In en, this message translates to:
  /// **'Negotiate'**
  String get negotiate;

  /// No description provided for @nextMatch.
  ///
  /// In en, this message translates to:
  /// **'Next match'**
  String get nextMatch;

  /// No description provided for @nextOpponent.
  ///
  /// In en, this message translates to:
  /// **'Next opponent: {opponent}'**
  String nextOpponent(Object opponent);

  /// No description provided for @noFixturesScheduled.
  ///
  /// In en, this message translates to:
  /// **'No fixtures scheduled'**
  String get noFixturesScheduled;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotifications;

  /// No description provided for @noStandingsYet.
  ///
  /// In en, this message translates to:
  /// **'No standings yet. Play a match to populate the table.'**
  String get noStandingsYet;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @perAssist.
  ///
  /// In en, this message translates to:
  /// **'Per Assist'**
  String get perAssist;

  /// No description provided for @perGoal.
  ///
  /// In en, this message translates to:
  /// **'Per Goal'**
  String get perGoal;

  /// No description provided for @performanceBonuses.
  ///
  /// In en, this message translates to:
  /// **'Performance Bonuses'**
  String get performanceBonuses;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @playAdvance.
  ///
  /// In en, this message translates to:
  /// **'Play & Advance'**
  String get playAdvance;

  /// No description provided for @playersStandings.
  ///
  /// In en, this message translates to:
  /// **'Players Standings'**
  String get playersStandings;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @previewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick preview of common labels'**
  String get previewSubtitle;

  /// No description provided for @raiseApproved.
  ///
  /// In en, this message translates to:
  /// **'Raise approved (+{inc}/week). New salary: {next}/week.'**
  String raiseApproved(double inc, double next);

  /// No description provided for @raiseDenied.
  ///
  /// In en, this message translates to:
  /// **'Raise denied for now. Improve your form & reputation to increase chances.'**
  String get raiseDenied;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @releaseClause.
  ///
  /// In en, this message translates to:
  /// **'Release Clause'**
  String get releaseClause;

  /// No description provided for @requestSalaryRaise.
  ///
  /// In en, this message translates to:
  /// **'Request Salary Raise'**
  String get requestSalaryRaise;

  /// No description provided for @requestTransfer.
  ///
  /// In en, this message translates to:
  /// **'Request Transfer'**
  String get requestTransfer;

  /// No description provided for @resultScore.
  ///
  /// In en, this message translates to:
  /// **'Result: {hg} - {ag}'**
  String resultScore(int hg, int ag);

  /// No description provided for @restAllSquad.
  ///
  /// In en, this message translates to:
  /// **'Rest All Squad'**
  String get restAllSquad;

  /// No description provided for @salary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salary;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @skills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skills;

  /// No description provided for @statusPercent.
  ///
  /// In en, this message translates to:
  /// **'Status: {status} ({value}%)'**
  String statusPercent(Object status, int value);

  /// No description provided for @store.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

  /// No description provided for @topAssists.
  ///
  /// In en, this message translates to:
  /// **'Top Assists'**
  String get topAssists;

  /// No description provided for @topScorers.
  ///
  /// In en, this message translates to:
  /// **'Top Scorers'**
  String get topScorers;

  /// No description provided for @train.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get train;

  /// No description provided for @trophiesMilestones.
  ///
  /// In en, this message translates to:
  /// **'Trophies & milestones'**
  String get trophiesMilestones;

  /// No description provided for @tryYourLuck.
  ///
  /// In en, this message translates to:
  /// **'Try your luck'**
  String get tryYourLuck;

  /// No description provided for @viewContract.
  ///
  /// In en, this message translates to:
  /// **'View Contract'**
  String get viewContract;

  /// No description provided for @wWeek.
  ///
  /// In en, this message translates to:
  /// **'W{week}'**
  String wWeek(int week);

  /// No description provided for @wagerAmount.
  ///
  /// In en, this message translates to:
  /// **'Wager amount'**
  String get wagerAmount;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @weeklyCosts.
  ///
  /// In en, this message translates to:
  /// **'Weekly Costs'**
  String get weeklyCosts;

  /// No description provided for @weeklyIncome.
  ///
  /// In en, this message translates to:
  /// **'Weekly Income'**
  String get weeklyIncome;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
