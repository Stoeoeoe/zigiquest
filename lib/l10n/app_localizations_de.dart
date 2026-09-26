// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'ZigiQuest';

  @override
  String get navToday => 'Heute';

  @override
  String get navHistory => 'Verlauf';

  @override
  String get navQuests => 'Quests';

  @override
  String get navKnowledge => 'Wissen';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get todayCleanupStart => 'CLEANUP-RUNDE STARTEN';

  @override
  String get todayCleanupContinue => 'CLEANUP FORTSETZEN';

  @override
  String get todayQuickLog => 'SCHNELL ERFASSEN';

  @override
  String get todayQuickLogDescription => 'Tippe das Glas für einzelne Funde.';

  @override
  String get todayCleanupDescription =>
      'Für bewusste Runden mit Zeit, optionalem Ort und Foto.';

  @override
  String todayCountSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zigis',
      one: 'Zigi',
    );
    return '$count $_temp0 heute gesammelt';
  }

  @override
  String todayPileLabel(int count, int limit) {
    return '$count / $limit IM AKTUELLEN GLAS';
  }

  @override
  String get todayGlassFilled => 'Glas gefüllt! Ein leeres Glas ist bereit.';

  @override
  String get todayCountLabel => 'ZIGIS HEUTE';

  @override
  String get todayEditCount => 'Anzahl korrigieren';

  @override
  String get todayEditTitle => 'Zigis von heute korrigieren';

  @override
  String get amountLabel => 'Anzahl';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get historyTitle => 'Dein Verlauf';

  @override
  String get historyTotal => 'Zigis insgesamt gesammelt';

  @override
  String get historyDiary => 'TAGEBUCH';

  @override
  String get historyEmpty => 'Deine gesammelten Zigis erscheinen hier.';

  @override
  String get historyRounds => 'CLEANUP-RUNDEN';

  @override
  String get historyRoundsEmpty =>
      'Abgeschlossene Cleanup-Runden erscheinen hier mit ihren Details.';

  @override
  String historyCount(Object count) {
    return '$count Zigis';
  }

  @override
  String get historyCountOne => '1 Zigi';

  @override
  String get historyEditTitle => 'Tageswert anpassen';

  @override
  String get historyEditTooltip => 'Bearbeiten';

  @override
  String get historyPhotos => 'FOTOS';

  @override
  String get sessionStartTitle => 'Cleanup-Runde starten';

  @override
  String get sessionNoLocation => 'Runde ohne Standort starten';

  @override
  String get sessionLocationPoint => 'Standortpunkt speichern';

  @override
  String get sessionRoute => 'Route aufzeichnen';

  @override
  String get sessionComplete => 'SESSION ABSCHLIESSEN';

  @override
  String get sessionFinishTitle => 'Cleanup geschafft!';

  @override
  String get sessionCollected => 'ZIGIS GESAMMELT';

  @override
  String get sessionSave => 'Cleanup speichern';

  @override
  String get sessionPhotoAdd => 'Optionales Abschlussfoto hinzufügen';

  @override
  String get sessionPhotoChange => 'Abschlussfoto ändern';

  @override
  String get sessionPhotoNone => 'Kein Foto ausgewählt';

  @override
  String get sessionPhotoReady => '1 Abschlussfoto bereit zum Speichern';

  @override
  String get achievementsTitle => 'Erfolge';

  @override
  String achievementsCount(int earned, int total) {
    return '$earned von $total erreicht';
  }

  @override
  String get achievementsDescription =>
      'Deine Erfolge werden direkt auf diesem Gerät berechnet.';

  @override
  String get achievementsCollection => 'DEINE SAMMLUNG';

  @override
  String get communityTitle => 'Community';

  @override
  String get communityRefresh => 'Aktualisieren';

  @override
  String get communityOptInTitle => 'Im Ranking erscheinen?';

  @override
  String get communityOptInDescription =>
      'Dein Nickname, Avatar und dein Wochenwert werden für andere angemeldete Nutzer sichtbar. E-Mail, Fotos und Standorte bleiben privat.';

  @override
  String get communityOptInNegative => 'Nicht jetzt';

  @override
  String get communityOptInPositive => 'Teilnehmen';

  @override
  String get communitySaveError =>
      'Community-Einstellung konnte nicht gespeichert werden.';

  @override
  String get communityHeroTitle => 'Gemeinsam zählt mehr.';

  @override
  String get communityHeroBody =>
      'Melde dich an, um beim gemeinsamen Ziel mitzumachen oder das Wochenranking zu sehen.';

  @override
  String get communityOptInLabel => 'Im Wochenranking erscheinen';

  @override
  String get communityOptInSublabel =>
      'Optional: nur Nickname, Avatar und Wochenwert werden gezeigt.';

  @override
  String get communityWeeklyLabel => 'DIESE WOCHE';

  @override
  String get communityPrivateMessage =>
      'Das Ranking bleibt privat, bis du freiwillig teilnimmst.';

  @override
  String get communityEmptyLeaderboard =>
      'Noch keine sichtbaren Wochenwerte. Du kannst den Anfang machen.';

  @override
  String get communitySyncNote =>
      'Lokale, nicht synchronisierte Einträge bleiben immer privat und zählen erst nach erfolgreicher Synchronisierung mit.';

  @override
  String get communityGoalEmpty =>
      'Das gemeinsame Cleanup-Ziel wird gerade eingerichtet. Schau bald wieder vorbei.';

  @override
  String get communityGoalLabel => 'GEMEINSAMES ZIEL';

  @override
  String get authErrorConfig =>
      'Anmeldung ist auf diesem Build noch nicht konfiguriert.';

  @override
  String get authErrorGoogle =>
      'Google-Anmeldung konnte nicht gestartet werden.';

  @override
  String get welcomeTitle => 'Willkommen bei ZigiQuest';

  @override
  String get welcomeSubtitle =>
      'Sammle Zigis, halte deinen Einsatz fest und mach deine Wirkung sichtbar.';

  @override
  String get welcomeAccountInfoTitle => 'Wofür ist ein Konto da?';

  @override
  String get welcomeAccountInfoBody =>
      'Für private Sicherung und Synchronisierung zwischen Geräten. Session-Fotos können ebenfalls privat gesichert werden. Zählen, Cleanup-Runden und Verlauf funktionieren auch ohne Konto.';

  @override
  String get welcomeGoogleSignIn => 'Mit Google anmelden (optional)';

  @override
  String get welcomeContinueGuest => 'Ohne Konto fortfahren';

  @override
  String get welcomeFooter =>
      'Danach richtest du die App ein. Der Gastmodus bleibt vollständig offline; ein Konto brauchst du nur für private Sicherung und Synchronisierung.';

  @override
  String get howItWorksTitle => 'So funktioniert ZigiQuest';

  @override
  String get howItWorksSubtitle =>
      'Sammle in deinem Tempo – einzelne Funde sofort oder als bewusste Cleanup-Runde.';

  @override
  String get howItWorksQuickLogTitle => 'Schnell erfassen';

  @override
  String get howItWorksQuickLogBody =>
      'Tippe auf das Glas, wenn du einzelne Zigis findest.';

  @override
  String get howItWorksSessionTitle => 'Cleanup-Runde starten';

  @override
  String get howItWorksSessionBody =>
      'Halte Zeit, optionalen Standort und ein Foto zu einer bewussten Runde fest.';

  @override
  String get howItWorksHistoryTitle => 'Wirkung wiedersehen';

  @override
  String get howItWorksHistoryBody =>
      'Dein Verlauf zeigt dir Tage und abgeschlossene Cleanup-Runden.';

  @override
  String get continueLabel => 'Weiter';

  @override
  String get setupTitle => 'Kurz einrichten';

  @override
  String get setupHeroTitle => 'Deine App, deine Regeln.';

  @override
  String get setupHeroBody =>
      'Du kannst alles später in den Einstellungen ändern. Standort bleibt immer aus, bis du ihn für eine Session aktiv wählst.';

  @override
  String get setupCategoryAppearance => 'DARSTELLUNG';

  @override
  String get setupThemeSystem => 'System';

  @override
  String get setupThemeLight => 'Hell';

  @override
  String get setupThemeDark => 'Dunkel';

  @override
  String get setupReducedMotionTitle => 'Reduzierte Bewegung';

  @override
  String get setupReducedMotionBody => 'Weniger Animationen im Gefäss.';

  @override
  String get setupCategoryFeedback => 'FEEDBACK';

  @override
  String get setupHapticsTitle => 'Haptik';

  @override
  String get setupHapticsBody => 'Leichte Rückmeldung beim Zählen.';

  @override
  String get setupCategoryPrivacy => 'PRIVATSPHÄRE';

  @override
  String get setupCloudBackupTitle => 'Private Cloud-Sicherung für Fotos';

  @override
  String get setupCloudBackupBody =>
      'Optional: hochgeladene Session-Fotos bleiben privat.';

  @override
  String get setupCloudBackupGuestBody =>
      'Mit einem Konto verfügbar. Als Gast bleiben Fotos nur auf diesem Gerät.';

  @override
  String get setupFinish => 'Speichern und starten';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsCategoryAppearance => 'DARSTELLUNG';

  @override
  String get settingsThemeMode => 'Erscheinungsbild';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLanguageEn => 'English (Englisch)';

  @override
  String get settingsLanguageDe => 'Deutsch';

  @override
  String get settingsLanguageFr => 'Français (Französisch)';

  @override
  String get settingsLanguageIt => 'Italiano (Italienisch)';

  @override
  String get settingsLanguageSystem => 'Systemstandard';

  @override
  String get settingsContainerStyle => 'Umgebung im Glas';

  @override
  String get settingsContainerStyleSubtitle =>
      'Wähle einen Cleanup-Ort als Hintergrund';

  @override
  String get settingsVisualEffects => 'Visuelle Effekte';

  @override
  String get settingsVisualEffectsSubtitle =>
      'Szenen-Atmosphäre, Glasglitzer und Zigi-Partikel';

  @override
  String get settingsReducedMotion => 'Reduzierte Bewegung';

  @override
  String get settingsCategoryFeedback => 'FEEDBACK';

  @override
  String get settingsHaptics => 'Beim Zählen vibrieren';

  @override
  String get settingsCategoryNotifications => 'BENACHRICHTIGUNGEN';

  @override
  String get settingsSessionLimit => 'Session-Limit';

  @override
  String get settingsSessionLimitSubtitle =>
      'Offene Sessions werden danach sicher abgeschlossen';

  @override
  String settingsMinutes(int count) {
    return '$count Min.';
  }

  @override
  String get settingsHour => '1 Stunde';

  @override
  String settingsHours(int count) {
    return '$count Stunden';
  }

  @override
  String get settingsReminders => 'Sanfte Cleanup-Erinnerungen';

  @override
  String get settingsRemindersSubtitle =>
      'Optional: wöchentlich, bei längerer Pause monatlich';

  @override
  String get settingsNotificationsDenied =>
      'Benachrichtigungen wurden nicht erlaubt.';

  @override
  String get settingsCategoryData => 'DATEN';

  @override
  String get settingsSyncTitle => 'Datensynchronisierung';

  @override
  String get settingsSyncSignIn => 'Melde dich an, um deine Daten zu sichern.';

  @override
  String get settingsSyncing => 'Wird synchronisiert ...';

  @override
  String get settingsSyncNever => 'Noch nicht synchronisiert';

  @override
  String settingsSyncLast(String timestamp) {
    return 'Zuletzt synchronisiert: $timestamp';
  }

  @override
  String get settingsCloudPhotos => 'Private Cloud-Fotos';

  @override
  String get settingsCloudPhotosSubtitle => 'Deine gesicherten Session-Fotos';

  @override
  String get todayTitle => 'ZigiQuest';

  @override
  String get todayProfileTooltip => 'Profil';

  @override
  String todayJarsFilled(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gläser',
      one: 'Glas',
    );
    return '$count $_temp0 gefüllt';
  }

  @override
  String get historySessionMetricZigis => 'Zigis gesammelt';

  @override
  String get historySessionMetricDuration => 'Dauer';

  @override
  String get historySessionMetricPath => 'Strecke';

  @override
  String get historyTrackingPointTitle => 'Standortpunkt gespeichert';

  @override
  String get historyTrackingPointBody =>
      'Der Standort bleibt privat und gehört nur zu dieser Cleanup-Runde.';

  @override
  String get historyTrackingRouteTitle => 'Route gespeichert';

  @override
  String get historyTrackingRouteBody =>
      'Die Route bleibt privat und gehört nur zu dieser Cleanup-Runde.';

  @override
  String get historyTrackingNoneTitle => 'Ohne Standort gespeichert';

  @override
  String get historyTrackingNoneBody =>
      'Für diese Cleanup-Runde wurden keine Standortdaten gespeichert.';

  @override
  String get historyPhotosEmpty =>
      'Für diese Runde wurde kein Foto gespeichert.';

  @override
  String get historyPhotoBefore => 'Vorher';

  @override
  String get historyPhotoAfter => 'Abschlussfoto';

  @override
  String get historyRecentEmpty => 'Noch keine Einträge.';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileGuest => 'Gast';

  @override
  String get profileMember => 'ZigiQuest-Mitglied';

  @override
  String get profileLoggedIn => 'Angemeldet';

  @override
  String get profileEmailDefault => 'Angemeldet';

  @override
  String get profileEditNameTooltip => 'Name ändern';

  @override
  String get profileMetricZigis => 'Zigis';

  @override
  String get profileMetricStreak => 'Tage-Serie';

  @override
  String get profileMetricBadges => 'Badges';

  @override
  String get profileAchievements => 'Erfolge';

  @override
  String get profileAchievementsSubtitle => 'Deine Meilensteine';

  @override
  String get profileCommunity => 'Community';

  @override
  String get profileCommunitySubtitle => 'Gemeinsam Wirkung sichtbar machen';

  @override
  String get profileSignOut => 'Abmelden';

  @override
  String get profileEditNameTitle => 'Anzeigename';

  @override
  String get profileSaveError => 'Name konnte nicht gespeichert werden.';

  @override
  String get profileLocalOnly => 'Nur auf diesem Gerät';

  @override
  String get sessionTrackingStatusNone => 'Ohne Standort';

  @override
  String get sessionTrackingStatusPoint => 'Standortpunkt';

  @override
  String get sessionTrackingStatusRoute => 'Route wird aufgezeichnet';

  @override
  String get sessionActiveTitle => 'CLEANUP LÄUFT';

  @override
  String get sessionActiveAddSemantic =>
      'Glas antippen, um eine Zigi hinzuzufügen';

  @override
  String get sessionJarFull =>
      'Glas gefüllt! Ein neues leeres Glas ist bereit.';

  @override
  String get sessionFinishingMetricZigis => 'Zigis gesammelt';

  @override
  String get sessionFinishingMetricDuration => 'Dauer';

  @override
  String get sessionFinishingMetricPath => 'Strecke';

  @override
  String get sessionFinishingPhotoChange => 'Abschlussfoto ändern';

  @override
  String get sessionFinishingPhotoAdd => 'Optionales Abschlussfoto hinzufügen';

  @override
  String get sessionFinishingPhotoReady =>
      '1 Abschlussfoto bereit zum Speichern';

  @override
  String get sessionFinishingPhotoNone => 'Kein Foto ausgewählt';

  @override
  String get sessionFinishingPreviewError => 'Vorschau nicht verfügbar.';

  @override
  String get sessionSavedTitle => 'Cleanup geschafft!';

  @override
  String sessionSavedSummary(int count, String duration) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zigis',
      one: 'Zigi',
    );
    return '$count $_temp0 in $duration';
  }

  @override
  String sessionSavedXp(int count) {
    return '+$count XP';
  }

  @override
  String get sessionSavedXpNone => 'Keine XP';

  @override
  String sessionSavedInventoryAdd(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zigis wurden',
      one: 'Zigi wurde',
    );
    return '$count $_temp0 zu deinem Heute-Glas hinzugefügt.';
  }

  @override
  String get sessionSavedInventoryNone =>
      'Heute wurde nichts zum Glas hinzugefügt.';

  @override
  String get sessionSavedGoHome => 'Zur Startseite';

  @override
  String get sessionRatingRequest =>
      'Eine kleine Bitte – nur wenn ZigiQuest sie verdient hat.';

  @override
  String get sessionRatingPositive => 'ZigiQuest bewerten';

  @override
  String get sessionRatingNegative => 'Nicht jetzt';

  @override
  String get sessionRatingNever => 'Nicht mehr fragen';

  @override
  String get sessionRatingWaiting => 'Einen Moment ...';

  @override
  String get sessionRatingError =>
      'Die Bewertungsanfrage ist auf diesem Gerät noch nicht verfügbar.';

  @override
  String get sessionLocationStatusError =>
      'Standort ist nicht verfügbar. Die Session startet ohne Standort-Tracking.';

  @override
  String get sessionStartHint =>
      'Wähle, ob diese Runde einen Standort oder eine Route speichern darf.';

  @override
  String get sessionActiveHintLabel => 'CLEANUP LÄUFT';

  @override
  String sessionActiveJarLabel(Object count, Object limit) {
    return '$count / $limit IM AKTUELLEN GLAS';
  }

  @override
  String get sessionPhotoSourceCamera => 'Kamera';

  @override
  String get sessionPhotoSourceGallery => 'Galerie';

  @override
  String get sessionFinalCountLabel => 'Endstand';

  @override
  String get sessionCountDecreaseTooltip => 'Zigi entfernen';

  @override
  String get sessionCountIncreaseTooltip => 'Zigi hinzufügen';

  @override
  String get remotePhotosTitle => 'Private Cloud-Fotos';

  @override
  String get remotePhotosDeleteTitle => 'Cloud-Foto löschen?';

  @override
  String get remotePhotosDeleteBody =>
      'Die private Cloud-Kopie wird gelöscht. Eine lokale Kopie auf diesem Gerät bleibt erhalten.';

  @override
  String get remotePhotosDeleteConfirm => 'Löschen';

  @override
  String get remotePhotosDeleteSuccess => 'Cloud-Foto gelöscht.';

  @override
  String get remotePhotosDeleteError =>
      'Cloud-Foto konnte nicht gelöscht werden.';

  @override
  String get remotePhotosPreviewBefore => 'Vorher';

  @override
  String get remotePhotosPreviewAfter => 'Abschlussfoto';

  @override
  String get remotePhotosPreviewError => 'Foto konnte nicht geladen werden.';

  @override
  String get remotePhotosLoadError =>
      'Cloud-Fotos konnten nicht geladen werden.';

  @override
  String get remotePhotosEmptyTitle => 'Noch keine privaten Cloud-Fotos';

  @override
  String get remotePhotosEmptyBody =>
      'Melde dich an, aktiviere die Cloud-Sicherung und beende eine Session mit Fotos.';

  @override
  String remotePhotosItemLabel(String type, String date) {
    return '$type · $date';
  }

  @override
  String get questsTitle => 'Quests';

  @override
  String get questsSubtitle =>
      'Kleine Ziele helfen dir, bei einem Spaziergang etwas zu bewirken.';

  @override
  String get questsWeekly => 'WOCHENQUEST';

  @override
  String get questsDaily => 'TAGESQUEST';

  @override
  String questsReward(int progress, int target, int reward) {
    return '$progress/$target\n+$reward XP';
  }

  @override
  String get discoverTitle => 'Tipps & Wissen';

  @override
  String get discoverSubtitle =>
      'Wissen rund um den praktischen Umweltschutz und praktische Ideen. Tippe eine Karte an, um Quelle und Details zu sehen.';

  @override
  String get discoverSourceShow => 'Quelle anzeigen';

  @override
  String get discoverSourceLabel => 'QUELLE';

  @override
  String get discoverCopyLink => 'Kopieren';

  @override
  String get discoverOpenLink => 'Öffnen';

  @override
  String get discoverLinkCopied => 'Link kopiert.';

  @override
  String get discoverLinkError => 'Link konnte nicht geöffnet werden.';

  @override
  String get discoverDismissTooltip => 'Heute ausblenden';

  @override
  String get discoverKindFact => 'WISSEN';

  @override
  String get discoverKindTip => 'TIPP';

  @override
  String get discoverKindQuest => 'MINI-MISSION';

  @override
  String get achievement_first_find_title => 'Erster Fund';

  @override
  String get achievement_first_find_description => 'Sammle deine erste Zigi.';

  @override
  String get achievement_ten_cleaner_title => 'Saubere Zehn';

  @override
  String get achievement_ten_cleaner_description =>
      'Sammle insgesamt 10 Zigis.';

  @override
  String get achievement_hundred_club_title => 'Hunderter-Club';

  @override
  String get achievement_hundred_club_description =>
      'Sammle insgesamt 100 Zigis.';

  @override
  String get achievement_thousand_impact_title => 'Grosse Wirkung';

  @override
  String get achievement_thousand_impact_description =>
      'Sammle insgesamt 1\'000 Zigis.';

  @override
  String get achievement_streak_three_title => 'Dranbleiben';

  @override
  String get achievement_streak_three_description =>
      'Sammle an drei Tagen in Folge.';

  @override
  String get achievement_streak_seven_title => 'Sieben Tage am Stück';

  @override
  String get achievement_streak_seven_description =>
      'Sammle an sieben Tagen in Folge.';

  @override
  String get achievement_first_session_title => 'Rausgegangen';

  @override
  String get achievement_first_session_description =>
      'Schliesse deine erste Cleanup-Session ab.';

  @override
  String get achievement_ten_sessions_title => 'Cleanup-Routine';

  @override
  String get achievement_ten_sessions_description =>
      'Schliesse zehn Cleanup-Sessions ab.';

  @override
  String get achievement_weekly_quest_title => 'Wochenziel';

  @override
  String get achievement_weekly_quest_description =>
      'Sammle 75 Zigis in einer Woche.';

  @override
  String get discover_filter_plastic_title => 'Filter sind Kunststoff';

  @override
  String get discover_filter_plastic_body =>
      'Zigarettenfilter bestehen meist aus Celluloseacetat. Sie gehören deshalb nicht in die Umwelt.';

  @override
  String get discover_swiss_shores_title =>
      'An Schweizer Ufern häufig gefunden';

  @override
  String get discover_swiss_shores_body =>
      'Bei einer BAFU-Erhebung an Schweizer Seen und Flüssen waren Zigarettenfilter der am häufigsten gefundene Gegenstand.';

  @override
  String get discover_gully_not_bin_title => 'Ein Gully ist kein Aschenbecher';

  @override
  String get discover_gully_not_bin_body =>
      'Abfälle gehören in den Abfallbehälter. So gelangen Kunststoffe nicht unkontrolliert in Böden und Gewässer.';

  @override
  String get discover_cleanup_kit_title => 'Kleines Cleanup-Kit';

  @override
  String get discover_cleanup_kit_body =>
      'Ein dichtes Glas oder eine kleine Dose im Rucksack macht spontane Sammelrunden einfacher.';

  @override
  String get discover_safe_pickup_title => 'Sicher und sauber sammeln';

  @override
  String get discover_safe_pickup_body =>
      'Wenn du magst, nimm Handschuhe oder eine Greifzange mit und entsorge den Inhalt danach im Abfall. Im Notfall tuts auch ein Taschentuch.';

  @override
  String get discover_micro_cleanup_title => 'Mini-Mission: fünf Minuten';

  @override
  String get discover_micro_cleanup_body =>
      'Ein kurzer Cleanup an einer Sitzbank, Bus-Haltestelle oder auf einem Parkplatz ist ein guter Anfang.';

  @override
  String get discover_hotspots_title => 'Hotspots bewusst ansehen';

  @override
  String get discover_hotspots_body =>
      'Orte mit viel Aufenthalt im Freien verdienen oft einen zweiten Blick: Sitzbänke, Parkplätze, Eingangsbereiche und Haltestellen.';

  @override
  String get discover_together_title => 'Nicht allein sammeln';

  @override
  String get discover_together_body =>
      'Mit Freundinnen, Freunden oder einer lokalen Aktion wird ein Cleanup leichter zur Gewohnheit.';

  @override
  String get notificationChannelName => 'Sanfte Erinnerungen';

  @override
  String get notificationChannelDescription =>
      'Optionale Cleanup-Erinnerungen und Hinweise.';

  @override
  String get notificationReminderTitle => 'Zeit für eine kleine Runde?';

  @override
  String get notificationReminderBodyInactive =>
      'Wenn du magst: Ein kurzer Cleanup macht einen sichtbaren Unterschied.';

  @override
  String get notificationReminderBodyActive =>
      'Lust auf einen kleinen Cleanup-Spaziergang? Ganz ohne Druck.';

  @override
  String get notificationExpiredTitle => 'Cleanup-Session beendet';

  @override
  String get notificationExpiredBody =>
      'Deine offene Session wurde nach der eingestellten Zeit abgeschlossen.';

  @override
  String get vessel_city_label => 'Stadt';

  @override
  String get vessel_river_label => 'Flussufer';

  @override
  String get vessel_forest_label => 'Waldweg';

  @override
  String get vessel_parking_label => 'Parkplatz';

  @override
  String get vessel_add_tooltip => 'Eine Zigi hinzufügen';

  @override
  String get vessel_remove_tooltip => 'Eine Zigi entfernen';

  @override
  String get quest_daily_10_title => 'Sammle 10 Zigis heute';

  @override
  String get quest_daily_25_title => 'Sammle 25 Zigis heute';

  @override
  String get quest_session_1_title => 'Schliesse eine Cleanup-Session ab';

  @override
  String get quest_weekly_75_title => 'Wochenziel: 75 Zigis';

  @override
  String get quest_weekly_3_title => 'Wochenziel: 3 Sessions';

  @override
  String get sessionInactivityTitle => 'Noch am Sammeln?';

  @override
  String get sessionInactivityBody =>
      'Dein Cleanup war zwei Stunden lang inaktiv. Möchtest du ihn jetzt abschliessen?';

  @override
  String get sessionInactivityContinue => 'Weiter sammeln';

  @override
  String get sessionInactivityEnd => 'Lauf beenden';

  @override
  String get notificationSessionCheckTitle => 'Noch am Sammeln?';

  @override
  String get notificationSessionCheckBody =>
      'Dein Cleanup ist noch offen. Tippe hier, um ihn fortzusetzen.';

  @override
  String get communityTabFriends => 'Freunde';

  @override
  String get communityTabActions => 'Aktionen';

  @override
  String get communityTabImpact => 'Wirkung';

  @override
  String get communityFriendsTitle => 'Dein Kreis';

  @override
  String get communityFriendsBody =>
      'Private, freundliche Motivation. Keine oeffentliche Rangliste.';

  @override
  String get communityInviteFriends => 'Freund:innen einladen';

  @override
  String get communityTogetherWeek => 'Diese Woche zusammen';

  @override
  String get communityNoFriends =>
      'Noch keine Freund:innen. Teile deinen Namen, um gemeinsam dranzubleiben.';

  @override
  String get communityActionNow => 'Aktuelle Aktion';

  @override
  String get communityActionWaterTitle => 'Sommer am Wasser';

  @override
  String get communityActionWaterBody =>
      'Eine Cleanup-Runde am See, Fluss oder Brunnen kann deine persoenliche Mini-Mission werden.';

  @override
  String get communityActionFiveTitle => 'Fuenf-Minuten-Reset';

  @override
  String get communityActionFiveBody =>
      'Ein kleiner Cleanup an einer Bank, Haltestelle oder auf dem Parkplatz ist ein starker Anfang.';

  @override
  String get communityImpactTitle => 'Wirkung, nicht Wettbewerb';

  @override
  String get communityImpactSolo =>
      'Deine Cleanups machen Orte sichtbar sauberer, Zigi fuer Zigi.';

  @override
  String communityImpactCircle(int count) {
    return 'Dein Freundeskreis hat diese Woche $count Zigis gesammelt.';
  }

  @override
  String get communityImpactPrivacy =>
      'Fotos und Routen bleiben privat, bis du eine Runde bewusst teilst.';

  @override
  String get communityGoalPreparing =>
      'Eine gemeinsame Aktion wird gerade vorbereitet.';

  @override
  String get communityGoalLabelNew => 'GEMEINSAME AKTION';

  @override
  String get friendsHandleTitle => 'Dein Freundesname';

  @override
  String get friendsHandlePrivacy =>
      'Nicht oeffentlich gelistet. Teile ihn nur mit Menschen, die du hinzufuegen moechtest.';

  @override
  String get friendsAddTitle => 'Freund:in hinzufuegen';

  @override
  String get friendsSearchHint => 'Name eingeben';

  @override
  String get friendsSearch => 'Suchen';

  @override
  String get friendsAdded => 'Hinzugefuegt';

  @override
  String get friendsShare => 'Freund:in einladen';

  @override
  String get friendsSignIn => 'Melde dich an, um Freund:innen hinzuzufuegen.';
}
