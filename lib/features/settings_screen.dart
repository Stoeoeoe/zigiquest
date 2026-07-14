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
    final settings = ref.watch(settingsProvider).value;
    final engagement = ref.watch(engagementSettingsProvider).value;
    final sync = ref.watch(syncStatusProvider).value;
    if (settings == null)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [
          Text('DARSTELLUNG', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: const Text('Erscheinungsbild'),
                  trailing: DropdownButton<String>(
                    value: settings.themeMode,
                    underline: const SizedBox.shrink(),
                    items: const [
                      DropdownMenuItem(value: 'system', child: Text('System')),
                      DropdownMenuItem(value: 'light', child: Text('Hell')),
                      DropdownMenuItem(value: 'dark', child: Text('Dunkel')),
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
                  leading: const Icon(Icons.landscape_outlined),
                  title: const Text('Umgebung im Glas'),
                  subtitle: const Text(
                    'Wähle einen Cleanup-Ort als Hintergrund.',
                  ),
                  trailing: DropdownButton<String>(
                    value: settings.containerStyle,
                    underline: const SizedBox.shrink(),
                    items: [
                      for (final entry in containerStyleLabels.entries)
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
                  title: const Text('Visuelle Effekte'),
                  subtitle: const Text(
                    'Szenen-Atmosphäre, Glasglitzer und Zigi-Partikel.',
                  ),
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
                  title: const Text('Reduzierte Bewegung'),
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
          Text('FEEDBACK', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.touch_app_rounded),
              title: const Text('Haptik'),
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
            'BENACHRICHTIGUNGEN',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.timer_outlined),
                  title: const Text('Session-Limit'),
                  subtitle: const Text(
                    'Offene Sessions werden danach sicher abgeschlossen.',
                  ),
                  trailing: DropdownButton<int>(
                    value: engagement?.timeoutMinutes ?? 120,
                    underline: const SizedBox.shrink(),
                    items: const [
                      DropdownMenuItem(value: 30, child: Text('30 Min.')),
                      DropdownMenuItem(value: 60, child: Text('1 Stunde')),
                      DropdownMenuItem(value: 120, child: Text('2 Stunden')),
                      DropdownMenuItem(value: 240, child: Text('4 Stunden')),
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
                  title: const Text('Sanfte Cleanup-Erinnerungen'),
                  subtitle: const Text(
                    'Optional: wöchentlich, bei längerer Pause monatlich.',
                  ),
                  value: engagement?.remindersEnabled ?? false,
                  onChanged: (value) async {
                    final reminders = ref.read(reminderCoordinatorProvider);
                    final enabled = value ? await reminders.enable() : true;
                    if (!value) await reminders.disable();
                    if (!enabled && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Benachrichtigungen wurden nicht erlaubt.',
                          ),
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
          Text('DATEN', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.cloud_sync_outlined),
                  title: const Text('Datensynchronisierung'),
                  subtitle: Text(_syncSubtitle(sync)),
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
                  title: const Text('Private Cloud-Fotos'),
                  subtitle: const Text('Deine gesicherten Session-Fotos'),
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

  String _syncSubtitle(SyncStatus? status) {
    if (status == null || !status.isSignedIn) {
      return 'Melde dich an, um deine Daten zu sichern.';
    }
    if (status.isSyncing) return 'Wird synchronisiert ...';
    if (status.lastSyncedAt == null) return 'Noch nicht synchronisiert';
    return 'Zuletzt synchronisiert: ${DateFormat('d. MMM, HH:mm', 'de_CH').format(status.lastSyncedAt!)}';
  }
}
