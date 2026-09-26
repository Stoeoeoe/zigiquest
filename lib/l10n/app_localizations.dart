import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

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
    Locale('de'),
    Locale('fr'),
    Locale('it'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'ZigiQuest'**
  String get appTitle;

  /// No description provided for @navToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navQuests.
  ///
  /// In en, this message translates to:
  /// **'Quests'**
  String get navQuests;

  /// No description provided for @navKnowledge.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get navKnowledge;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get navSettings;

  /// No description provided for @todayCleanupStart.
  ///
  /// In en, this message translates to:
  /// **'START CLEANUP ROUND'**
  String get todayCleanupStart;

  /// No description provided for @todayCleanupContinue.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE CLEANUP'**
  String get todayCleanupContinue;

  /// No description provided for @todayQuickLog.
  ///
  /// In en, this message translates to:
  /// **'QUICK LOG'**
  String get todayQuickLog;

  /// No description provided for @todayQuickLogDescription.
  ///
  /// In en, this message translates to:
  /// **'Tap the jar for individual finds.'**
  String get todayQuickLogDescription;

  /// No description provided for @todayCleanupDescription.
  ///
  /// In en, this message translates to:
  /// **'For intentional rounds with time, location and photo.'**
  String get todayCleanupDescription;

  /// No description provided for @todayCountSemantics.
  ///
  /// In en, this message translates to:
  /// **'{count} butts collected today'**
  String todayCountSemantics(int count);

  /// No description provided for @todayPileLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} / {limit} IN THE CURRENT JAR'**
  String todayPileLabel(int count, int limit);

  /// No description provided for @todayGlassFilled.
  ///
  /// In en, this message translates to:
  /// **'Jar full! An empty jar is ready.'**
  String get todayGlassFilled;

  /// No description provided for @todayCountLabel.
  ///
  /// In en, this message translates to:
  /// **'CIGARETTE BUTTS TODAY'**
  String get todayCountLabel;

  /// No description provided for @todayEditCount.
  ///
  /// In en, this message translates to:
  /// **'Edit count'**
  String get todayEditCount;

  /// No description provided for @todayEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit today’s count'**
  String get todayEditTitle;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get amountLabel;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your history'**
  String get historyTitle;

  /// No description provided for @historyTotal.
  ///
  /// In en, this message translates to:
  /// **'Cigarette butts collected in total'**
  String get historyTotal;

  /// No description provided for @historyDiary.
  ///
  /// In en, this message translates to:
  /// **'DIARY'**
  String get historyDiary;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your collected cigarette butts will appear here.'**
  String get historyEmpty;

  /// No description provided for @historyRounds.
  ///
  /// In en, this message translates to:
  /// **'CLEANUP ROUNDS'**
  String get historyRounds;

  /// No description provided for @historyRoundsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Completed cleanup rounds will appear here with their details.'**
  String get historyRoundsEmpty;

  /// No description provided for @historyCount.
  ///
  /// In en, this message translates to:
  /// **'{count} cigarette butts'**
  String historyCount(Object count);

  /// No description provided for @historyCountOne.
  ///
  /// In en, this message translates to:
  /// **'1 cigarette butt'**
  String get historyCountOne;

  /// No description provided for @historyEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust daily value'**
  String get historyEditTitle;

  /// No description provided for @historyEditTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get historyEditTooltip;

  /// No description provided for @historyPhotos.
  ///
  /// In en, this message translates to:
  /// **'PHOTOS'**
  String get historyPhotos;

  /// No description provided for @sessionStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Start cleanup round'**
  String get sessionStartTitle;

  /// No description provided for @sessionNoLocation.
  ///
  /// In en, this message translates to:
  /// **'Start round without location'**
  String get sessionNoLocation;

  /// No description provided for @sessionLocationPoint.
  ///
  /// In en, this message translates to:
  /// **'Save location point'**
  String get sessionLocationPoint;

  /// No description provided for @sessionRoute.
  ///
  /// In en, this message translates to:
  /// **'Record route'**
  String get sessionRoute;

  /// No description provided for @sessionComplete.
  ///
  /// In en, this message translates to:
  /// **'FINISH SESSION'**
  String get sessionComplete;

  /// No description provided for @sessionFinishTitle.
  ///
  /// In en, this message translates to:
  /// **'Cleanup complete!'**
  String get sessionFinishTitle;

  /// No description provided for @sessionCollected.
  ///
  /// In en, this message translates to:
  /// **'CIGARETTE BUTTS COLLECTED'**
  String get sessionCollected;

  /// No description provided for @sessionSave.
  ///
  /// In en, this message translates to:
  /// **'Save cleanup'**
  String get sessionSave;

  /// No description provided for @sessionPhotoAdd.
  ///
  /// In en, this message translates to:
  /// **'Add optional completion photo'**
  String get sessionPhotoAdd;

  /// No description provided for @sessionPhotoChange.
  ///
  /// In en, this message translates to:
  /// **'Change completion photo'**
  String get sessionPhotoChange;

  /// No description provided for @sessionPhotoNone.
  ///
  /// In en, this message translates to:
  /// **'No photo selected'**
  String get sessionPhotoNone;

  /// No description provided for @sessionPhotoReady.
  ///
  /// In en, this message translates to:
  /// **'1 completion photo ready to save'**
  String get sessionPhotoReady;

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsTitle;

  /// No description provided for @achievementsCount.
  ///
  /// In en, this message translates to:
  /// **'{earned} of {total} achieved'**
  String achievementsCount(int earned, int total);

  /// No description provided for @achievementsDescription.
  ///
  /// In en, this message translates to:
  /// **'Your achievements are calculated locally on this device.'**
  String get achievementsDescription;

  /// No description provided for @achievementsCollection.
  ///
  /// In en, this message translates to:
  /// **'YOUR COLLECTION'**
  String get achievementsCollection;

  /// No description provided for @communityTitle.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get communityTitle;

  /// No description provided for @communityRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get communityRefresh;

  /// No description provided for @communityOptInTitle.
  ///
  /// In en, this message translates to:
  /// **'Appear in ranking?'**
  String get communityOptInTitle;

  /// No description provided for @communityOptInDescription.
  ///
  /// In en, this message translates to:
  /// **'Your nickname, avatar, and weekly count will be visible to other signed-in users. Email, photos, and locations remain private.'**
  String get communityOptInDescription;

  /// No description provided for @communityOptInNegative.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get communityOptInNegative;

  /// No description provided for @communityOptInPositive.
  ///
  /// In en, this message translates to:
  /// **'Participate'**
  String get communityOptInPositive;

  /// No description provided for @communitySaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save community setting.'**
  String get communitySaveError;

  /// No description provided for @communityHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Together counts for more.'**
  String get communityHeroTitle;

  /// No description provided for @communityHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in to participate in the shared goal or see the weekly ranking.'**
  String get communityHeroBody;

  /// No description provided for @communityOptInLabel.
  ///
  /// In en, this message translates to:
  /// **'Appear in weekly ranking'**
  String get communityOptInLabel;

  /// No description provided for @communityOptInSublabel.
  ///
  /// In en, this message translates to:
  /// **'Optional: only nickname, avatar and weekly count are shown.'**
  String get communityOptInSublabel;

  /// No description provided for @communityWeeklyLabel.
  ///
  /// In en, this message translates to:
  /// **'THIS WEEK'**
  String get communityWeeklyLabel;

  /// No description provided for @communityPrivateMessage.
  ///
  /// In en, this message translates to:
  /// **'The ranking remains private until you voluntarily participate.'**
  String get communityPrivateMessage;

  /// No description provided for @communityEmptyLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'No visible weekly values yet. You can make the start.'**
  String get communityEmptyLeaderboard;

  /// No description provided for @communitySyncNote.
  ///
  /// In en, this message translates to:
  /// **'Local, unsynced entries always remain private and only count after successful synchronization.'**
  String get communitySyncNote;

  /// No description provided for @communityGoalEmpty.
  ///
  /// In en, this message translates to:
  /// **'The shared cleanup goal is currently being set up. Check back soon.'**
  String get communityGoalEmpty;

  /// No description provided for @communityGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'SHARED GOAL'**
  String get communityGoalLabel;

  /// No description provided for @authErrorConfig.
  ///
  /// In en, this message translates to:
  /// **'Sign in is not yet configured for this build.'**
  String get authErrorConfig;

  /// No description provided for @authErrorGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google sign in could not be started.'**
  String get authErrorGoogle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to ZigiQuest'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Collect butts, record your effort, and make your impact visible.'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeAccountInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'What is an account for?'**
  String get welcomeAccountInfoTitle;

  /// No description provided for @welcomeAccountInfoBody.
  ///
  /// In en, this message translates to:
  /// **'For private backup and synchronization between devices. Session photos can also be backed up privately. Counting, cleanup rounds, and history also work without an account.'**
  String get welcomeAccountInfoBody;

  /// No description provided for @welcomeGoogleSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google (optional)'**
  String get welcomeGoogleSignIn;

  /// No description provided for @welcomeContinueGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue without account'**
  String get welcomeContinueGuest;

  /// No description provided for @welcomeFooter.
  ///
  /// In en, this message translates to:
  /// **'After this, you will set up the app. Guest mode remains completely offline; you only need an account for private backup and synchronization.'**
  String get welcomeFooter;

  /// No description provided for @howItWorksTitle.
  ///
  /// In en, this message translates to:
  /// **'How ZigiQuest works'**
  String get howItWorksTitle;

  /// No description provided for @howItWorksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Collect at your own pace – individual finds immediately or as a conscious cleanup round.'**
  String get howItWorksSubtitle;

  /// No description provided for @howItWorksQuickLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick log'**
  String get howItWorksQuickLogTitle;

  /// No description provided for @howItWorksQuickLogBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the jar when you find individual butts.'**
  String get howItWorksQuickLogBody;

  /// No description provided for @howItWorksSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Start cleanup round'**
  String get howItWorksSessionTitle;

  /// No description provided for @howItWorksSessionBody.
  ///
  /// In en, this message translates to:
  /// **'Record time, optional location, and a photo for a conscious round.'**
  String get howItWorksSessionBody;

  /// No description provided for @howItWorksHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'See impact'**
  String get howItWorksHistoryTitle;

  /// No description provided for @howItWorksHistoryBody.
  ///
  /// In en, this message translates to:
  /// **'Your history shows you days and completed cleanup rounds.'**
  String get howItWorksHistoryBody;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick setup'**
  String get setupTitle;

  /// No description provided for @setupHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Your app, your rules.'**
  String get setupHeroTitle;

  /// No description provided for @setupHeroBody.
  ///
  /// In en, this message translates to:
  /// **'You can change everything later in the settings. Location always remains off until you actively choose it for a session.'**
  String get setupHeroBody;

  /// No description provided for @setupCategoryAppearance.
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE'**
  String get setupCategoryAppearance;

  /// No description provided for @setupThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System settings'**
  String get setupThemeSystem;

  /// No description provided for @setupThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get setupThemeLight;

  /// No description provided for @setupThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get setupThemeDark;

  /// No description provided for @setupReducedMotionTitle.
  ///
  /// In en, this message translates to:
  /// **'Reduced motion'**
  String get setupReducedMotionTitle;

  /// No description provided for @setupReducedMotionBody.
  ///
  /// In en, this message translates to:
  /// **'Fewer animations in the vessel.'**
  String get setupReducedMotionBody;

  /// No description provided for @setupCategoryFeedback.
  ///
  /// In en, this message translates to:
  /// **'FEEDBACK'**
  String get setupCategoryFeedback;

  /// No description provided for @setupHapticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Haptics'**
  String get setupHapticsTitle;

  /// No description provided for @setupHapticsBody.
  ///
  /// In en, this message translates to:
  /// **'Light feedback when counting.'**
  String get setupHapticsBody;

  /// No description provided for @setupCategoryPrivacy.
  ///
  /// In en, this message translates to:
  /// **'PRIVACY'**
  String get setupCategoryPrivacy;

  /// No description provided for @setupCloudBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Private cloud backup for photos'**
  String get setupCloudBackupTitle;

  /// No description provided for @setupCloudBackupBody.
  ///
  /// In en, this message translates to:
  /// **'Optional: uploaded session photos remain private.'**
  String get setupCloudBackupBody;

  /// No description provided for @setupCloudBackupGuestBody.
  ///
  /// In en, this message translates to:
  /// **'Available with an account. As a guest, photos remain only on this device.'**
  String get setupCloudBackupGuestBody;

  /// No description provided for @setupFinish.
  ///
  /// In en, this message translates to:
  /// **'Save and start'**
  String get setupFinish;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsCategoryAppearance.
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE'**
  String get settingsCategoryAppearance;

  /// No description provided for @settingsThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsThemeMode;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @settingsLanguageDe.
  ///
  /// In en, this message translates to:
  /// **'Deutsch (German)'**
  String get settingsLanguageDe;

  /// No description provided for @settingsLanguageFr.
  ///
  /// In en, this message translates to:
  /// **'Français (French)'**
  String get settingsLanguageFr;

  /// No description provided for @settingsLanguageIt.
  ///
  /// In en, this message translates to:
  /// **'Italiano (Italian)'**
  String get settingsLanguageIt;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsContainerStyle.
  ///
  /// In en, this message translates to:
  /// **'Environment in the jar'**
  String get settingsContainerStyle;

  /// No description provided for @settingsContainerStyleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a cleanup location as background'**
  String get settingsContainerStyleSubtitle;

  /// No description provided for @settingsVisualEffects.
  ///
  /// In en, this message translates to:
  /// **'Visual effects'**
  String get settingsVisualEffects;

  /// No description provided for @settingsVisualEffectsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scene atmosphere, glass glitter and butt particles'**
  String get settingsVisualEffectsSubtitle;

  /// No description provided for @settingsReducedMotion.
  ///
  /// In en, this message translates to:
  /// **'Reduced motion'**
  String get settingsReducedMotion;

  /// No description provided for @settingsCategoryFeedback.
  ///
  /// In en, this message translates to:
  /// **'FEEDBACK'**
  String get settingsCategoryFeedback;

  /// No description provided for @settingsHaptics.
  ///
  /// In en, this message translates to:
  /// **'Haptics'**
  String get settingsHaptics;

  /// No description provided for @settingsCategoryNotifications.
  ///
  /// In en, this message translates to:
  /// **'NOTIFICATIONS'**
  String get settingsCategoryNotifications;

  /// No description provided for @settingsSessionLimit.
  ///
  /// In en, this message translates to:
  /// **'Session limit'**
  String get settingsSessionLimit;

  /// No description provided for @settingsSessionLimitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open sessions will be safely finished after this'**
  String get settingsSessionLimitSubtitle;

  /// No description provided for @settingsMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min.'**
  String settingsMinutes(int count);

  /// No description provided for @settingsHour.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get settingsHour;

  /// No description provided for @settingsHours.
  ///
  /// In en, this message translates to:
  /// **'{count} hours'**
  String settingsHours(int count);

  /// No description provided for @settingsReminders.
  ///
  /// In en, this message translates to:
  /// **'Gentle cleanup reminders'**
  String get settingsReminders;

  /// No description provided for @settingsRemindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional: weekly, monthly after longer break'**
  String get settingsRemindersSubtitle;

  /// No description provided for @settingsNotificationsDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications were not allowed.'**
  String get settingsNotificationsDenied;

  /// No description provided for @settingsCategoryData.
  ///
  /// In en, this message translates to:
  /// **'DATA'**
  String get settingsCategoryData;

  /// No description provided for @settingsSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Data synchronization'**
  String get settingsSyncTitle;

  /// No description provided for @settingsSyncSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in to back up your data.'**
  String get settingsSyncSignIn;

  /// No description provided for @settingsSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing ...'**
  String get settingsSyncing;

  /// No description provided for @settingsSyncNever.
  ///
  /// In en, this message translates to:
  /// **'Not synced yet'**
  String get settingsSyncNever;

  /// No description provided for @settingsSyncLast.
  ///
  /// In en, this message translates to:
  /// **'Last synced: {timestamp}'**
  String settingsSyncLast(String timestamp);

  /// No description provided for @settingsCloudPhotos.
  ///
  /// In en, this message translates to:
  /// **'Private cloud photos'**
  String get settingsCloudPhotos;

  /// No description provided for @settingsCloudPhotosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your backed up session photos'**
  String get settingsCloudPhotosSubtitle;

  /// No description provided for @todayTitle.
  ///
  /// In en, this message translates to:
  /// **'ZigiQuest'**
  String get todayTitle;

  /// No description provided for @todayProfileTooltip.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get todayProfileTooltip;

  /// No description provided for @todayJarsFilled.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{jar} other{jars}} filled'**
  String todayJarsFilled(int count);

  /// No description provided for @historySessionMetricZigis.
  ///
  /// In en, this message translates to:
  /// **'Butts collected'**
  String get historySessionMetricZigis;

  /// No description provided for @historySessionMetricDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get historySessionMetricDuration;

  /// No description provided for @historySessionMetricPath.
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get historySessionMetricPath;

  /// No description provided for @historyTrackingPointTitle.
  ///
  /// In en, this message translates to:
  /// **'Location point saved'**
  String get historyTrackingPointTitle;

  /// No description provided for @historyTrackingPointBody.
  ///
  /// In en, this message translates to:
  /// **'The location remains private and belongs only to this cleanup round.'**
  String get historyTrackingPointBody;

  /// No description provided for @historyTrackingRouteTitle.
  ///
  /// In en, this message translates to:
  /// **'Route saved'**
  String get historyTrackingRouteTitle;

  /// No description provided for @historyTrackingRouteBody.
  ///
  /// In en, this message translates to:
  /// **'The route remains private and belongs only to this cleanup round.'**
  String get historyTrackingRouteBody;

  /// No description provided for @historyTrackingNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved without location'**
  String get historyTrackingNoneTitle;

  /// No description provided for @historyTrackingNoneBody.
  ///
  /// In en, this message translates to:
  /// **'No location data was saved for this cleanup round.'**
  String get historyTrackingNoneBody;

  /// No description provided for @historyPhotosEmpty.
  ///
  /// In en, this message translates to:
  /// **'No photo was saved for this round.'**
  String get historyPhotosEmpty;

  /// No description provided for @historyPhotoBefore.
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get historyPhotoBefore;

  /// No description provided for @historyPhotoAfter.
  ///
  /// In en, this message translates to:
  /// **'Completion photo'**
  String get historyPhotoAfter;

  /// No description provided for @historyRecentEmpty.
  ///
  /// In en, this message translates to:
  /// **'No entries yet.'**
  String get historyRecentEmpty;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get profileGuest;

  /// No description provided for @profileMember.
  ///
  /// In en, this message translates to:
  /// **'ZigiQuest Member'**
  String get profileMember;

  /// No description provided for @profileLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get profileLoggedIn;

  /// No description provided for @profileEmailDefault.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get profileEmailDefault;

  /// No description provided for @profileEditNameTooltip.
  ///
  /// In en, this message translates to:
  /// **'Change name'**
  String get profileEditNameTooltip;

  /// No description provided for @profileMetricZigis.
  ///
  /// In en, this message translates to:
  /// **'Butts'**
  String get profileMetricZigis;

  /// No description provided for @profileMetricStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get profileMetricStreak;

  /// No description provided for @profileMetricBadges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get profileMetricBadges;

  /// No description provided for @profileAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get profileAchievements;

  /// No description provided for @profileAchievementsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your milestones'**
  String get profileAchievementsSubtitle;

  /// No description provided for @profileCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get profileCommunity;

  /// No description provided for @profileCommunitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Make impact visible together'**
  String get profileCommunitySubtitle;

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileSignOut;

  /// No description provided for @profileEditNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get profileEditNameTitle;

  /// No description provided for @profileSaveError.
  ///
  /// In en, this message translates to:
  /// **'Name could not be saved.'**
  String get profileSaveError;

  /// No description provided for @profileLocalOnly.
  ///
  /// In en, this message translates to:
  /// **'Local on this device'**
  String get profileLocalOnly;

  /// No description provided for @sessionTrackingStatusNone.
  ///
  /// In en, this message translates to:
  /// **'Without tracking'**
  String get sessionTrackingStatusNone;

  /// No description provided for @sessionTrackingStatusPoint.
  ///
  /// In en, this message translates to:
  /// **'Location point'**
  String get sessionTrackingStatusPoint;

  /// No description provided for @sessionTrackingStatusRoute.
  ///
  /// In en, this message translates to:
  /// **'Route is being recorded'**
  String get sessionTrackingStatusRoute;

  /// No description provided for @sessionActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'CLEANUP RUNNING'**
  String get sessionActiveTitle;

  /// No description provided for @sessionActiveAddSemantic.
  ///
  /// In en, this message translates to:
  /// **'Tap vessel to add a butt'**
  String get sessionActiveAddSemantic;

  /// No description provided for @sessionJarFull.
  ///
  /// In en, this message translates to:
  /// **'Jar full! A new empty jar is ready.'**
  String get sessionJarFull;

  /// No description provided for @sessionFinishingMetricZigis.
  ///
  /// In en, this message translates to:
  /// **'Butts collected'**
  String get sessionFinishingMetricZigis;

  /// No description provided for @sessionFinishingMetricDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get sessionFinishingMetricDuration;

  /// No description provided for @sessionFinishingMetricPath.
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get sessionFinishingMetricPath;

  /// No description provided for @sessionFinishingPhotoChange.
  ///
  /// In en, this message translates to:
  /// **'Change completion photo'**
  String get sessionFinishingPhotoChange;

  /// No description provided for @sessionFinishingPhotoAdd.
  ///
  /// In en, this message translates to:
  /// **'Add optional completion photo'**
  String get sessionFinishingPhotoAdd;

  /// No description provided for @sessionFinishingPhotoReady.
  ///
  /// In en, this message translates to:
  /// **'1 completion photo ready to save'**
  String get sessionFinishingPhotoReady;

  /// No description provided for @sessionFinishingPhotoNone.
  ///
  /// In en, this message translates to:
  /// **'No photo selected'**
  String get sessionFinishingPhotoNone;

  /// No description provided for @sessionFinishingPreviewError.
  ///
  /// In en, this message translates to:
  /// **'Preview not available.'**
  String get sessionFinishingPreviewError;

  /// No description provided for @sessionSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Cleanup complete!'**
  String get sessionSavedTitle;

  /// No description provided for @sessionSavedSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} butts in {duration}'**
  String sessionSavedSummary(int count, String duration);

  /// No description provided for @sessionSavedXp.
  ///
  /// In en, this message translates to:
  /// **'+{count} XP'**
  String sessionSavedXp(int count);

  /// No description provided for @sessionSavedXpNone.
  ///
  /// In en, this message translates to:
  /// **'No XP'**
  String get sessionSavedXpNone;

  /// No description provided for @sessionSavedInventoryAdd.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{butt was} other{butts were}} added to your today-jar.'**
  String sessionSavedInventoryAdd(int count);

  /// No description provided for @sessionSavedInventoryNone.
  ///
  /// In en, this message translates to:
  /// **'Today nothing was added to the jar.'**
  String get sessionSavedInventoryNone;

  /// No description provided for @sessionSavedGoHome.
  ///
  /// In en, this message translates to:
  /// **'To home screen'**
  String get sessionSavedGoHome;

  /// No description provided for @sessionRatingRequest.
  ///
  /// In en, this message translates to:
  /// **'A small request – only if ZigiQuest has earned it.'**
  String get sessionRatingRequest;

  /// No description provided for @sessionRatingPositive.
  ///
  /// In en, this message translates to:
  /// **'Rate ZigiQuest'**
  String get sessionRatingPositive;

  /// No description provided for @sessionRatingNegative.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get sessionRatingNegative;

  /// No description provided for @sessionRatingNever.
  ///
  /// In en, this message translates to:
  /// **'Don\'t ask again'**
  String get sessionRatingNever;

  /// No description provided for @sessionRatingWaiting.
  ///
  /// In en, this message translates to:
  /// **'One moment ...'**
  String get sessionRatingWaiting;

  /// No description provided for @sessionRatingError.
  ///
  /// In en, this message translates to:
  /// **'The review request is not yet available on this device.'**
  String get sessionRatingError;

  /// No description provided for @sessionLocationStatusError.
  ///
  /// In en, this message translates to:
  /// **'Location is not available. The session starts without tracking.'**
  String get sessionLocationStatusError;

  /// No description provided for @sessionStartHint.
  ///
  /// In en, this message translates to:
  /// **'Choose whether this round may save a location or a route.'**
  String get sessionStartHint;

  /// No description provided for @sessionActiveHintLabel.
  ///
  /// In en, this message translates to:
  /// **'CLEANUP RUNNING'**
  String get sessionActiveHintLabel;

  /// No description provided for @sessionActiveJarLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} / {limit} IN THE CURRENT JAR'**
  String sessionActiveJarLabel(Object count, Object limit);

  /// No description provided for @sessionPhotoSourceCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get sessionPhotoSourceCamera;

  /// No description provided for @sessionPhotoSourceGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get sessionPhotoSourceGallery;

  /// No description provided for @sessionFinalCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Final count'**
  String get sessionFinalCountLabel;

  /// No description provided for @sessionCountDecreaseTooltip.
  ///
  /// In en, this message translates to:
  /// **'One zigi less'**
  String get sessionCountDecreaseTooltip;

  /// No description provided for @sessionCountIncreaseTooltip.
  ///
  /// In en, this message translates to:
  /// **'One zigi more'**
  String get sessionCountIncreaseTooltip;

  /// No description provided for @remotePhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'Private Cloud Photos'**
  String get remotePhotosTitle;

  /// No description provided for @remotePhotosDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete cloud photo?'**
  String get remotePhotosDeleteTitle;

  /// No description provided for @remotePhotosDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'The private cloud copy will be deleted. A local copy on this device will remain.'**
  String get remotePhotosDeleteBody;

  /// No description provided for @remotePhotosDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get remotePhotosDeleteConfirm;

  /// No description provided for @remotePhotosDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Cloud photo deleted.'**
  String get remotePhotosDeleteSuccess;

  /// No description provided for @remotePhotosDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Cloud photo could not be deleted.'**
  String get remotePhotosDeleteError;

  /// No description provided for @remotePhotosPreviewBefore.
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get remotePhotosPreviewBefore;

  /// No description provided for @remotePhotosPreviewAfter.
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get remotePhotosPreviewAfter;

  /// No description provided for @remotePhotosPreviewError.
  ///
  /// In en, this message translates to:
  /// **'Photo could not be loaded.'**
  String get remotePhotosPreviewError;

  /// No description provided for @remotePhotosLoadError.
  ///
  /// In en, this message translates to:
  /// **'Cloud photos could not be loaded.'**
  String get remotePhotosLoadError;

  /// No description provided for @remotePhotosEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No private cloud photos yet'**
  String get remotePhotosEmptyTitle;

  /// No description provided for @remotePhotosEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in, enable cloud backup, and finish a session with photos.'**
  String get remotePhotosEmptyBody;

  /// No description provided for @remotePhotosItemLabel.
  ///
  /// In en, this message translates to:
  /// **'{type} · {date}'**
  String remotePhotosItemLabel(String type, String date);

  /// No description provided for @questsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quests'**
  String get questsTitle;

  /// No description provided for @questsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Small goals help turn a walk into visible impact.'**
  String get questsSubtitle;

  /// No description provided for @questsWeekly.
  ///
  /// In en, this message translates to:
  /// **'WEEKLY QUEST'**
  String get questsWeekly;

  /// No description provided for @questsDaily.
  ///
  /// In en, this message translates to:
  /// **'DAILY QUEST'**
  String get questsDaily;

  /// No description provided for @questsReward.
  ///
  /// In en, this message translates to:
  /// **'{progress}/{target}\n+{reward} XP'**
  String questsReward(int progress, int target, int reward);

  /// No description provided for @discoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Tips & Knowledge'**
  String get discoverTitle;

  /// No description provided for @discoverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Local knowledge and practical ideas. Tap a card to see source and details.'**
  String get discoverSubtitle;

  /// No description provided for @discoverSourceShow.
  ///
  /// In en, this message translates to:
  /// **'Show source'**
  String get discoverSourceShow;

  /// No description provided for @discoverSourceLabel.
  ///
  /// In en, this message translates to:
  /// **'SOURCE'**
  String get discoverSourceLabel;

  /// No description provided for @discoverCopyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get discoverCopyLink;

  /// No description provided for @discoverOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get discoverOpenLink;

  /// No description provided for @discoverLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied.'**
  String get discoverLinkCopied;

  /// No description provided for @discoverLinkError.
  ///
  /// In en, this message translates to:
  /// **'Link could not be opened.'**
  String get discoverLinkError;

  /// No description provided for @discoverDismissTooltip.
  ///
  /// In en, this message translates to:
  /// **'Hide today'**
  String get discoverDismissTooltip;

  /// No description provided for @discoverKindFact.
  ///
  /// In en, this message translates to:
  /// **'FACT'**
  String get discoverKindFact;

  /// No description provided for @discoverKindTip.
  ///
  /// In en, this message translates to:
  /// **'TIP'**
  String get discoverKindTip;

  /// No description provided for @discoverKindQuest.
  ///
  /// In en, this message translates to:
  /// **'MINI-MISSION'**
  String get discoverKindQuest;

  /// No description provided for @achievement_first_find_title.
  ///
  /// In en, this message translates to:
  /// **'First Find'**
  String get achievement_first_find_title;

  /// No description provided for @achievement_first_find_description.
  ///
  /// In en, this message translates to:
  /// **'Collect your first cigarette butt.'**
  String get achievement_first_find_description;

  /// No description provided for @achievement_ten_cleaner_title.
  ///
  /// In en, this message translates to:
  /// **'Clean Ten'**
  String get achievement_ten_cleaner_title;

  /// No description provided for @achievement_ten_cleaner_description.
  ///
  /// In en, this message translates to:
  /// **'Collect 10 cigarette butts in total.'**
  String get achievement_ten_cleaner_description;

  /// No description provided for @achievement_hundred_club_title.
  ///
  /// In en, this message translates to:
  /// **'Hundred Club'**
  String get achievement_hundred_club_title;

  /// No description provided for @achievement_hundred_club_description.
  ///
  /// In en, this message translates to:
  /// **'Collect 100 cigarette butts in total.'**
  String get achievement_hundred_club_description;

  /// No description provided for @achievement_thousand_impact_title.
  ///
  /// In en, this message translates to:
  /// **'Thousand Impact'**
  String get achievement_thousand_impact_title;

  /// No description provided for @achievement_thousand_impact_description.
  ///
  /// In en, this message translates to:
  /// **'Collect 1,000 cigarette butts in total.'**
  String get achievement_thousand_impact_description;

  /// No description provided for @achievement_streak_three_title.
  ///
  /// In en, this message translates to:
  /// **'Keep at it'**
  String get achievement_streak_three_title;

  /// No description provided for @achievement_streak_three_description.
  ///
  /// In en, this message translates to:
  /// **'Collect on three consecutive days.'**
  String get achievement_streak_three_description;

  /// No description provided for @achievement_streak_seven_title.
  ///
  /// In en, this message translates to:
  /// **'Weekly Fire'**
  String get achievement_streak_seven_title;

  /// No description provided for @achievement_streak_seven_description.
  ///
  /// In en, this message translates to:
  /// **'Collect on seven consecutive days.'**
  String get achievement_streak_seven_description;

  /// No description provided for @achievement_first_session_title.
  ///
  /// In en, this message translates to:
  /// **'Went out'**
  String get achievement_first_session_title;

  /// No description provided for @achievement_first_session_description.
  ///
  /// In en, this message translates to:
  /// **'Complete your first cleanup session.'**
  String get achievement_first_session_description;

  /// No description provided for @achievement_ten_sessions_title.
  ///
  /// In en, this message translates to:
  /// **'Cleanup Routine'**
  String get achievement_ten_sessions_title;

  /// No description provided for @achievement_ten_sessions_description.
  ///
  /// In en, this message translates to:
  /// **'Complete ten cleanup sessions.'**
  String get achievement_ten_sessions_description;

  /// No description provided for @achievement_weekly_quest_title.
  ///
  /// In en, this message translates to:
  /// **'Weekly Goal'**
  String get achievement_weekly_quest_title;

  /// No description provided for @achievement_weekly_quest_description.
  ///
  /// In en, this message translates to:
  /// **'Collect 75 cigarette butts in one week.'**
  String get achievement_weekly_quest_description;

  /// No description provided for @discover_filter_plastic_title.
  ///
  /// In en, this message translates to:
  /// **'Filters are plastic'**
  String get discover_filter_plastic_title;

  /// No description provided for @discover_filter_plastic_body.
  ///
  /// In en, this message translates to:
  /// **'Cigarette filters usually consist of cellulose acetate. They therefore do not belong in the environment.'**
  String get discover_filter_plastic_body;

  /// No description provided for @discover_swiss_shores_title.
  ///
  /// In en, this message translates to:
  /// **'Frequently found on Swiss shores'**
  String get discover_swiss_shores_title;

  /// No description provided for @discover_swiss_shores_body.
  ///
  /// In en, this message translates to:
  /// **'In a BAFU survey on Swiss lakes and rivers, cigarette filters were the most frequently found item.'**
  String get discover_swiss_shores_body;

  /// No description provided for @discover_gully_not_bin_title.
  ///
  /// In en, this message translates to:
  /// **'A gully is not an ashtray'**
  String get discover_gully_not_bin_title;

  /// No description provided for @discover_gully_not_bin_body.
  ///
  /// In en, this message translates to:
  /// **'Waste belongs in the waste container. This prevents plastics from entering soil and water in an uncontrolled manner.'**
  String get discover_gully_not_bin_body;

  /// No description provided for @discover_cleanup_kit_title.
  ///
  /// In en, this message translates to:
  /// **'Small cleanup kit'**
  String get discover_cleanup_kit_title;

  /// No description provided for @discover_cleanup_kit_body.
  ///
  /// In en, this message translates to:
  /// **'A tight jar or a small tin in your backpack makes spontaneous collection rounds easier.'**
  String get discover_cleanup_kit_body;

  /// No description provided for @discover_safe_pickup_title.
  ///
  /// In en, this message translates to:
  /// **'Collect safely and cleanly'**
  String get discover_safe_pickup_title;

  /// No description provided for @discover_safe_pickup_body.
  ///
  /// In en, this message translates to:
  /// **'If you like, take gloves or a gripper and then dispose of the contents in the trash.'**
  String get discover_safe_pickup_body;

  /// No description provided for @discover_micro_cleanup_title.
  ///
  /// In en, this message translates to:
  /// **'Mini-mission: five minutes'**
  String get discover_micro_cleanup_title;

  /// No description provided for @discover_micro_cleanup_body.
  ///
  /// In en, this message translates to:
  /// **'A short cleanup at a bench, stop or on the lakeshore is a good start.'**
  String get discover_micro_cleanup_body;

  /// No description provided for @discover_hotspots_title.
  ///
  /// In en, this message translates to:
  /// **'Consciously look at hotspots'**
  String get discover_hotspots_title;

  /// No description provided for @discover_hotspots_body.
  ///
  /// In en, this message translates to:
  /// **'Places with a lot of outdoor stays often deserve a second look: benches, parking lots, entrance areas and stops.'**
  String get discover_hotspots_body;

  /// No description provided for @discover_together_title.
  ///
  /// In en, this message translates to:
  /// **'Don\'t collect alone'**
  String get discover_together_title;

  /// No description provided for @discover_together_body.
  ///
  /// In en, this message translates to:
  /// **'With friends or a local action, a cleanup easily becomes a habit.'**
  String get discover_together_body;

  /// No description provided for @notificationChannelName.
  ///
  /// In en, this message translates to:
  /// **'Gentle Reminders'**
  String get notificationChannelName;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Optional cleanup reminders and session notes.'**
  String get notificationChannelDescription;

  /// No description provided for @notificationReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Time for a small round?'**
  String get notificationReminderTitle;

  /// No description provided for @notificationReminderBodyInactive.
  ///
  /// In en, this message translates to:
  /// **'If you like: A short cleanup makes a visible difference.'**
  String get notificationReminderBodyInactive;

  /// No description provided for @notificationReminderBodyActive.
  ///
  /// In en, this message translates to:
  /// **'Feel like a short cleanup walk? No pressure.'**
  String get notificationReminderBodyActive;

  /// No description provided for @notificationExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Cleanup session ended'**
  String get notificationExpiredTitle;

  /// No description provided for @notificationExpiredBody.
  ///
  /// In en, this message translates to:
  /// **'Your open session was safely finished after the set time.'**
  String get notificationExpiredBody;

  /// No description provided for @vessel_city_label.
  ///
  /// In en, this message translates to:
  /// **'Swiss City'**
  String get vessel_city_label;

  /// No description provided for @vessel_river_label.
  ///
  /// In en, this message translates to:
  /// **'Riverside'**
  String get vessel_river_label;

  /// No description provided for @vessel_forest_label.
  ///
  /// In en, this message translates to:
  /// **'Forest Path'**
  String get vessel_forest_label;

  /// No description provided for @vessel_parking_label.
  ///
  /// In en, this message translates to:
  /// **'Parking Lot'**
  String get vessel_parking_label;

  /// No description provided for @vessel_add_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Add one butt'**
  String get vessel_add_tooltip;

  /// No description provided for @vessel_remove_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove one butt'**
  String get vessel_remove_tooltip;

  /// No description provided for @quest_daily_10_title.
  ///
  /// In en, this message translates to:
  /// **'Collect 10 butts today'**
  String get quest_daily_10_title;

  /// No description provided for @quest_daily_25_title.
  ///
  /// In en, this message translates to:
  /// **'Collect 25 butts today'**
  String get quest_daily_25_title;

  /// No description provided for @quest_session_1_title.
  ///
  /// In en, this message translates to:
  /// **'Complete a cleanup session'**
  String get quest_session_1_title;

  /// No description provided for @quest_weekly_75_title.
  ///
  /// In en, this message translates to:
  /// **'Weekly goal: 75 butts'**
  String get quest_weekly_75_title;

  /// No description provided for @quest_weekly_3_title.
  ///
  /// In en, this message translates to:
  /// **'Weekly goal: 3 sessions'**
  String get quest_weekly_3_title;

  /// No description provided for @sessionInactivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Still collecting?'**
  String get sessionInactivityTitle;

  /// No description provided for @sessionInactivityBody.
  ///
  /// In en, this message translates to:
  /// **'Your cleanup has been inactive for two hours. Would you like to finish it now?'**
  String get sessionInactivityBody;

  /// No description provided for @sessionInactivityContinue.
  ///
  /// In en, this message translates to:
  /// **'Keep collecting'**
  String get sessionInactivityContinue;

  /// No description provided for @sessionInactivityEnd.
  ///
  /// In en, this message translates to:
  /// **'End run'**
  String get sessionInactivityEnd;

  /// No description provided for @notificationSessionCheckTitle.
  ///
  /// In en, this message translates to:
  /// **'Still collecting?'**
  String get notificationSessionCheckTitle;

  /// No description provided for @notificationSessionCheckBody.
  ///
  /// In en, this message translates to:
  /// **'Your cleanup is still open. Tap to continue it.'**
  String get notificationSessionCheckBody;

  /// No description provided for @communityTabFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get communityTabFriends;

  /// No description provided for @communityTabActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get communityTabActions;

  /// No description provided for @communityTabImpact.
  ///
  /// In en, this message translates to:
  /// **'Impact'**
  String get communityTabImpact;

  /// No description provided for @communityFriendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your circle'**
  String get communityFriendsTitle;

  /// No description provided for @communityFriendsBody.
  ///
  /// In en, this message translates to:
  /// **'Private, friendly motivation. No public ranking.'**
  String get communityFriendsBody;

  /// No description provided for @communityInviteFriends.
  ///
  /// In en, this message translates to:
  /// **'Invite friends'**
  String get communityInviteFriends;

  /// No description provided for @communityTogetherWeek.
  ///
  /// In en, this message translates to:
  /// **'Together this week'**
  String get communityTogetherWeek;

  /// No description provided for @communityNoFriends.
  ///
  /// In en, this message translates to:
  /// **'No friends yet. Share your handle to keep each other motivated.'**
  String get communityNoFriends;

  /// No description provided for @communityActionNow.
  ///
  /// In en, this message translates to:
  /// **'Current action'**
  String get communityActionNow;

  /// No description provided for @communityActionWaterTitle.
  ///
  /// In en, this message translates to:
  /// **'Summer by the water'**
  String get communityActionWaterTitle;

  /// No description provided for @communityActionWaterBody.
  ///
  /// In en, this message translates to:
  /// **'A cleanup by a lake, river, or fountain can become your personal mini-mission.'**
  String get communityActionWaterBody;

  /// No description provided for @communityActionFiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Five-minute reset'**
  String get communityActionFiveTitle;

  /// No description provided for @communityActionFiveBody.
  ///
  /// In en, this message translates to:
  /// **'A small cleanup at a bench, stop, or parking lot is a strong start.'**
  String get communityActionFiveBody;

  /// No description provided for @communityImpactTitle.
  ///
  /// In en, this message translates to:
  /// **'Impact, not competition'**
  String get communityImpactTitle;

  /// No description provided for @communityImpactSolo.
  ///
  /// In en, this message translates to:
  /// **'Your cleanups make places visibly cleaner, one zigi at a time.'**
  String get communityImpactSolo;

  /// No description provided for @communityImpactCircle.
  ///
  /// In en, this message translates to:
  /// **'Your friend circle collected {count} zigis this week.'**
  String communityImpactCircle(int count);

  /// No description provided for @communityImpactPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Photos and routes stay private unless you consciously share a run.'**
  String get communityImpactPrivacy;

  /// No description provided for @communityGoalPreparing.
  ///
  /// In en, this message translates to:
  /// **'A shared action is being prepared.'**
  String get communityGoalPreparing;

  /// No description provided for @communityGoalLabelNew.
  ///
  /// In en, this message translates to:
  /// **'SHARED ACTION'**
  String get communityGoalLabelNew;

  /// No description provided for @friendsHandleTitle.
  ///
  /// In en, this message translates to:
  /// **'Your friend handle'**
  String get friendsHandleTitle;

  /// No description provided for @friendsHandlePrivacy.
  ///
  /// In en, this message translates to:
  /// **'You are not publicly listed. Share it only with people you want to add.'**
  String get friendsHandlePrivacy;

  /// No description provided for @friendsAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a friend'**
  String get friendsAddTitle;

  /// No description provided for @friendsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Enter handle'**
  String get friendsSearchHint;

  /// No description provided for @friendsSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get friendsSearch;

  /// No description provided for @friendsAdded.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get friendsAdded;

  /// No description provided for @friendsShare.
  ///
  /// In en, this message translates to:
  /// **'Invite a friend'**
  String get friendsShare;

  /// No description provided for @friendsSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in to add friends.'**
  String get friendsSignIn;
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
      <String>['de', 'en', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
