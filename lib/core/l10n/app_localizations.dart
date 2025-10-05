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

  /// No description provided for @notifications_economy.
  ///
  /// In en, this message translates to:
  /// **'Economy'**
  String get notifications_economy;

  /// No description provided for @notifications_general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get notifications_general;

  /// No description provided for @notifications_match.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get notifications_match;

  /// No description provided for @notifications_skills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get notifications_skills;

  /// No description provided for @notifications_economy_week_summary.
  ///
  /// In en, this message translates to:
  /// **'Revenue: {revenue} • Costs: {costs} • Delta: {delta} • Balance: {balance}'**
  String notifications_economy_week_summary(
    Object balance,
    Object costs,
    Object delta,
    Object revenue,
  );

  /// No description provided for @notifications_week_finished.
  ///
  /// In en, this message translates to:
  /// **'Week {week} finished'**
  String notifications_week_finished(Object week);

  /// No description provided for @notifications_match_result.
  ///
  /// In en, this message translates to:
  /// **'Result — Week {week}\n{home} {score} {away}'**
  String notifications_match_result(
    Object away,
    Object home,
    Object score,
    Object week,
  );

  /// No description provided for @notifications_skills_promoted_count.
  ///
  /// In en, this message translates to:
  /// **'Promoted {count} skills for {cost}'**
  String notifications_skills_promoted_count(Object cost, Object count);

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @cleanSheet.
  ///
  /// In en, this message translates to:
  /// **'Clean Sheet'**
  String get cleanSheet;

  /// No description provided for @manOfTheMatch.
  ///
  /// In en, this message translates to:
  /// **'Man of the Match'**
  String get manOfTheMatch;

  /// No description provided for @wageRiseAfter20Games.
  ///
  /// In en, this message translates to:
  /// **'Wage Rise After 20 Games'**
  String get wageRiseAfter20Games;

  /// No description provided for @afterNYears.
  ///
  /// In en, this message translates to:
  /// **'after {years} years'**
  String afterNYears(int years);

  /// No description provided for @yearsDur.
  ///
  /// In en, this message translates to:
  /// **'{count} years'**
  String yearsDur(int count);

  /// No description provided for @positionShort.
  ///
  /// In en, this message translates to:
  /// **'#'**
  String get positionShort;

  /// No description provided for @acceleration.
  ///
  /// In en, this message translates to:
  /// **'Acceleration'**
  String get acceleration;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @agility.
  ///
  /// In en, this message translates to:
  /// **'Agility'**
  String get agility;

  /// No description provided for @annual.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get annual;

  /// No description provided for @anticipation.
  ///
  /// In en, this message translates to:
  /// **'Anticipation'**
  String get anticipation;

  /// No description provided for @assists.
  ///
  /// In en, this message translates to:
  /// **'Assists'**
  String get assists;

  /// No description provided for @bravery.
  ///
  /// In en, this message translates to:
  /// **'Bravery'**
  String get bravery;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @career.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get career;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @casino.
  ///
  /// In en, this message translates to:
  /// **'Casino'**
  String get casino;

  /// No description provided for @clauses.
  ///
  /// In en, this message translates to:
  /// **'Clauses'**
  String get clauses;

  /// No description provided for @composure.
  ///
  /// In en, this message translates to:
  /// **'Composure'**
  String get composure;

  /// No description provided for @consistency.
  ///
  /// In en, this message translates to:
  /// **'Consistency'**
  String get consistency;

  /// No description provided for @costs.
  ///
  /// In en, this message translates to:
  /// **'Costs'**
  String get costs;

  /// No description provided for @drawsShort.
  ///
  /// In en, this message translates to:
  /// **'D'**
  String get drawsShort;

  /// No description provided for @determination.
  ///
  /// In en, this message translates to:
  /// **'Determination'**
  String get determination;

  /// No description provided for @dribbling.
  ///
  /// In en, this message translates to:
  /// **'Dribbling'**
  String get dribbling;

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

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @fatigue.
  ///
  /// In en, this message translates to:
  /// **'Fatigue'**
  String get fatigue;

  /// No description provided for @finance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get finance;

  /// No description provided for @finishing.
  ///
  /// In en, this message translates to:
  /// **'Finishing'**
  String get finishing;

  /// No description provided for @flexibility.
  ///
  /// In en, this message translates to:
  /// **'Flexibility'**
  String get flexibility;

  /// No description provided for @form.
  ///
  /// In en, this message translates to:
  /// **'Form'**
  String get form;

  /// No description provided for @goalsAgainstShort.
  ///
  /// In en, this message translates to:
  /// **'GA'**
  String get goalsAgainstShort;

  /// No description provided for @goalDifferenceShort.
  ///
  /// In en, this message translates to:
  /// **'GD'**
  String get goalDifferenceShort;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @goalsForShort.
  ///
  /// In en, this message translates to:
  /// **'GF'**
  String get goalsForShort;

  /// No description provided for @goals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goals;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @heading.
  ///
  /// In en, this message translates to:
  /// **'Heading'**
  String get heading;

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

  /// No description provided for @investments.
  ///
  /// In en, this message translates to:
  /// **'Investments'**
  String get investments;

  /// No description provided for @jumping.
  ///
  /// In en, this message translates to:
  /// **'Jumping'**
  String get jumping;

  /// No description provided for @lossesShort.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get lossesShort;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @leadership.
  ///
  /// In en, this message translates to:
  /// **'Leadership'**
  String get leadership;

  /// No description provided for @lifestyle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get lifestyle;

  /// No description provided for @marking.
  ///
  /// In en, this message translates to:
  /// **'Marking'**
  String get marking;

  /// No description provided for @matches.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get matches;

  /// No description provided for @mental.
  ///
  /// In en, this message translates to:
  /// **'Mental'**
  String get mental;

  /// No description provided for @morale.
  ///
  /// In en, this message translates to:
  /// **'Morale'**
  String get morale;

  /// No description provided for @negotiate.
  ///
  /// In en, this message translates to:
  /// **'Negotiate'**
  String get negotiate;

  /// No description provided for @newOffer.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get newOffer;

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

  /// No description provided for @ovr.
  ///
  /// In en, this message translates to:
  /// **'OVR'**
  String get ovr;

  /// No description provided for @playedShort.
  ///
  /// In en, this message translates to:
  /// **'P'**
  String get playedShort;

  /// No description provided for @physical.
  ///
  /// In en, this message translates to:
  /// **'Physical'**
  String get physical;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @portuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portuguese;

  /// No description provided for @positioning.
  ///
  /// In en, this message translates to:
  /// **'Positioning'**
  String get positioning;

  /// No description provided for @power.
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get power;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @pointsShort.
  ///
  /// In en, this message translates to:
  /// **'Pts'**
  String get pointsShort;

  /// No description provided for @ratings.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get ratings;

  /// No description provided for @recovery.
  ///
  /// In en, this message translates to:
  /// **'Recovery'**
  String get recovery;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @rep.
  ///
  /// In en, this message translates to:
  /// **'Rep'**
  String get rep;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @roleRotation.
  ///
  /// In en, this message translates to:
  /// **'Rotation'**
  String get roleRotation;

  /// No description provided for @salary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salary;

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

  /// No description provided for @squad.
  ///
  /// In en, this message translates to:
  /// **'Squad'**
  String get squad;

  /// No description provided for @stamina.
  ///
  /// In en, this message translates to:
  /// **'Stamina'**
  String get stamina;

  /// No description provided for @standings.
  ///
  /// In en, this message translates to:
  /// **'Standings'**
  String get standings;

  /// No description provided for @roleStarter.
  ///
  /// In en, this message translates to:
  /// **'Starter'**
  String get roleStarter;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @store.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

  /// No description provided for @tackling.
  ///
  /// In en, this message translates to:
  /// **'Tackling'**
  String get tackling;

  /// No description provided for @team.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get team;

  /// No description provided for @technical.
  ///
  /// In en, this message translates to:
  /// **'Technical'**
  String get technical;

  /// No description provided for @technique.
  ///
  /// In en, this message translates to:
  /// **'Technique'**
  String get technique;

  /// No description provided for @train.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get train;

  /// No description provided for @vision.
  ///
  /// In en, this message translates to:
  /// **'Vision'**
  String get vision;

  /// No description provided for @winsShort.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get winsShort;

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

  /// No description provided for @wWeek.
  ///
  /// In en, this message translates to:
  /// **'W{week}'**
  String wWeek(int week);

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

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

  /// No description provided for @agentRelationship.
  ///
  /// In en, this message translates to:
  /// **'Agent Relationship'**
  String get agentRelationship;

  /// No description provided for @bestRatings.
  ///
  /// In en, this message translates to:
  /// **'Best Ratings'**
  String get bestRatings;

  /// No description provided for @bodyStrength.
  ///
  /// In en, this message translates to:
  /// **'Body Strength'**
  String get bodyStrength;

  /// No description provided for @investmentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Business portfolio'**
  String get investmentsSubtitle;

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

  /// No description provided for @cashPacksAndPremium.
  ///
  /// In en, this message translates to:
  /// **'Cash packs & Premium'**
  String get cashPacksAndPremium;

  /// No description provided for @casinoLoss.
  ///
  /// In en, this message translates to:
  /// **'Casino loss! You lost {loss}. New cash: {cash}'**
  String casinoLoss(double loss, double cash);

  /// No description provided for @casinoWin.
  ///
  /// In en, this message translates to:
  /// **'Casino win! You won {delta}. New cash: {cash}'**
  String casinoWin(double delta, double cash);

  /// No description provided for @casinoAllIn.
  ///
  /// In en, this message translates to:
  /// **'Casino — All In'**
  String get casinoAllIn;

  /// No description provided for @casinoPlaceBet.
  ///
  /// In en, this message translates to:
  /// **'Casino — Place Bet'**
  String get casinoPlaceBet;

  /// No description provided for @claimFreeRewards.
  ///
  /// In en, this message translates to:
  /// **'Claim free rewards'**
  String get claimFreeRewards;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @coachTrust.
  ///
  /// In en, this message translates to:
  /// **'Coach Trust'**
  String get coachTrust;

  /// No description provided for @contractDetails.
  ///
  /// In en, this message translates to:
  /// **'Contract Details'**
  String get contractDetails;

  /// No description provided for @profileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Contract, wages & agent'**
  String get profileSubtitle;

  /// No description provided for @contractWagesAgent.
  ///
  /// In en, this message translates to:
  /// **'Contract, wages & agent'**
  String get contractWagesAgent;

  /// No description provided for @nationalStandingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Country rankings'**
  String get nationalStandingsSubtitle;

  /// No description provided for @countryRankings.
  ///
  /// In en, this message translates to:
  /// **'Country rankings'**
  String get countryRankings;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// No description provided for @endWeekApplyEconomy.
  ///
  /// In en, this message translates to:
  /// **'End Week (Apply Economy)'**
  String get endWeekApplyEconomy;

  /// No description provided for @enterAnyAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter any amount (up to your cash)'**
  String get enterAnyAmount;

  /// No description provided for @firstTouch.
  ///
  /// In en, this message translates to:
  /// **'First Touch'**
  String get firstTouch;

  /// No description provided for @footyStar.
  ///
  /// In en, this message translates to:
  /// **'Footy Star'**
  String get footyStar;

  /// No description provided for @goToMatches.
  ///
  /// In en, this message translates to:
  /// **'Go to Matches'**
  String get goToMatches;

  /// No description provided for @hourlyRewards.
  ///
  /// In en, this message translates to:
  /// **'Hourly Rewards'**
  String get hourlyRewards;

  /// No description provided for @lifestyleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Housing, cars, luxury items'**
  String get lifestyleSubtitle;

  /// No description provided for @housingCarsLuxuryItems.
  ///
  /// In en, this message translates to:
  /// **'Housing, cars, luxury items'**
  String get housingCarsLuxuryItems;

  /// No description provided for @inboundTransfers.
  ///
  /// In en, this message translates to:
  /// **'Inbound Transfers'**
  String get inboundTransfers;

  /// No description provided for @weekSummary.
  ///
  /// In en, this message translates to:
  /// **'Income: \${earned} • Costs: \${spent} • Delta: {delta} • Cash: \${cash}'**
  String weekSummary(int earned, int spent, int delta, int cash);

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

  /// No description provided for @longPassing.
  ///
  /// In en, this message translates to:
  /// **'Long Passing'**
  String get longPassing;

  /// No description provided for @longShots.
  ///
  /// In en, this message translates to:
  /// **'Long Shots'**
  String get longShots;

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

  /// No description provided for @myTraining.
  ///
  /// In en, this message translates to:
  /// **'My Training'**
  String get myTraining;

  /// No description provided for @nationalRankingsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'National rankings will be shown here'**
  String get nationalRankingsPlaceholder;

  /// No description provided for @nationalStandings.
  ///
  /// In en, this message translates to:
  /// **'National Standings'**
  String get nationalStandings;

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

  /// No description provided for @previewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick preview of common labels'**
  String get previewSubtitle;

  /// No description provided for @realMoneyPurchases.
  ///
  /// In en, this message translates to:
  /// **'Real Money Purchases'**
  String get realMoneyPurchases;

  /// No description provided for @recoverySession.
  ///
  /// In en, this message translates to:
  /// **'Recovery Session'**
  String get recoverySession;

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

  /// No description provided for @restAllSquad.
  ///
  /// In en, this message translates to:
  /// **'Rest All Squad'**
  String get restAllSquad;

  /// No description provided for @resultPending.
  ///
  /// In en, this message translates to:
  /// **'Result pending'**
  String get resultPending;

  /// No description provided for @resultScore.
  ///
  /// In en, this message translates to:
  /// **'Result: {hg} - {ag}'**
  String resultScore(int hg, int ag);

  /// No description provided for @newSeason.
  ///
  /// In en, this message translates to:
  /// **'Season {season} has started'**
  String newSeason(int season);

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @shortPassing.
  ///
  /// In en, this message translates to:
  /// **'Short Passing'**
  String get shortPassing;

  /// No description provided for @shortShots.
  ///
  /// In en, this message translates to:
  /// **'Short Shots'**
  String get shortShots;

  /// No description provided for @sprintSpeed.
  ///
  /// In en, this message translates to:
  /// **'Sprint Speed'**
  String get sprintSpeed;

  /// No description provided for @squadRested.
  ///
  /// In en, this message translates to:
  /// **'Squad rested and recovered fatigue'**
  String get squadRested;

  /// No description provided for @statusPercent.
  ///
  /// In en, this message translates to:
  /// **'Status: {status} ({value}%)'**
  String statusPercent(Object status, int value);

  /// No description provided for @teamOverview.
  ///
  /// In en, this message translates to:
  /// **'Team overview'**
  String get teamOverview;

  /// No description provided for @thisWeeksMatch.
  ///
  /// In en, this message translates to:
  /// **'This week’s match'**
  String get thisWeeksMatch;

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

  /// No description provided for @playersStandingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Top scorers & assists'**
  String get playersStandingsSubtitle;

  /// No description provided for @topScorersAssists.
  ///
  /// In en, this message translates to:
  /// **'Top scorers & assists'**
  String get topScorersAssists;

  /// No description provided for @inboundTransfersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer offers & negotiations'**
  String get inboundTransfersSubtitle;

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

  /// No description provided for @wagerAmount.
  ///
  /// In en, this message translates to:
  /// **'Wager amount'**
  String get wagerAmount;

  /// No description provided for @weekEnded.
  ///
  /// In en, this message translates to:
  /// **'Week {week} ended'**
  String weekEnded(int week);

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

  /// No description provided for @skillTrained.
  ///
  /// In en, this message translates to:
  /// **'{player} improved {skill} to {level}'**
  String skillTrained(Object player, Object skill, int level);

  /// No description provided for @xpProgress.
  ///
  /// In en, this message translates to:
  /// **'{xp} / {xpMax} XP'**
  String xpProgress(int xp, int xpMax);
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
