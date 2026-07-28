// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ZigiQuest';

  @override
  String get navToday => 'Today';

  @override
  String get navHistory => 'History';

  @override
  String get navQuests => 'Quests';

  @override
  String get navKnowledge => 'Learn';

  @override
  String get navSettings => 'Options';

  @override
  String get todayCleanupStart => 'START CLEANUP ROUND';

  @override
  String get todayCleanupContinue => 'CONTINUE CLEANUP';

  @override
  String get todayQuickLog => 'QUICK LOG';

  @override
  String get todayQuickLogDescription => 'Tap the jar for individual finds.';

  @override
  String get todayCleanupDescription =>
      'For intentional rounds with time, an optional location and photo.';

  @override
  String todayCountSemantics(int count) {
    return '$count cigarette butts collected today';
  }

  @override
  String todayPileLabel(int count, int limit) {
    return '$count / $limit IN THE CURRENT JAR';
  }

  @override
  String get todayGlassFilled => 'Jar full! An empty jar is ready.';

  @override
  String get todayCountLabel => 'CIGARETTE BUTTS TODAY';

  @override
  String get todayEditCount => 'Edit count';

  @override
  String get todayEditTitle => 'Edit today’s count';

  @override
  String get amountLabel => 'Count';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get historyTitle => 'Your history';

  @override
  String get historyTotal => 'Cigarette butts collected in total';

  @override
  String get historyDiary => 'DIARY';

  @override
  String get historyEmpty => 'Your collected cigarette butts will appear here.';

  @override
  String get historyRounds => 'CLEANUP ROUNDS';

  @override
  String get historyRoundsEmpty =>
      'Completed cleanup rounds will appear here with their details.';

  @override
  String historyCount(Object count) {
    return '$count cigarette butts';
  }

  @override
  String get historyCountOne => '1 cigarette butt';

  @override
  String get historyEditTitle => 'Adjust daily value';

  @override
  String get historyEditTooltip => 'Edit';

  @override
  String get historyPhotos => 'PHOTOS';

  @override
  String get sessionStartTitle => 'Start cleanup round';

  @override
  String get sessionNoLocation => 'Start round without location';

  @override
  String get sessionLocationPoint => 'Save location point';

  @override
  String get sessionRoute => 'Record route';

  @override
  String get sessionComplete => 'FINISH SESSION';

  @override
  String get sessionFinishTitle => 'Cleanup complete!';

  @override
  String get sessionCollected => 'CIGARETTE BUTTS COLLECTED';

  @override
  String get sessionSave => 'Save cleanup';

  @override
  String get sessionPhotoAdd => 'Add optional completion photo';

  @override
  String get sessionPhotoChange => 'Change completion photo';

  @override
  String get sessionPhotoNone => 'No photo selected';

  @override
  String get sessionPhotoReady => '1 completion photo ready to save';

  @override
  String get achievementsTitle => 'Achievements';

  @override
  String achievementsCount(int earned, int total) {
    return '$earned of $total achieved';
  }

  @override
  String get achievementsDescription =>
      'Your achievements are calculated locally on this device.';

  @override
  String get achievementsCollection => 'YOUR COLLECTION';

  @override
  String get communityTitle => 'Community';

  @override
  String get communityRefresh => 'Refresh';

  @override
  String get communityOptInTitle => 'Appear in ranking?';

  @override
  String get communityOptInDescription =>
      'Your nickname, avatar, and weekly count will be visible to other signed-in users. Email, photos, and locations remain private.';

  @override
  String get communityOptInNegative => 'Not now';

  @override
  String get communityOptInPositive => 'Participate';

  @override
  String get communitySaveError => 'Could not save community setting.';

  @override
  String get communityHeroTitle => 'Together counts for more.';

  @override
  String get communityHeroBody =>
      'Sign in to participate in the shared goal or see the weekly ranking.';

  @override
  String get communityOptInLabel => 'Appear in weekly ranking';

  @override
  String get communityOptInSublabel =>
      'Optional: only nickname, avatar and weekly count are shown.';

  @override
  String get communityWeeklyLabel => 'THIS WEEK';

  @override
  String get communityPrivateMessage =>
      'The ranking remains private until you voluntarily participate.';

  @override
  String get communityEmptyLeaderboard =>
      'No visible weekly values yet. You can make the start.';

  @override
  String get communitySyncNote =>
      'Local, unsynced entries always remain private and only count after successful synchronization.';

  @override
  String get communityGoalEmpty =>
      'The shared cleanup goal is currently being set up. Check back soon.';

  @override
  String get communityGoalLabel => 'SHARED GOAL';

  @override
  String get authErrorConfig => 'Sign in is not yet configured for this build.';

  @override
  String get authErrorGoogle => 'Google sign in could not be started.';

  @override
  String get welcomeTitle => 'Welcome to ZigiQuest';

  @override
  String get welcomeSubtitle =>
      'Collect butts, record your effort, and make your impact visible.';

  @override
  String get welcomeAccountInfoTitle => 'What is an account for?';

  @override
  String get welcomeAccountInfoBody =>
      'For private backup and synchronization between devices. Session photos can also be backed up privately. Counting, cleanup rounds, and history also work without an account.';

  @override
  String get welcomeGoogleSignIn => 'Sign in with Google (optional)';

  @override
  String get welcomeContinueGuest => 'Continue without account';

  @override
  String get welcomeFooter =>
      'After this, you will set up the app. Guest mode remains completely offline; you only need an account for private backup and synchronization.';

  @override
  String get howItWorksTitle => 'How ZigiQuest works';

  @override
  String get howItWorksSubtitle =>
      'Collect at your own pace – individual finds immediately or as a conscious cleanup round.';

  @override
  String get howItWorksQuickLogTitle => 'Quick log';

  @override
  String get howItWorksQuickLogBody =>
      'Tap the jar when you find individual butts.';

  @override
  String get howItWorksSessionTitle => 'Start cleanup round';

  @override
  String get howItWorksSessionBody =>
      'Record time, optional location, and a photo for a conscious round.';

  @override
  String get howItWorksHistoryTitle => 'See impact';

  @override
  String get howItWorksHistoryBody =>
      'Your history shows you days and completed cleanup rounds.';

  @override
  String get continueLabel => 'Continue';

  @override
  String get setupTitle => 'Quick setup';

  @override
  String get setupHeroTitle => 'Your app, your rules.';

  @override
  String get setupHeroBody =>
      'You can change everything later in the settings. Location always remains off until you actively choose it for a session.';

  @override
  String get setupCategoryAppearance => 'APPEARANCE';

  @override
  String get setupThemeSystem => 'System settings';

  @override
  String get setupThemeLight => 'Light';

  @override
  String get setupThemeDark => 'Dark';

  @override
  String get setupReducedMotionTitle => 'Reduced motion';

  @override
  String get setupReducedMotionBody => 'Fewer animations in the vessel.';

  @override
  String get setupCategoryFeedback => 'FEEDBACK';

  @override
  String get setupHapticsTitle => 'Haptics';

  @override
  String get setupHapticsBody => 'Light feedback when counting.';

  @override
  String get setupCategoryPrivacy => 'PRIVACY';

  @override
  String get setupCloudBackupTitle => 'Private cloud backup for photos';

  @override
  String get setupCloudBackupBody =>
      'Optional: uploaded session photos remain private.';

  @override
  String get setupCloudBackupGuestBody =>
      'Available with an account. As a guest, photos remain only on this device.';

  @override
  String get setupFinish => 'Save and start';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsCategoryAppearance => 'APPEARANCE';

  @override
  String get settingsThemeMode => 'Appearance';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsLanguageDe => 'Deutsch (German)';

  @override
  String get settingsLanguageFr => 'Français (French)';

  @override
  String get settingsLanguageIt => 'Italiano (Italian)';

  @override
  String get settingsLanguageSystem => 'System Default';

  @override
  String get settingsContainerStyle => 'Environment in the jar';

  @override
  String get settingsContainerStyleSubtitle =>
      'Choose a cleanup location as background';

  @override
  String get settingsVisualEffects => 'Visual effects';

  @override
  String get settingsVisualEffectsSubtitle =>
      'Scene atmosphere, glass glitter and zigi particles';

  @override
  String get settingsReducedMotion => 'Reduced motion';

  @override
  String get settingsCategoryFeedback => 'FEEDBACK';

  @override
  String get settingsHaptics => 'Haptics';

  @override
  String get settingsCategoryNotifications => 'NOTIFICATIONS';

  @override
  String get settingsSessionLimit => 'Session limit';

  @override
  String get settingsSessionLimitSubtitle =>
      'Open sessions will be safely finished after this';

  @override
  String settingsMinutes(int count) {
    return '$count min.';
  }

  @override
  String get settingsHour => '1 hour';

  @override
  String settingsHours(int count) {
    return '$count hours';
  }

  @override
  String get settingsReminders => 'Gentle cleanup reminders';

  @override
  String get settingsRemindersSubtitle =>
      'Optional: weekly, monthly after longer break';

  @override
  String get settingsNotificationsDenied => 'Notifications were not allowed.';

  @override
  String get settingsCategoryData => 'DATA';

  @override
  String get settingsSyncTitle => 'Data synchronization';

  @override
  String get settingsSyncSignIn => 'Sign in to back up your data.';

  @override
  String get settingsSyncing => 'Syncing ...';

  @override
  String get settingsSyncNever => 'Not synced yet';

  @override
  String settingsSyncLast(String timestamp) {
    return 'Last synced: $timestamp';
  }

  @override
  String get settingsCloudPhotos => 'Private cloud photos';

  @override
  String get settingsCloudPhotosSubtitle => 'Your backed up session photos';

  @override
  String get todayTitle => 'ZigiQuest';

  @override
  String get todayProfileTooltip => 'Profile';

  @override
  String todayJarsFilled(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'jars',
      one: 'jar',
    );
    return '$count $_temp0 filled';
  }

  @override
  String get historySessionMetricZigis => 'Zigis collected';

  @override
  String get historySessionMetricDuration => 'Duration';

  @override
  String get historySessionMetricPath => 'Path';

  @override
  String get historyTrackingPointTitle => 'Location point saved';

  @override
  String get historyTrackingPointBody =>
      'The location remains private and belongs only to this cleanup round.';

  @override
  String get historyTrackingRouteTitle => 'Route saved';

  @override
  String get historyTrackingRouteBody =>
      'The route remains private and belongs only to this cleanup round.';

  @override
  String get historyTrackingNoneTitle => 'Saved without location';

  @override
  String get historyTrackingNoneBody =>
      'No location data was saved for this cleanup round.';

  @override
  String get historyPhotosEmpty => 'No photo was saved for this round.';

  @override
  String get historyPhotoBefore => 'Before';

  @override
  String get historyPhotoAfter => 'Completion photo';

  @override
  String get historyRecentEmpty => 'No entries yet.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileGuest => 'Guest';

  @override
  String get profileMember => 'ZigiQuest Member';

  @override
  String get profileLoggedIn => 'Signed in';

  @override
  String get profileEmailDefault => 'Signed in';

  @override
  String get profileEditNameTooltip => 'Change name';

  @override
  String get profileMetricZigis => 'Zigis';

  @override
  String get profileMetricStreak => 'Streak';

  @override
  String get profileMetricBadges => 'Badges';

  @override
  String get profileAchievements => 'Achievements';

  @override
  String get profileAchievementsSubtitle => 'Your milestones';

  @override
  String get profileCommunity => 'Community';

  @override
  String get profileCommunitySubtitle => 'Make impact visible together';

  @override
  String get profileSignOut => 'Sign out';

  @override
  String get profileEditNameTitle => 'Display name';

  @override
  String get profileSaveError => 'Name could not be saved.';

  @override
  String get profileLocalOnly => 'Local on this device';

  @override
  String get sessionTrackingStatusNone => 'Without tracking';

  @override
  String get sessionTrackingStatusPoint => 'Location point';

  @override
  String get sessionTrackingStatusRoute => 'Route is being recorded';

  @override
  String get sessionActiveTitle => 'CLEANUP RUNNING';

  @override
  String get sessionActiveAddSemantic => 'Tap vessel to add a zigi';

  @override
  String get sessionJarFull => 'Jar full! A new empty jar is ready.';

  @override
  String get sessionFinishingMetricZigis => 'Zigis collected';

  @override
  String get sessionFinishingMetricDuration => 'Duration';

  @override
  String get sessionFinishingMetricPath => 'Path';

  @override
  String get sessionFinishingPhotoChange => 'Change completion photo';

  @override
  String get sessionFinishingPhotoAdd => 'Add optional completion photo';

  @override
  String get sessionFinishingPhotoReady => '1 completion photo ready to save';

  @override
  String get sessionFinishingPhotoNone => 'No photo selected';

  @override
  String get sessionFinishingPreviewError => 'Preview not available.';

  @override
  String get sessionSavedTitle => 'Cleanup complete!';

  @override
  String sessionSavedSummary(int count, String duration) {
    return '$count zigis in $duration';
  }

  @override
  String sessionSavedXp(int count) {
    return '+$count XP';
  }

  @override
  String get sessionSavedXpNone => 'No XP';

  @override
  String sessionSavedInventoryAdd(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'zigis were',
      one: 'zigi was',
    );
    return '$count $_temp0 added to your today-jar.';
  }

  @override
  String get sessionSavedInventoryNone => 'Today nothing was added to the jar.';

  @override
  String get sessionSavedGoHome => 'To home screen';

  @override
  String get sessionRatingRequest =>
      'A small request – only if ZigiQuest has earned it.';

  @override
  String get sessionRatingPositive => 'Rate ZigiQuest';

  @override
  String get sessionRatingNegative => 'Not now';

  @override
  String get sessionRatingNever => 'Don\'t ask again';

  @override
  String get sessionRatingWaiting => 'One moment ...';

  @override
  String get sessionRatingError =>
      'The review request is not yet available on this device.';

  @override
  String get sessionLocationStatusError =>
      'Location is not available. The session starts without tracking.';

  @override
  String get sessionStartHint =>
      'Choose whether this round may save a location or a route.';

  @override
  String get sessionActiveHintLabel => 'CLEANUP RUNNING';

  @override
  String sessionActiveJarLabel(Object count, Object limit) {
    return '$count / $limit IN THE CURRENT JAR';
  }

  @override
  String get sessionPhotoSourceCamera => 'Camera';

  @override
  String get sessionPhotoSourceGallery => 'Gallery';

  @override
  String get sessionFinalCountLabel => 'Final count';

  @override
  String get sessionCountDecreaseTooltip => 'One zigi less';

  @override
  String get sessionCountIncreaseTooltip => 'One zigi more';

  @override
  String get remotePhotosTitle => 'Private Cloud Photos';

  @override
  String get remotePhotosDeleteTitle => 'Delete cloud photo?';

  @override
  String get remotePhotosDeleteBody =>
      'The private cloud copy will be deleted. A local copy on this device will remain.';

  @override
  String get remotePhotosDeleteConfirm => 'Delete';

  @override
  String get remotePhotosDeleteSuccess => 'Cloud photo deleted.';

  @override
  String get remotePhotosDeleteError => 'Cloud photo could not be deleted.';

  @override
  String get remotePhotosPreviewBefore => 'Before';

  @override
  String get remotePhotosPreviewAfter => 'Completion';

  @override
  String get remotePhotosPreviewError => 'Photo could not be loaded.';

  @override
  String get remotePhotosLoadError => 'Cloud photos could not be loaded.';

  @override
  String get remotePhotosEmptyTitle => 'No private cloud photos yet';

  @override
  String get remotePhotosEmptyBody =>
      'Sign in, enable cloud backup, and finish a session with photos.';

  @override
  String remotePhotosItemLabel(String type, String date) {
    return '$type · $date';
  }

  @override
  String get questsTitle => 'Quests';

  @override
  String get questsSubtitle =>
      'Small goals help turn a walk into visible impact.';

  @override
  String get questsWeekly => 'WEEKLY QUEST';

  @override
  String get questsDaily => 'DAILY QUEST';

  @override
  String questsReward(int progress, int target, int reward) {
    return '$progress/$target\n+$reward XP';
  }

  @override
  String get discoverTitle => 'Tips & Knowledge';

  @override
  String get discoverSubtitle =>
      'Local knowledge and practical ideas. Tap a card to see source and details.';

  @override
  String get discoverSourceShow => 'Show source';

  @override
  String get discoverSourceLabel => 'SOURCE';

  @override
  String get discoverCopyLink => 'Copy';

  @override
  String get discoverOpenLink => 'Open';

  @override
  String get discoverLinkCopied => 'Link copied.';

  @override
  String get discoverLinkError => 'Link could not be opened.';

  @override
  String get discoverDismissTooltip => 'Hide today';

  @override
  String get discoverKindFact => 'FACT';

  @override
  String get discoverKindTip => 'TIP';

  @override
  String get discoverKindQuest => 'MINI-MISSION';

  @override
  String get achievement_first_find_title => 'First Find';

  @override
  String get achievement_first_find_description =>
      'Collect your first cigarette butt.';

  @override
  String get achievement_ten_cleaner_title => 'Clean Ten';

  @override
  String get achievement_ten_cleaner_description =>
      'Collect 10 cigarette butts in total.';

  @override
  String get achievement_hundred_club_title => 'Hundred Club';

  @override
  String get achievement_hundred_club_description =>
      'Collect 100 cigarette butts in total.';

  @override
  String get achievement_thousand_impact_title => 'Thousand Impact';

  @override
  String get achievement_thousand_impact_description =>
      'Collect 1,000 cigarette butts in total.';

  @override
  String get achievement_streak_three_title => 'Keep at it';

  @override
  String get achievement_streak_three_description =>
      'Collect on three consecutive days.';

  @override
  String get achievement_streak_seven_title => 'Weekly Fire';

  @override
  String get achievement_streak_seven_description =>
      'Collect on seven consecutive days.';

  @override
  String get achievement_first_session_title => 'Went out';

  @override
  String get achievement_first_session_description =>
      'Complete your first cleanup session.';

  @override
  String get achievement_ten_sessions_title => 'Cleanup Routine';

  @override
  String get achievement_ten_sessions_description =>
      'Complete ten cleanup sessions.';

  @override
  String get achievement_weekly_quest_title => 'Weekly Goal';

  @override
  String get achievement_weekly_quest_description =>
      'Collect 75 cigarette butts in one week.';

  @override
  String get discover_filter_plastic_title => 'Filters are plastic';

  @override
  String get discover_filter_plastic_body =>
      'Cigarette filters usually consist of cellulose acetate. They therefore do not belong in the environment.';

  @override
  String get discover_swiss_shores_title => 'Frequently found on Swiss shores';

  @override
  String get discover_swiss_shores_body =>
      'In a BAFU survey on Swiss lakes and rivers, cigarette filters were the most frequently found item.';

  @override
  String get discover_gully_not_bin_title => 'A gully is not an ashtray';

  @override
  String get discover_gully_not_bin_body =>
      'Waste belongs in the waste container. This prevents plastics from entering soil and water in an uncontrolled manner.';

  @override
  String get discover_cleanup_kit_title => 'Small cleanup kit';

  @override
  String get discover_cleanup_kit_body =>
      'A tight jar or a small tin in your backpack makes spontaneous collection rounds easier.';

  @override
  String get discover_safe_pickup_title => 'Collect safely and cleanly';

  @override
  String get discover_safe_pickup_body =>
      'If you like, take gloves or a gripper and then dispose of the contents in the trash.';

  @override
  String get discover_micro_cleanup_title => 'Mini-mission: five minutes';

  @override
  String get discover_micro_cleanup_body =>
      'A short cleanup at a bench, stop or on the lakeshore is a good start.';

  @override
  String get discover_hotspots_title => 'Consciously look at hotspots';

  @override
  String get discover_hotspots_body =>
      'Places with a lot of outdoor stays often deserve a second look: benches, parking lots, entrance areas and stops.';

  @override
  String get discover_together_title => 'Don\'t collect alone';

  @override
  String get discover_together_body =>
      'With friends or a local action, a cleanup easily becomes a habit.';

  @override
  String get notificationChannelName => 'Gentle Reminders';

  @override
  String get notificationChannelDescription =>
      'Optional cleanup reminders and session notes.';

  @override
  String get notificationReminderTitle => 'Time for a small round?';

  @override
  String get notificationReminderBodyInactive =>
      'If you like: A short cleanup makes a visible difference.';

  @override
  String get notificationReminderBodyActive =>
      'Feel like a short cleanup walk? No pressure.';

  @override
  String get notificationExpiredTitle => 'Cleanup session ended';

  @override
  String get notificationExpiredBody =>
      'Your open session was safely finished after the set time.';

  @override
  String get vessel_city_label => 'Swiss City';

  @override
  String get vessel_river_label => 'Riverside';

  @override
  String get vessel_forest_label => 'Forest Path';

  @override
  String get vessel_parking_label => 'Parking Lot';

  @override
  String get vessel_add_tooltip => 'Add one zigi';

  @override
  String get vessel_remove_tooltip => 'Remove one zigi';

  @override
  String get quest_daily_10_title => 'Collect 10 zigis today';

  @override
  String get quest_daily_25_title => 'Collect 25 zigis today';

  @override
  String get quest_session_1_title => 'Complete a cleanup session';

  @override
  String get quest_weekly_75_title => 'Weekly goal: 75 zigis';

  @override
  String get quest_weekly_3_title => 'Weekly goal: 3 sessions';
}
