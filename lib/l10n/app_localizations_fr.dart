// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'ZigiQuest';

  @override
  String get navToday => 'Aujourd\'hui';

  @override
  String get navHistory => 'Historique';

  @override
  String get navQuests => 'Quêtes';

  @override
  String get navKnowledge => 'Savoir';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get todayCleanupStart => 'LANCER UNE TOUR NÉE';

  @override
  String get todayCleanupContinue => 'CONTINUER LA TOURNÉE';

  @override
  String get todayQuickLog => 'SAISIE RAPIDE';

  @override
  String get todayQuickLogDescription =>
      'Appuyez sur le bocal pour enregistrer vos trouvailles.';

  @override
  String get todayCleanupDescription =>
      'Pour des tournées dédiées avec durée, lieu optionnel et photo.';

  @override
  String todayCountSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mégots ramassés',
      one: 'mégot ramassé',
    );
    return '$count $_temp0 aujourd\'hui';
  }

  @override
  String todayPileLabel(int count, int limit) {
    return '$count / $limit DANS LE BOCAL ACTUEL';
  }

  @override
  String get todayGlassFilled =>
      'Bocal rempli ! Un nouveau bocal vide est prêt.';

  @override
  String get todayCountLabel => 'MÉGOTS AUJOURD\'HUI';

  @override
  String get todayEditCount => 'Corriger le nombre';

  @override
  String get todayEditTitle => 'Corriger le nombre de mégots d\'aujourd\'hui';

  @override
  String get amountLabel => 'Quantité';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get historyTitle => 'Votre historique';

  @override
  String get historyTotal => 'Total des mégots ramassés';

  @override
  String get historyDiary => 'JOURNAL';

  @override
  String get historyEmpty => 'Vos mégots ramassés apparaîtront ici.';

  @override
  String get historyRounds => 'TOURNÉES DE NETTOYAGE';

  @override
  String get historyRoundsEmpty =>
      'Les tournées de nettoyage terminées apparaîtront ici avec leurs détails.';

  @override
  String historyCount(Object count) {
    return '$count mégots';
  }

  @override
  String get historyCountOne => '1 mégot';

  @override
  String get historyEditTitle => 'Ajuster la valeur du jour';

  @override
  String get historyEditTooltip => 'Modifier';

  @override
  String get historyPhotos => 'PHOTOS';

  @override
  String get sessionStartTitle => 'Lancer une tournée de nettoyage';

  @override
  String get sessionNoLocation => 'Démarrer sans localisation';

  @override
  String get sessionLocationPoint => 'Enregistrer le point de localisation';

  @override
  String get sessionRoute => 'Enregistrer le parcours';

  @override
  String get sessionComplete => 'TERMINER LA SESSION';

  @override
  String get sessionFinishTitle => 'Nettoyage réussi !';

  @override
  String get sessionCollected => 'MÉGOTS RAMASSÉS';

  @override
  String get sessionSave => 'Enregistrer le nettoyage';

  @override
  String get sessionPhotoAdd => 'Ajouter une photo bilan (optionnel)';

  @override
  String get sessionPhotoChange => 'Changer la photo bilan';

  @override
  String get sessionPhotoNone => 'Aucune photo sélectionnée';

  @override
  String get sessionPhotoReady => '1 photo bilan prête à être enregistrée';

  @override
  String get achievementsTitle => 'Succès';

  @override
  String achievementsCount(int earned, int total) {
    return '$earned sur $total débloqués';
  }

  @override
  String get achievementsDescription =>
      'Vos succès sont calculés directement sur cet appareil.';

  @override
  String get achievementsCollection => 'VOTRE COLLECTION';

  @override
  String get communityTitle => 'Communauté';

  @override
  String get communityRefresh => 'Actualiser';

  @override
  String get communityOptInTitle => 'Apparaître dans le classement ?';

  @override
  String get communityOptInDescription =>
      'Votre pseudo, avatar et score hebdomadaire seront visibles pour les autres utilisateurs connectés. Votre e-mail, vos photos et vos lieux restent privés.';

  @override
  String get communityOptInNegative => 'Pas maintenant';

  @override
  String get communityOptInPositive => 'Participer';

  @override
  String get communitySaveError =>
      'Impossible d\'enregistrer les paramètres de la communauté.';

  @override
  String get communityHeroTitle => 'Plus d\'impact ensemble.';

  @override
  String get communityHeroBody =>
      'Connectez-vous pour participer à l\'objectif commun ou voir le classement hebdomadaire.';

  @override
  String get communityOptInLabel =>
      'Apparaître dans le classement hebdomadaire';

  @override
  String get communityOptInSublabel =>
      'Optionnel : seuls le pseudo, l\'avatar et le score hebdomadaire sont affichés.';

  @override
  String get communityWeeklyLabel => 'CETTE SEMAINE';

  @override
  String get communityPrivateMessage =>
      'Le classement reste privé jusqu\'à ce que vous choisissiez d\'y participer.';

  @override
  String get communityEmptyLeaderboard =>
      'Aucun score hebdomadaire visible pour le moment. Soyez le premier !';

  @override
  String get communitySyncNote =>
      'Les entrées locales non synchronisées restent toujours privées et ne comptent qu\'après une synchronisation réussie.';

  @override
  String get communityGoalEmpty =>
      'L\'objectif de nettoyage collectif est en cours de configuration. Revenez bientôt !';

  @override
  String get communityGoalLabel => 'OBJECTIF COLLECTIF';

  @override
  String get authErrorConfig =>
      'La connexion n\'est pas encore configurée sur cette version.';

  @override
  String get authErrorGoogle => 'Impossible de démarrer la connexion Google.';

  @override
  String get welcomeTitle => 'Bienvenue sur ZigiQuest';

  @override
  String get welcomeSubtitle =>
      'Ramassez des mégots, suivez vos efforts et rendez votre impact visible.';

  @override
  String get welcomeAccountInfoTitle => 'À quoi sert un compte ?';

  @override
  String get welcomeAccountInfoBody =>
      'Pour la sauvegarde privée et la synchronisation entre appareils. Les photos de session peuvent également être sauvegardées en toute confidentialité. Le comptage, les tournées et l\'historique fonctionnent aussi sans compte.';

  @override
  String get welcomeGoogleSignIn => 'Se connecter avec Google (optionnel)';

  @override
  String get welcomeContinueGuest => 'Continuer en tant qu\'invité';

  @override
  String get welcomeFooter =>
      'Ensuite, vous configurerez l\'application. Le mode invité reste totalement hors ligne ; un compte n\'est nécessaire que pour la sauvegarde privée et la synchronisation.';

  @override
  String get howItWorksTitle => 'Comment fonctionne ZigiQuest';

  @override
  String get howItWorksSubtitle =>
      'Ramassez à votre rythme – des trouvailles rapides ou des tournées de nettoyage dédiées.';

  @override
  String get howItWorksQuickLogTitle => 'Saisie rapide';

  @override
  String get howItWorksQuickLogBody =>
      'Appuyez sur le bocal lorsque vous trouvez des mégots isolés.';

  @override
  String get howItWorksSessionTitle => 'Lancer une tournée';

  @override
  String get howItWorksSessionBody =>
      'Enregistrez le temps, un lieu optionnel et une photo lors d\'une tournée dédiée.';

  @override
  String get howItWorksHistoryTitle => 'Visualisez votre impact';

  @override
  String get howItWorksHistoryBody =>
      'Votre historique vous montre vos journées et vos tournées de nettoyage terminées.';

  @override
  String get continueLabel => 'Continuer';

  @override
  String get setupTitle => 'Configuration rapide';

  @override
  String get setupHeroTitle => 'Votre application, vos règles.';

  @override
  String get setupHeroBody =>
      'Vous pourrez tout modifier plus tard dans les paramètres. La localisation reste désactivée tant que vous ne l\'activez pas pour une session.';

  @override
  String get setupCategoryAppearance => 'APPARENCE';

  @override
  String get setupThemeSystem => 'Système';

  @override
  String get setupThemeLight => 'Clair';

  @override
  String get setupThemeDark => 'Sombre';

  @override
  String get setupReducedMotionTitle => 'Mouvements réduits';

  @override
  String get setupReducedMotionBody => 'Moins d\'animations dans le bocal.';

  @override
  String get setupCategoryFeedback => 'RETOUR TACTILE';

  @override
  String get setupHapticsTitle => 'Haptique';

  @override
  String get setupHapticsBody => 'Légère vibration lors du comptage.';

  @override
  String get setupCategoryPrivacy => 'CONFIDENTIALITÉ';

  @override
  String get setupCloudBackupTitle => 'Sauvegarde cloud privée pour les photos';

  @override
  String get setupCloudBackupBody =>
      'Optionnel : les photos de session téléversées restent privées.';

  @override
  String get setupCloudBackupGuestBody =>
      'Disponible avec un compte. En mode invité, les photos restent uniquement sur cet appareil.';

  @override
  String get setupFinish => 'Enregistrer et démarrer';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsCategoryAppearance => 'APPARENCE';

  @override
  String get settingsThemeMode => 'Mode d\'affichage';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageEn => 'English (Anglais)';

  @override
  String get settingsLanguageDe => 'Deutsch (Allemand)';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageIt => 'Italiano (Italien)';

  @override
  String get settingsLanguageSystem => 'Langue du système';

  @override
  String get settingsContainerStyle => 'Environnement du bocal';

  @override
  String get settingsContainerStyleSubtitle =>
      'Choisissez un lieu de nettoyage comme arrière-plan';

  @override
  String get settingsVisualEffects => 'Effets visuels';

  @override
  String get settingsVisualEffectsSubtitle =>
      'Atmosphère de la scène, reflets du bocal et particules de mégots';

  @override
  String get settingsReducedMotion => 'Mouvements réduits';

  @override
  String get settingsCategoryFeedback => 'RETOUR TACTILE';

  @override
  String get settingsHaptics => 'Vibrer lors du comptage';

  @override
  String get settingsCategoryNotifications => 'NOTIFICATIONS';

  @override
  String get settingsSessionLimit => 'Limite de session';

  @override
  String get settingsSessionLimitSubtitle =>
      'Les sessions ouvertes seront automatiquement clôturées après ce délai';

  @override
  String settingsMinutes(int count) {
    return '$count min';
  }

  @override
  String get settingsHour => '1 heure';

  @override
  String settingsHours(int count) {
    return '$count heures';
  }

  @override
  String get settingsReminders => 'Rappels légers de nettoyage';

  @override
  String get settingsRemindersSubtitle =>
      'Optionnel : hebdomadaire, ou mensuel après une pause prolongée';

  @override
  String get settingsNotificationsDenied =>
      'Les notifications n\'ont pas été autorisées.';

  @override
  String get settingsCategoryData => 'DONNÉES';

  @override
  String get settingsSyncTitle => 'Synchronisation des données';

  @override
  String get settingsSyncSignIn =>
      'Connectez-vous pour sauvegarder vos données.';

  @override
  String get settingsSyncing => 'Synchronisation en cours...';

  @override
  String get settingsSyncNever => 'Pas encore synchronisé';

  @override
  String settingsSyncLast(String timestamp) {
    return 'Dernière synchronisation : $timestamp';
  }

  @override
  String get settingsCloudPhotos => 'Photos cloud privées';

  @override
  String get settingsCloudPhotosSubtitle =>
      'Vos photos de session sauvegardées';

  @override
  String get todayTitle => 'ZigiQuest';

  @override
  String get todayProfileTooltip => 'Profil';

  @override
  String todayJarsFilled(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'bocaux remplis',
      one: 'bocal rempli',
    );
    return '$count $_temp0';
  }

  @override
  String get historySessionMetricZigis => 'Mégots ramassés';

  @override
  String get historySessionMetricDuration => 'Durée';

  @override
  String get historySessionMetricPath => 'Distance';

  @override
  String get historyTrackingPointTitle => 'Point de localisation enregistré';

  @override
  String get historyTrackingPointBody =>
      'La localisation reste privée et appartient exclusivement à cette tournée de nettoyage.';

  @override
  String get historyTrackingRouteTitle => 'Parcours enregistré';

  @override
  String get historyTrackingRouteBody =>
      'Le parcours reste privé et appartient exclusivement à cette tournée de nettoyage.';

  @override
  String get historyTrackingNoneTitle => 'Enregistré sans localisation';

  @override
  String get historyTrackingNoneBody =>
      'Aucune donnée de localisation n\'a été enregistrée pour cette tournée.';

  @override
  String get historyPhotosEmpty =>
      'Aucune photo n\'a été enregistrée pour cette tournée.';

  @override
  String get historyPhotoBefore => 'Avant';

  @override
  String get historyPhotoAfter => 'Photo bilan';

  @override
  String get historyRecentEmpty => 'Aucune entrée pour le moment.';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileGuest => 'Invité';

  @override
  String get profileMember => 'Membre ZigiQuest';

  @override
  String get profileLoggedIn => 'Connecté';

  @override
  String get profileEmailDefault => 'Connecté';

  @override
  String get profileEditNameTooltip => 'Changer de nom';

  @override
  String get profileMetricZigis => 'Mégots';

  @override
  String get profileMetricStreak => 'Jours consécutifs';

  @override
  String get profileMetricBadges => 'Badges';

  @override
  String get profileAchievements => 'Succès';

  @override
  String get profileAchievementsSubtitle => 'Vos jalons';

  @override
  String get profileCommunity => 'Communauté';

  @override
  String get profileCommunitySubtitle => 'Rendre notre impact visible ensemble';

  @override
  String get profileSignOut => 'Se déconnecter';

  @override
  String get profileEditNameTitle => 'Nom d\'affichage';

  @override
  String get profileSaveError => 'Impossible d\'enregistrer le nom.';

  @override
  String get profileLocalOnly => 'Uniquement sur cet appareil';

  @override
  String get sessionTrackingStatusNone => 'Sans localisation';

  @override
  String get sessionTrackingStatusPoint => 'Point de localisation';

  @override
  String get sessionTrackingStatusRoute => 'Enregistrement du parcours';

  @override
  String get sessionActiveTitle => 'NETTOYAGE EN COURS';

  @override
  String get sessionActiveAddSemantic =>
      'Appuyez sur le bocal pour ajouter un mégot';

  @override
  String get sessionJarFull => 'Bocal rempli ! Un nouveau bocal vide est prêt.';

  @override
  String get sessionFinishingMetricZigis => 'Mégots ramassés';

  @override
  String get sessionFinishingMetricDuration => 'Durée';

  @override
  String get sessionFinishingMetricPath => 'Distance';

  @override
  String get sessionFinishingPhotoChange => 'Changer la photo bilan';

  @override
  String get sessionFinishingPhotoAdd => 'Ajouter une photo bilan (optionnel)';

  @override
  String get sessionFinishingPhotoReady =>
      '1 photo bilan prête à être enregistrée';

  @override
  String get sessionFinishingPhotoNone => 'Aucune photo sélectionnée';

  @override
  String get sessionFinishingPreviewError => 'Aperçu non disponible.';

  @override
  String get sessionSavedTitle => 'Nettoyage réussi !';

  @override
  String sessionSavedSummary(int count, String duration) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mégots',
      one: 'mégot',
    );
    return '$count $_temp0 en $duration';
  }

  @override
  String sessionSavedXp(int count) {
    return '+$count XP';
  }

  @override
  String get sessionSavedXpNone => 'Pas de XP';

  @override
  String sessionSavedInventoryAdd(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mégots ont été ajoutés',
      one: 'mégot a été ajouté',
    );
    return '$count $_temp0 à votre bocal d\'aujourd\'hui.';
  }

  @override
  String get sessionSavedInventoryNone =>
      'Rien n\'a été ajouté au bocal aujourd\'hui.';

  @override
  String get sessionSavedGoHome => 'Retour à l\'accueil';

  @override
  String get sessionRatingRequest =>
      'Une petite demande – seulement si ZigiQuest l\'a méritée.';

  @override
  String get sessionRatingPositive => 'Évaluer ZigiQuest';

  @override
  String get sessionRatingNegative => 'Pas maintenant';

  @override
  String get sessionRatingNever => 'Ne plus demander';

  @override
  String get sessionRatingWaiting => 'Un instant...';

  @override
  String get sessionRatingError =>
      'La demande d\'évaluation n\'est pas encore disponible sur cet appareil.';

  @override
  String get sessionLocationStatusError =>
      'La localisation est indisponible. La session démarre sans suivi de localisation.';

  @override
  String get sessionStartHint =>
      'Choisissez si cette tournée doit enregistrer un point de localisation ou un parcours.';

  @override
  String get sessionActiveHintLabel => 'NETTOYAGE EN COURS';

  @override
  String sessionActiveJarLabel(Object count, Object limit) {
    return '$count / $limit DANS LE BOCAL ACTUEL';
  }

  @override
  String get sessionPhotoSourceCamera => 'Appareil photo';

  @override
  String get sessionPhotoSourceGallery => 'Galerie';

  @override
  String get sessionFinalCountLabel => 'Résultat final';

  @override
  String get sessionCountDecreaseTooltip => 'Retirer un mégot';

  @override
  String get sessionCountIncreaseTooltip => 'Ajouter un mégot';

  @override
  String get remotePhotosTitle => 'Photos cloud privées';

  @override
  String get remotePhotosDeleteTitle => 'Supprimer la photo du cloud ?';

  @override
  String get remotePhotosDeleteBody =>
      'La copie privée sur le cloud sera supprimée. Une copie locale restera conservée sur cet appareil.';

  @override
  String get remotePhotosDeleteConfirm => 'Supprimer';

  @override
  String get remotePhotosDeleteSuccess => 'Photo cloud supprimée.';

  @override
  String get remotePhotosDeleteError =>
      'Impossible de supprimer la photo du cloud.';

  @override
  String get remotePhotosPreviewBefore => 'Avant';

  @override
  String get remotePhotosPreviewAfter => 'Photo bilan';

  @override
  String get remotePhotosPreviewError => 'Impossible de charger la photo.';

  @override
  String get remotePhotosLoadError => 'Impossible de charger les photos cloud.';

  @override
  String get remotePhotosEmptyTitle => 'Pas encore de photos cloud privées';

  @override
  String get remotePhotosEmptyBody =>
      'Connectez-vous, activez la sauvegarde cloud et terminez une session avec des photos.';

  @override
  String remotePhotosItemLabel(String type, String date) {
    return '$type · $date';
  }

  @override
  String get questsTitle => 'Quêtes';

  @override
  String get questsSubtitle =>
      'De petits objectifs pour vous aider à agir pendant vos promenades.';

  @override
  String get questsWeekly => 'QUÊTE HEBDOMADAIRE';

  @override
  String get questsDaily => 'QUÊTE DU JOUR';

  @override
  String questsReward(int progress, int target, int reward) {
    return '$progress/$target\n+$reward XP';
  }

  @override
  String get discoverTitle => 'Conseils & Savoir';

  @override
  String get discoverSubtitle =>
      'Des informations pratiques sur la protection de l\'environnement et des idées concrètes. Appuyez sur une carte pour voir la source et les détails.';

  @override
  String get discoverSourceShow => 'Afficher la source';

  @override
  String get discoverSourceLabel => 'SOURCE';

  @override
  String get discoverCopyLink => 'Copier';

  @override
  String get discoverOpenLink => 'Ouvrir';

  @override
  String get discoverLinkCopied => 'Lien copié.';

  @override
  String get discoverLinkError => 'Impossible d\'ouvrir le lien.';

  @override
  String get discoverDismissTooltip => 'Masquer aujourd\'hui';

  @override
  String get discoverKindFact => 'SAVOIR';

  @override
  String get discoverKindTip => 'CONSEIL';

  @override
  String get discoverKindQuest => 'MINI-MISSION';

  @override
  String get achievement_first_find_title => 'Première trouvaille';

  @override
  String get achievement_first_find_description =>
      'Ramassez votre premier mégot.';

  @override
  String get achievement_ten_cleaner_title => 'Les dix propretés';

  @override
  String get achievement_ten_cleaner_description =>
      'Ramassez un total de 10 mégots.';

  @override
  String get achievement_hundred_club_title => 'Club des cent';

  @override
  String get achievement_hundred_club_description =>
      'Ramassez un total de 100 mégots.';

  @override
  String get achievement_thousand_impact_title => 'Grand impact';

  @override
  String get achievement_thousand_impact_description =>
      'Ramassez un total de 1 000 mégots.';

  @override
  String get achievement_streak_three_title => 'Persévérance';

  @override
  String get achievement_streak_three_description =>
      'Ramassez des mégots trois jours de suite.';

  @override
  String get achievement_streak_seven_title => 'Sept jours d\'affilée';

  @override
  String get achievement_streak_seven_description =>
      'Ramassez des mégots sept jours de suite.';

  @override
  String get achievement_first_session_title => 'Première sortie';

  @override
  String get achievement_first_session_description =>
      'Terminez votre première session de nettoyage.';

  @override
  String get achievement_ten_sessions_title => 'Routine de nettoyage';

  @override
  String get achievement_ten_sessions_description =>
      'Terminez dix sessions de nettoyage.';

  @override
  String get achievement_weekly_quest_title => 'Objectif hebdomadaire';

  @override
  String get achievement_weekly_quest_description =>
      'Ramassez 75 mégots en une semaine.';

  @override
  String get discover_filter_plastic_title => 'Les filtres sont en plastique';

  @override
  String get discover_filter_plastic_body =>
      'Les filtres de cigarettes sont principalement faits d\'acétate de cellulose. C\'est pourquoi ils n\'ont pas leur place dans la nature.';

  @override
  String get discover_swiss_shores_title =>
      'Fréquemment trouvés sur les rives suisses';

  @override
  String get discover_swiss_shores_body =>
      'Lors d\'une étude de l\'OFEV sur les lacs et rivières suisses, les filtres de cigarettes étaient l\'objet le plus fréquemment trouvé.';

  @override
  String get discover_gully_not_bin_title =>
      'Une grille d\'égout n\'est pas un cendrier';

  @override
  String get discover_gully_not_bin_body =>
      'Les déchets vont à la poubelle. Cela évite que les plastiques ne se retrouvent de manière incontrôlée dans les sols et les cours d\'eau.';

  @override
  String get discover_cleanup_kit_title => 'Petit kit de nettoyage';

  @override
  String get discover_cleanup_kit_body =>
      'Un bocal étanche ou une petite boîte dans votre sac à dos facilite les ramassages spontanés.';

  @override
  String get discover_safe_pickup_title => 'Ramasser en toute sécurité';

  @override
  String get discover_safe_pickup_body =>
      'Si vous le souhaitez, prenez des gants ou une pince de ramassage, puis jetez le contenu à la poubelle. En cas d\'urgence, un mouchoir fait aussi l\'affaire.';

  @override
  String get discover_micro_cleanup_title => 'Mini-mission : cinq minutes';

  @override
  String get discover_micro_cleanup_body =>
      'Un court nettoyage autour d\'un banc, d\'un arrêt de bus ou sur un parking est un excellent début.';

  @override
  String get discover_hotspots_title =>
      'Observer attentivement les points chauds';

  @override
  String get discover_hotspots_body =>
      'Les lieux de rassemblement en plein air méritent souvent un second coup d\'œil : bancs, parkings, entrées et arrêts de transports.';

  @override
  String get discover_together_title => 'Ne pas ramasser seul';

  @override
  String get discover_together_body =>
      'Avec des amis ou lors d\'une action locale, le nettoyage devient plus facilement une habitude.';

  @override
  String get notificationChannelName => 'Rappels légers';

  @override
  String get notificationChannelDescription =>
      'Rappels et conseils optionnels pour le nettoyage.';

  @override
  String get notificationReminderTitle => 'Envie d\'une petite tournée ?';

  @override
  String get notificationReminderBodyInactive =>
      'Si le cœur vous en dit : un court nettoyage fait une différence visible.';

  @override
  String get notificationReminderBodyActive =>
      'Envie d\'une petite promenade de nettoyage ? Sans aucune pression.';

  @override
  String get notificationExpiredTitle => 'Session de nettoyage terminée';

  @override
  String get notificationExpiredBody =>
      'Votre session ouverte a été clôturée après la durée configurée.';

  @override
  String get vessel_city_label => 'Ville';

  @override
  String get vessel_river_label => 'Bord de rivière';

  @override
  String get vessel_forest_label => 'Chemin forestier';

  @override
  String get vessel_parking_label => 'Parking';

  @override
  String get vessel_add_tooltip => 'Ajouter un mégot';

  @override
  String get vessel_remove_tooltip => 'Retirer un mégot';

  @override
  String get quest_daily_10_title => 'Ramassez 10 mégots aujourd\'hui';

  @override
  String get quest_daily_25_title => 'Ramassez 25 mégots aujourd\'hui';

  @override
  String get quest_session_1_title => 'Terminez une session de nettoyage';

  @override
  String get quest_weekly_75_title => 'Objectif hebdomadaire : 75 mégots';

  @override
  String get quest_weekly_3_title => 'Objectif hebdomadaire : 3 sessions';

  @override
  String get sessionInactivityTitle => 'Vous collectez encore ?';

  @override
  String get sessionInactivityBody =>
      'Votre nettoyage est inactif depuis deux heures. Voulez-vous le terminer maintenant ?';

  @override
  String get sessionInactivityContinue => 'Continuer la collecte';

  @override
  String get sessionInactivityEnd => 'Terminer la session';

  @override
  String get notificationSessionCheckTitle => 'Vous collectez encore ?';

  @override
  String get notificationSessionCheckBody =>
      'Votre nettoyage est encore ouvert. Touchez ici pour le reprendre.';
}
