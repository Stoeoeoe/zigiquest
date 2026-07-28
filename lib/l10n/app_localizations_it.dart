// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'ZigiQuest';

  @override
  String get navToday => 'Oggi';

  @override
  String get navHistory => 'Cronologia';

  @override
  String get navQuests => 'Missioni';

  @override
  String get navKnowledge => 'Sapere';

  @override
  String get navSettings => 'Impostazioni';

  @override
  String get todayCleanupStart => 'AVVIA SESSIONE DI PULIZIA';

  @override
  String get todayCleanupContinue => 'CONTINUA PULIZIA';

  @override
  String get todayQuickLog => 'REGISTRAZIONE RAPIDA';

  @override
  String get todayQuickLogDescription =>
      'Tocca il barattolo per le singole raccolte.';

  @override
  String get todayCleanupDescription =>
      'Per sessioni dedicate con tempo, posizione opzionale e foto.';

  @override
  String todayCountSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mozziconi raccolti',
      one: 'mozzicone raccolto',
    );
    return '$count $_temp0 oggi';
  }

  @override
  String todayPileLabel(int count, int limit) {
    return '$count / $limit NEL BARATTOLO ATTUALE';
  }

  @override
  String get todayGlassFilled =>
      'Barattolo pieno! Un nuovo barattolo vuoto è pronto.';

  @override
  String get todayCountLabel => 'MOZZICONI OGGI';

  @override
  String get todayEditCount => 'Correggi conteggio';

  @override
  String get todayEditTitle => 'Correggi mozziconi di oggi';

  @override
  String get amountLabel => 'Quantità';

  @override
  String get cancel => 'Annulla';

  @override
  String get save => 'Salva';

  @override
  String get historyTitle => 'La tua cronologia';

  @override
  String get historyTotal => 'Totale mozziconi raccolti';

  @override
  String get historyDiary => 'DIARIO';

  @override
  String get historyEmpty => 'I tuoi mozziconi raccolti appariranno qui.';

  @override
  String get historyRounds => 'SESSIONI DI PULIZIA';

  @override
  String get historyRoundsEmpty =>
      'Le sessioni di pulizia completate appariranno qui con i dettagli.';

  @override
  String historyCount(Object count) {
    return '$count mozziconi';
  }

  @override
  String get historyCountOne => '1 mozzicone';

  @override
  String get historyEditTitle => 'Modifica valore giornaliero';

  @override
  String get historyEditTooltip => 'Modifica';

  @override
  String get historyPhotos => 'FOTO';

  @override
  String get sessionStartTitle => 'Avvia sessione di pulizia';

  @override
  String get sessionNoLocation => 'Avvia senza posizione';

  @override
  String get sessionLocationPoint => 'Salva punto di posizione';

  @override
  String get sessionRoute => 'Registra percorso';

  @override
  String get sessionComplete => 'CONCLUDI SESSIONE';

  @override
  String get sessionFinishTitle => 'Pulizia completata!';

  @override
  String get sessionCollected => 'MOZZICONI RACCOLTI';

  @override
  String get sessionSave => 'Salva pulizia';

  @override
  String get sessionPhotoAdd => 'Aggiungi foto finale opzionale';

  @override
  String get sessionPhotoChange => 'Cambia foto finale';

  @override
  String get sessionPhotoNone => 'Nessuna foto selezionata';

  @override
  String get sessionPhotoReady => '1 foto finale pronta da salvare';

  @override
  String get achievementsTitle => 'Traguardi';

  @override
  String achievementsCount(int earned, int total) {
    return '$earned su $total sbloccati';
  }

  @override
  String get achievementsDescription =>
      'I tuoi traguardi vengono calcolati direttamente su questo dispositivo.';

  @override
  String get achievementsCollection => 'LA TUA COLLEZIONE';

  @override
  String get communityTitle => 'Community';

  @override
  String get communityRefresh => 'Aggiorna';

  @override
  String get communityOptInTitle => 'Apparire nella classifica?';

  @override
  String get communityOptInDescription =>
      'Il tuo nickname, l\'avatar e il tuo punteggio settimanale saranno visibili agli altri utenti registrati. E-mail, foto e posizioni rimangono private.';

  @override
  String get communityOptInNegative => 'Non ora';

  @override
  String get communityOptInPositive => 'Partecipa';

  @override
  String get communitySaveError =>
      'Impossibile salvare le impostazioni della community.';

  @override
  String get communityHeroTitle => 'Insieme l\'impatto è maggiore.';

  @override
  String get communityHeroBody =>
      'Accedi per partecipare all\'obiettivo comune o per vedere la classifica settimanale.';

  @override
  String get communityOptInLabel => 'Appari nella classifica settimanale';

  @override
  String get communityOptInSublabel =>
      'Opzionale: vengono mostrati solo nickname, avatar e punteggio settimanale.';

  @override
  String get communityWeeklyLabel => 'QUESTA SETTIMANA';

  @override
  String get communityPrivateMessage =>
      'La classifica rimane privata finché non decidi volontariamente di partecipare.';

  @override
  String get communityEmptyLeaderboard =>
      'Nessun punteggio settimanale visibile al momento. Puoi essere il primo!';

  @override
  String get communitySyncNote =>
      'Le voci locali non sincronizzate rimangono sempre private e conteggiate solo dopo una sincronizzazione riuscita.';

  @override
  String get communityGoalEmpty =>
      'L\'obiettivo di pulizia collettivo è in fase di configurazione. Torna a trovarci presto!';

  @override
  String get communityGoalLabel => 'OBIETTIVO COLLETTIVO';

  @override
  String get authErrorConfig =>
      'L\'accesso non è ancora configurato su questa versione.';

  @override
  String get authErrorGoogle => 'Impossibile avviare l\'accesso con Google.';

  @override
  String get welcomeTitle => 'Benvenuto su ZigiQuest';

  @override
  String get welcomeSubtitle =>
      'Raccogli mozziconi, registra il tuo impegno e rendi visibile il tuo impatto.';

  @override
  String get welcomeAccountInfoTitle => 'A cosa serve un account?';

  @override
  String get welcomeAccountInfoBody =>
      'Per il backup privato e la sincronizzazione tra dispositivi. Anche le foto delle sessioni possono essere salvate in modo privato. Conteggio, sessioni di pulizia e cronologia funzionano anche senza account.';

  @override
  String get welcomeGoogleSignIn => 'Accedi con Google (opzionale)';

  @override
  String get welcomeContinueGuest => 'Continua come ospite';

  @override
  String get welcomeFooter =>
      'In seguito configurerai l\'app. La modalità ospite rimane completamente offline; l\'account serve solo per il backup privato e la sincronizzazione.';

  @override
  String get howItWorksTitle => 'Come funziona ZigiQuest';

  @override
  String get howItWorksSubtitle =>
      'Raccogli al tuo ritmo – singole raccolte rapide o sessioni di pulizia dedicate.';

  @override
  String get howItWorksQuickLogTitle => 'Registrazione rapida';

  @override
  String get howItWorksQuickLogBody =>
      'Tocca il barattolo quando trovi singoli mozziconi.';

  @override
  String get howItWorksSessionTitle => 'Avvia sessione di pulizia';

  @override
  String get howItWorksSessionBody =>
      'Registra tempo, posizione opzionale e una foto per una sessione dedicata.';

  @override
  String get howItWorksHistoryTitle => 'Rivedi il tuo impatto';

  @override
  String get howItWorksHistoryBody =>
      'La tua cronologia mostra i giorni e le sessioni di pulizia completate.';

  @override
  String get continueLabel => 'Continua';

  @override
  String get setupTitle => 'Configurazione rapida';

  @override
  String get setupHeroTitle => 'La tua app, le tue regole.';

  @override
  String get setupHeroBody =>
      'Puoi modificare tutto più tardi nelle impostazioni. La posizione rimane sempre disattivata finché non la attivi espressamente per una sessione.';

  @override
  String get setupCategoryAppearance => 'ASPETTO';

  @override
  String get setupThemeSystem => 'Di sistema';

  @override
  String get setupThemeLight => 'Chiaro';

  @override
  String get setupThemeDark => 'Scuro';

  @override
  String get setupReducedMotionTitle => 'Movimento ridotto';

  @override
  String get setupReducedMotionBody =>
      'Meno animazioni all\'interno del barattolo.';

  @override
  String get setupCategoryFeedback => 'FEEDBACK';

  @override
  String get setupHapticsTitle => 'Feedback aptico';

  @override
  String get setupHapticsBody => 'Lieve vibrazione durante il conteggio.';

  @override
  String get setupCategoryPrivacy => 'PRIVACY';

  @override
  String get setupCloudBackupTitle => 'Backup privato in cloud per le foto';

  @override
  String get setupCloudBackupBody =>
      'Opzionale: le foto delle sessioni caricate rimangono private.';

  @override
  String get setupCloudBackupGuestBody =>
      'Disponibile con un account. Come ospite, le foto rimangono solo su questo dispositivo.';

  @override
  String get setupFinish => 'Salva e avvia';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsCategoryAppearance => 'ASPETTO';

  @override
  String get settingsThemeMode => 'Tema dell\'interfaccia';

  @override
  String get settingsThemeSystem => 'Di sistema';

  @override
  String get settingsThemeLight => 'Chiaro';

  @override
  String get settingsThemeDark => 'Scuro';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsLanguageEn => 'English (Inglese)';

  @override
  String get settingsLanguageDe => 'Deutsch (Tedesco)';

  @override
  String get settingsLanguageFr => 'Français (Francese)';

  @override
  String get settingsLanguageIt => 'Italiano';

  @override
  String get settingsLanguageSystem => 'Predefinita di sistema';

  @override
  String get settingsContainerStyle => 'Ambiente del barattolo';

  @override
  String get settingsContainerStyleSubtitle =>
      'Scegli un luogo di pulizia come sfondo';

  @override
  String get settingsVisualEffects => 'Effetti visivi';

  @override
  String get settingsVisualEffectsSubtitle =>
      'Atmosfera della scena, riflessi del barattolo e particelle di mozziconi';

  @override
  String get settingsReducedMotion => 'Movimento ridotto';

  @override
  String get settingsCategoryFeedback => 'FEEDBACK';

  @override
  String get settingsHaptics => 'Vibra durante il conteggio';

  @override
  String get settingsCategoryNotifications => 'NOTIFICHE';

  @override
  String get settingsSessionLimit => 'Limite di tempo sessione';

  @override
  String get settingsSessionLimitSubtitle =>
      'Le sessioni aperte verranno concluse automaticamente dopo questo intervallo';

  @override
  String settingsMinutes(int count) {
    return '$count min.';
  }

  @override
  String get settingsHour => '1 ora';

  @override
  String settingsHours(int count) {
    return '$count ore';
  }

  @override
  String get settingsReminders => 'Gentili promemoria di pulizia';

  @override
  String get settingsRemindersSubtitle =>
      'Opzionale: settimanale, o mensile dopo un periodo di inattività';

  @override
  String get settingsNotificationsDenied =>
      'Le notifiche non sono state autorizzate.';

  @override
  String get settingsCategoryData => 'DATI';

  @override
  String get settingsSyncTitle => 'Sincronizzazione dati';

  @override
  String get settingsSyncSignIn => 'Accedi per salvare i tuoi dati.';

  @override
  String get settingsSyncing => 'Sincronizzazione in corso...';

  @override
  String get settingsSyncNever => 'Non ancora sincronizzato';

  @override
  String settingsSyncLast(String timestamp) {
    return 'Ultima sincronizzazione: $timestamp';
  }

  @override
  String get settingsCloudPhotos => 'Foto cloud private';

  @override
  String get settingsCloudPhotosSubtitle =>
      'Le foto delle tue sessioni salvate';

  @override
  String get todayTitle => 'ZigiQuest';

  @override
  String get todayProfileTooltip => 'Profilo';

  @override
  String todayJarsFilled(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'barattoli pieni',
      one: 'barattolo pieno',
    );
    return '$count $_temp0';
  }

  @override
  String get historySessionMetricZigis => 'Mozziconi raccolti';

  @override
  String get historySessionMetricDuration => 'Durata';

  @override
  String get historySessionMetricPath => 'Distanza';

  @override
  String get historyTrackingPointTitle => 'Punto di posizione salvato';

  @override
  String get historyTrackingPointBody =>
      'La posizione rimane privata e appartiene esclusivamente a questa sessione di pulizia.';

  @override
  String get historyTrackingRouteTitle => 'Percorso salvato';

  @override
  String get historyTrackingRouteBody =>
      'Il percorso rimane privato e appartiene esclusivamente a questa sessione di pulizia.';

  @override
  String get historyTrackingNoneTitle => 'Salvato senza posizione';

  @override
  String get historyTrackingNoneBody =>
      'Nessun dato di posizione è stato salvato per questa sessione di pulizia.';

  @override
  String get historyPhotosEmpty => 'Nessuna foto salvata per questa sessione.';

  @override
  String get historyPhotoBefore => 'Prima';

  @override
  String get historyPhotoAfter => 'Foto finale';

  @override
  String get historyRecentEmpty => 'Nessuna voce al momento.';

  @override
  String get profileTitle => 'Profilo';

  @override
  String get profileGuest => 'Ospite';

  @override
  String get profileMember => 'Membro ZigiQuest';

  @override
  String get profileLoggedIn => 'Connesso';

  @override
  String get profileEmailDefault => 'Connesso';

  @override
  String get profileEditNameTooltip => 'Cambia nome';

  @override
  String get profileMetricZigis => 'Mozziconi';

  @override
  String get profileMetricStreak => 'Giorni consecutivi';

  @override
  String get profileMetricBadges => 'Distintivi';

  @override
  String get profileAchievements => 'Traguardi';

  @override
  String get profileAchievementsSubtitle => 'Le tue tappe fondamentali';

  @override
  String get profileCommunity => 'Community';

  @override
  String get profileCommunitySubtitle => 'Rendere visibile l\'impatto insieme';

  @override
  String get profileSignOut => 'Disconnettiti';

  @override
  String get profileEditNameTitle => 'Nome visualizzato';

  @override
  String get profileSaveError => 'Impossibile salvare il nome.';

  @override
  String get profileLocalOnly => 'Solo su questo dispositivo';

  @override
  String get sessionTrackingStatusNone => 'Senza posizione';

  @override
  String get sessionTrackingStatusPoint => 'Punto di posizione';

  @override
  String get sessionTrackingStatusRoute => 'Registrazione percorso';

  @override
  String get sessionActiveTitle => 'PULIZIA IN CORSO';

  @override
  String get sessionActiveAddSemantic =>
      'Tocca il barattolo per aggiungere un mozzicone';

  @override
  String get sessionJarFull =>
      'Barattolo pieno! Un nuovo barattolo vuoto è pronto.';

  @override
  String get sessionFinishingMetricZigis => 'Mozziconi raccolti';

  @override
  String get sessionFinishingMetricDuration => 'Durata';

  @override
  String get sessionFinishingMetricPath => 'Distanza';

  @override
  String get sessionFinishingPhotoChange => 'Cambia foto finale';

  @override
  String get sessionFinishingPhotoAdd => 'Aggiungi foto finale opzionale';

  @override
  String get sessionFinishingPhotoReady => '1 foto finale pronta da salvare';

  @override
  String get sessionFinishingPhotoNone => 'Nessuna foto selezionata';

  @override
  String get sessionFinishingPreviewError => 'Anteprima non disponibile.';

  @override
  String get sessionSavedTitle => 'Pulizia completata!';

  @override
  String sessionSavedSummary(int count, String duration) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mozziconi',
      one: 'mozzicone',
    );
    return '$count $_temp0 in $duration';
  }

  @override
  String sessionSavedXp(int count) {
    return '+$count XP';
  }

  @override
  String get sessionSavedXpNone => 'Nessun XP';

  @override
  String sessionSavedInventoryAdd(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mozziconi sono stati aggiunti',
      one: 'mozzicone è stato aggiunto',
    );
    return '$count $_temp0 al tuo barattolo di oggi.';
  }

  @override
  String get sessionSavedInventoryNone =>
      'Niente è stato aggiunto al barattolo oggi.';

  @override
  String get sessionSavedGoHome => 'Torna alla Home';

  @override
  String get sessionRatingRequest =>
      'Una piccola richiesta – solo se ZigiQuest se la è meritata.';

  @override
  String get sessionRatingPositive => 'Valuta ZigiQuest';

  @override
  String get sessionRatingNegative => 'Non ora';

  @override
  String get sessionRatingNever => 'Non chiedere più';

  @override
  String get sessionRatingWaiting => 'Un momento...';

  @override
  String get sessionRatingError =>
      'La richiesta di valutazione non è ancora disponibile su questo dispositivo.';

  @override
  String get sessionLocationStatusError =>
      'La posizione non è disponibile. La sessione si avvia senza tracciamento della posizione.';

  @override
  String get sessionStartHint =>
      'Scegli se questa sessione deve salvare un punto di posizione o un percorso.';

  @override
  String get sessionActiveHintLabel => 'PULIZIA IN CORSO';

  @override
  String sessionActiveJarLabel(Object count, Object limit) {
    return '$count / $limit NEL BARATTOLO ATTUALE';
  }

  @override
  String get sessionPhotoSourceCamera => 'Fotocamera';

  @override
  String get sessionPhotoSourceGallery => 'Galleria';

  @override
  String get sessionFinalCountLabel => 'Risultato finale';

  @override
  String get sessionCountDecreaseTooltip => 'Rimuovi un mozzicone';

  @override
  String get sessionCountIncreaseTooltip => 'Aggiungi un mozzicone';

  @override
  String get remotePhotosTitle => 'Foto cloud private';

  @override
  String get remotePhotosDeleteTitle => 'Eliminare la foto dal cloud?';

  @override
  String get remotePhotosDeleteBody =>
      'La copia privata nel cloud verrà eliminata. Una copia locale su questo dispositivo verrà conservata.';

  @override
  String get remotePhotosDeleteConfirm => 'Elimina';

  @override
  String get remotePhotosDeleteSuccess => 'Foto nel cloud eliminata.';

  @override
  String get remotePhotosDeleteError =>
      'Impossibile eliminare la foto dal cloud.';

  @override
  String get remotePhotosPreviewBefore => 'Prima';

  @override
  String get remotePhotosPreviewAfter => 'Foto finale';

  @override
  String get remotePhotosPreviewError => 'Impossibile caricare la foto.';

  @override
  String get remotePhotosLoadError => 'Impossibile caricare le foto dal cloud.';

  @override
  String get remotePhotosEmptyTitle => 'Nessuna foto cloud privata al momento';

  @override
  String get remotePhotosEmptyBody =>
      'Accedi, attiva il backup in cloud e completa una sessione con foto.';

  @override
  String remotePhotosItemLabel(String type, String date) {
    return '$type · $date';
  }

  @override
  String get questsTitle => 'Missioni';

  @override
  String get questsSubtitle =>
      'Piccoli obiettivi per aiutarti a fare la differenza durante una passeggiata.';

  @override
  String get questsWeekly => 'MISSIONE SETTIMANALE';

  @override
  String get questsDaily => 'MISSIONE GIORNALIERA';

  @override
  String questsReward(int progress, int target, int reward) {
    return '$progress/$target\n+$reward XP';
  }

  @override
  String get discoverTitle => 'Consigli & Sapere';

  @override
  String get discoverSubtitle =>
      'Informazioni utili sulla protezione dell\'ambiente ed idee pratiche. Tocca una scheda per vedere fonte e dettagli.';

  @override
  String get discoverSourceShow => 'Mostra fonte';

  @override
  String get discoverSourceLabel => 'FONTE';

  @override
  String get discoverCopyLink => 'Copia';

  @override
  String get discoverOpenLink => 'Apri';

  @override
  String get discoverLinkCopied => 'Link copiato.';

  @override
  String get discoverLinkError => 'Impossibile aprire il link.';

  @override
  String get discoverDismissTooltip => 'Nascondi per oggi';

  @override
  String get discoverKindFact => 'SAPERE';

  @override
  String get discoverKindTip => 'CONSIGLIO';

  @override
  String get discoverKindQuest => 'MINI MISSIONE';

  @override
  String get achievement_first_find_title => 'Primo ritrovamento';

  @override
  String get achievement_first_find_description =>
      'Raccogli il tuo primo mozzicone.';

  @override
  String get achievement_ten_cleaner_title => 'Dieci puliti';

  @override
  String get achievement_ten_cleaner_description =>
      'Raccogli un totale di 10 mozziconi.';

  @override
  String get achievement_hundred_club_title => 'Club dei cento';

  @override
  String get achievement_hundred_club_description =>
      'Raccogli un totale di 100 mozziconi.';

  @override
  String get achievement_thousand_impact_title => 'Grande impatto';

  @override
  String get achievement_thousand_impact_description =>
      'Raccogli un totale di 1\'000 mozziconi.';

  @override
  String get achievement_streak_three_title => 'Costanza';

  @override
  String get achievement_streak_three_description =>
      'Raccogli mozziconi per tre giorni di seguito.';

  @override
  String get achievement_streak_seven_title => 'Sette giorni di fila';

  @override
  String get achievement_streak_seven_description =>
      'Raccogli mozziconi per sette giorni di seguito.';

  @override
  String get achievement_first_session_title => 'Prima uscita';

  @override
  String get achievement_first_session_description =>
      'Completa la tua prima sessione di pulizia.';

  @override
  String get achievement_ten_sessions_title => 'Routine di pulizia';

  @override
  String get achievement_ten_sessions_description =>
      'Completa dieci sessioni di pulizia.';

  @override
  String get achievement_weekly_quest_title => 'Obiettivo settimanale';

  @override
  String get achievement_weekly_quest_description =>
      'Raccogli 75 mozziconi in una settimana.';

  @override
  String get discover_filter_plastic_title => 'I filtri sono in plastica';

  @override
  String get discover_filter_plastic_body =>
      'I filtri delle sigarette sono fatti principalmente di acetato di cellulosa. Per questo non devono finire nell\'ambiente.';

  @override
  String get discover_swiss_shores_title => 'Frequenti sulle rive svizzere';

  @override
  String get discover_swiss_shores_body =>
      'In un\'indagine dell\'UFAM sui laghi e fiumi svizzeri, i filtri di sigaretta sono risultati l\'oggetto trovato più di frequente.';

  @override
  String get discover_gully_not_bin_title => 'Un tombino non è un posacenere';

  @override
  String get discover_gully_not_bin_body =>
      'I rifiuti vanno nei cestini. In questo modo si evita che le plastiche finiscano in modo incontrollato nel suolo e nelle acque.';

  @override
  String get discover_cleanup_kit_title => 'Piccolo kit da pulizia';

  @override
  String get discover_cleanup_kit_body =>
      'Un barattolo ben chiuso o una scatola nello zaino rendono più facili le raccolte spontanee.';

  @override
  String get discover_safe_pickup_title =>
      'Raccogliere in modo sicuro e pulito';

  @override
  String get discover_safe_pickup_body =>
      'Se vuoi, porta con te dei guanti o una pinza per rifiuti e poi smaltisci il contenuto nel cestino. In caso di necessità va bene anche un fazzoletto.';

  @override
  String get discover_micro_cleanup_title => 'Mini missione: cinque minuti';

  @override
  String get discover_micro_cleanup_body =>
      'Una breve pulizia vicino a una panchina, a una fermata dell\'autobus o in un parcheggio è un ottimo inizio.';

  @override
  String get discover_hotspots_title => 'Osservare i punti critici';

  @override
  String get discover_hotspots_body =>
      'I luoghi dove le persone si fermano all\'aperto meritano spesso una seconda occhiata: panchine, parcheggi, ingressi e fermate.';

  @override
  String get discover_together_title => 'Non raccogliere da solo';

  @override
  String get discover_together_body =>
      'Con gli amici o durante un\'azione locale, la pulizia diventa facilmente un\'abitudine.';

  @override
  String get notificationChannelName => 'Gentili promemoria';

  @override
  String get notificationChannelDescription =>
      'Promemoria e suggerimenti opzionali di pulizia.';

  @override
  String get notificationReminderTitle => 'Tempo per una breve uscita?';

  @override
  String get notificationReminderBodyInactive =>
      'Se ti va: una breve pulizia fa una differenza visibile.';

  @override
  String get notificationReminderBodyActive =>
      'Voglia di una breve passeggiata di pulizia? Senza alcuna pressione.';

  @override
  String get notificationExpiredTitle => 'Sessione di pulizia terminata';

  @override
  String get notificationExpiredBody =>
      'La tua sessione aperta è stata conclusa dopo il tempo impostato.';

  @override
  String get vessel_city_label => 'Città';

  @override
  String get vessel_river_label => 'Sponda del fiume';

  @override
  String get vessel_forest_label => 'Sentiero nel bosco';

  @override
  String get vessel_parking_label => 'Parcheggio';

  @override
  String get vessel_add_tooltip => 'Aggiungi un mozzicone';

  @override
  String get vessel_remove_tooltip => 'Rimuovi un mozzicone';

  @override
  String get quest_daily_10_title => 'Raccogli 10 mozziconi oggi';

  @override
  String get quest_daily_25_title => 'Raccogli 25 mozziconi oggi';

  @override
  String get quest_session_1_title => 'Completa una sessione di pulizia';

  @override
  String get quest_weekly_75_title => 'Obiettivo settimanale: 75 mozziconi';

  @override
  String get quest_weekly_3_title => 'Obiettivo settimanale: 3 sessioni';

  @override
  String get sessionInactivityTitle => 'Stai ancora raccogliendo?';

  @override
  String get sessionInactivityBody =>
      'La tua sessione di pulizia e inattiva da due ore. Vuoi terminarla ora?';

  @override
  String get sessionInactivityContinue => 'Continua a raccogliere';

  @override
  String get sessionInactivityEnd => 'Termina sessione';

  @override
  String get notificationSessionCheckTitle => 'Stai ancora raccogliendo?';

  @override
  String get notificationSessionCheckBody =>
      'La tua sessione di pulizia e ancora aperta. Tocca qui per continuarla.';
}
