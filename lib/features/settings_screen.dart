part of 'screens.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  Future<void> _update(
    WidgetRef ref,
    AppPreference current,
    AppPreferencesCompanion update,
  ) => ref
      .read(databaseProvider)
      .into(ref.read(databaseProvider).appPreferences)
      .insertOnConflictUpdate(update);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider).value;
    final engagement = ref.watch(engagementSettingsProvider).value;
    final sync = ref.watch(syncStatusProvider).value;
    if (settings == null)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [
          Text(l10n.settingsCategoryAppearance, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: Text(l10n.settingsThemeMode),
                  trailing: DropdownButton<String>(
                    value: settings.themeMode,
                    underline: const SizedBox.shrink(),
                    items: [
                      DropdownMenuItem(value: 'system', child: Text(l10n.settingsThemeSystem)),
                      DropdownMenuItem(value: 'light', child: Text(l10n.settingsThemeLight)),
                      DropdownMenuItem(value: 'dark', child: Text(l10n.settingsThemeDark)),
                    ],
                    onChanged: (value) {
                      if (value != null)
                        _update(
                          ref,
                          settings,
                          AppPreferencesCompanion(
                            id: const Value(1),
                            themeMode: Value(value),
                          ),
                        );
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: Text(l10n.settingsLanguage),
                  trailing: DropdownButton<String>(
                    value: settings.locale ?? Localizations.localeOf(context).languageCode,
                    underline: const SizedBox.shrink(),
                    items: [
                      DropdownMenuItem(value: 'en', child: Text(l10n.settingsLanguageEn)),
                      DropdownMenuItem(value: 'de', child: Text(l10n.settingsLanguageDe)),
                      DropdownMenuItem(value: 'fr', child: Text(l10n.settingsLanguageFr)),
                      DropdownMenuItem(value: 'it', child: Text(l10n.settingsLanguageIt)),
                    ],
                    onChanged: (value) {
                      if (value != null)
                        _update(
                          ref,
                          settings,
                          AppPreferencesCompanion(
                            id: const Value(1),
                            locale: Value(value),
                          ),
                        );
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.landscape_outlined),
                  title: Text(l10n.settingsContainerStyle),
                  subtitle: Text(l10n.settingsContainerStyleSubtitle),
                  trailing: DropdownButton<String>(
                    value: settings.containerStyle,
                    underline: const SizedBox.shrink(),
                    items: [
                      for (final entry in containerStyleLabels(context).entries)
                        DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      _update(
                        ref,
                        settings,
                        AppPreferencesCompanion(
                          id: const Value(1),
                          containerStyle: Value(value),
                        ),
                      );
                    },
                  ),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.auto_awesome_rounded),
                  title: Text(l10n.settingsVisualEffects),
                  subtitle: Text(l10n.settingsVisualEffectsSubtitle),
                  value: settings.environmentEffectsEnabled,
                  onChanged: (value) => _update(
                    ref,
                    settings,
                    AppPreferencesCompanion(
                      id: const Value(1),
                      environmentEffectsEnabled: Value(value),
                    ),
                  ),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.motion_photos_off_rounded),
                  title: Text(l10n.settingsReducedMotion),
                  value: settings.reducedMotion,
                  onChanged: (value) => _update(
                    ref,
                    settings,
                    AppPreferencesCompanion(
                      id: const Value(1),
                      reducedMotion: Value(value),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.settingsCategoryFeedback, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.touch_app_rounded),
              title: Text(l10n.settingsHaptics),
              value: settings.hapticsEnabled,
              onChanged: (value) => _update(
                ref,
                settings,
                AppPreferencesCompanion(
                  id: const Value(1),
                  hapticsEnabled: Value(value),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.settingsCategoryNotifications,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.timer_outlined),
                  title: Text(l10n.settingsSessionLimit),
                  subtitle: Text(l10n.settingsSessionLimitSubtitle),
                  trailing: DropdownButton<int>(
                    value: engagement?.timeoutMinutes ?? 120,
                    underline: const SizedBox.shrink(),
                    items: [
                      DropdownMenuItem(value: 30, child: Text(l10n.settingsMinutes(30))),
                      DropdownMenuItem(value: 60, child: Text(l10n.settingsHour)),
                      DropdownMenuItem(value: 120, child: Text(l10n.settingsHours(2))),
                      DropdownMenuItem(value: 240, child: Text(l10n.settingsHours(4))),
                    ],
                    onChanged: (value) async {
                      if (value == null) return;
                      await ref
                          .read(engagementPreferencesProvider)
                          .setTimeoutMinutes(value);
                      ref.invalidate(engagementSettingsProvider);
                    },
                  ),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_none_rounded),
                  title: Text(l10n.settingsReminders),
                  subtitle: Text(l10n.settingsRemindersSubtitle),
                  value: engagement?.remindersEnabled ?? false,
                  onChanged: (value) async {
                    final reminders = ref.read(reminderCoordinatorProvider);
                    final enabled = value ? await reminders.enable() : true;
                    if (!value) await reminders.disable();
                    if (!enabled && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.settingsNotificationsDenied),
                        ),
                      );
                    }
                    ref.invalidate(engagementSettingsProvider);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.settingsCategoryData, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.cloud_sync_outlined),
                  title: Text(l10n.settingsSyncTitle),
                  subtitle: Text(_syncSubtitle(context, sync)),
                  trailing: sync?.isSyncing == true
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.sync_rounded),
                  onTap: sync?.isSignedIn == true
                      ? () => ref.read(syncCoordinatorProvider).flush()
                      : null,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: Text(l10n.settingsCloudPhotos),
                  subtitle: Text(l10n.settingsCloudPhotosSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/cloud-photos'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _syncSubtitle(BuildContext context, SyncStatus? status) {
    final l10n = AppLocalizations.of(context)!;
    if (status == null || !status.isSignedIn) {
      return l10n.settingsSyncSignIn;
    }
    if (status.isSyncing) return l10n.settingsSyncing;
    if (status.lastSyncedAt == null) return l10n.settingsSyncNever;
    return l10n.settingsSyncLast(DateFormat('d. MMM, HH:mm', Localizations.localeOf(context).toString()).format(status.lastSyncedAt!));
  }
}
