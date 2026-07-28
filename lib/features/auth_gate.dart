import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/app_database.dart';
import '../core/services/auth_service.dart';
import '../l10n/app_localizations.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authUserProvider);
    final guestMode = ref.watch(guestModeProvider);
    final onboarding = ref.watch(onboardingCompletedProvider);
    if (user.isLoading || guestMode.isLoading || onboarding.isLoading) {
      return const _LaunchScreen();
    }
    if (user.value != null || guestMode.value == true) {
      return onboarding.value == true ? child : const SetupScreen();
    }
    return const WelcomeScreen();
  }
}

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _working = false;
  bool _showAccountChoice = false;

  Future<void> _signIn() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _working = true);
    try {
      await ref.read(authServiceProvider).signInWithGoogle();
    } on AuthConfigurationException {
      if (mounted) {
        _message(l10n.authErrorConfig);
      }
    } catch (_) {
      if (mounted) _message(l10n.authErrorGoogle);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _continueAsGuest() async {
    setState(() => _working = true);
    await ref.read(authServiceProvider).continueAsGuest();
    ref.invalidate(guestModeProvider);
    if (mounted) setState(() => _working = false);
  }

  void _message(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (!_showAccountChoice) {
      return _HowItWorksScreen(
        onContinue: () => setState(() => _showAccountChoice = true),
      );
    }
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colors.primaryContainer, colors.surface],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 104,
                      height: 104,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(34),
                        boxShadow: [
                          BoxShadow(
                            color: colors.primary.withValues(alpha: .32),
                            blurRadius: 28,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/branding/zigiquest_app_icon.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      l10n.welcomeTitle,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.welcomeSubtitle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.welcomeAccountInfoTitle,
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 6),
                            Text(l10n.welcomeAccountInfoBody),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _working ? null : _signIn,
                      icon: const Icon(Icons.login_rounded),
                      label: Text(l10n.welcomeGoogleSignIn),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _working ? null : _continueAsGuest,
                      icon: const Icon(Icons.person_outline_rounded),
                      label: Text(l10n.welcomeContinueGuest),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.welcomeFooter,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HowItWorksScreen extends StatelessWidget {
  const _HowItWorksScreen({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colors.primaryContainer, colors.surface],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.cleaning_services_rounded,
                      color: colors.primary,
                      size: 62,
                    ),
                    const SizedBox(height: 22),
                    Text(
                      l10n.howItWorksTitle,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.howItWorksSubtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _HowItWorksStep(
                      icon: Icons.touch_app_rounded,
                      title: l10n.howItWorksQuickLogTitle,
                      body: l10n.howItWorksQuickLogBody,
                    ),
                    const SizedBox(height: 12),
                    _HowItWorksStep(
                      icon: Icons.timer_outlined,
                      title: l10n.howItWorksSessionTitle,
                      body: l10n.howItWorksSessionBody,
                    ),
                    const SizedBox(height: 12),
                    _HowItWorksStep(
                      icon: Icons.insights_rounded,
                      title: l10n.howItWorksHistoryTitle,
                      body: l10n.howItWorksHistoryBody,
                    ),
                    const SizedBox(height: 30),
                    FilledButton.icon(
                      onPressed: onContinue,
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: Text(l10n.continueLabel),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HowItWorksStep extends StatelessWidget {
  const _HowItWorksStep({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 3),
                Text(body),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  String _themeMode = 'system';
  bool _haptics = true;
  final bool _sound = false;
  bool _reducedMotion = false;
  bool _cloudBackup = false;
  bool _saving = false;

  Future<void> _finish() async {
    setState(() => _saving = true);
    final database = ref.read(databaseProvider);
    try {
      await database
          .into(database.appPreferences)
          .insertOnConflictUpdate(
            AppPreferencesCompanion(
              id: const Value(1),
              themeMode: Value(_themeMode),
              hapticsEnabled: Value(_haptics),
              soundEnabled: Value(_sound),
              reducedMotion: Value(_reducedMotion),
              cloudPhotoBackup: Value(_cloudBackup),
            ),
          );
      await ref.read(authServiceProvider).completeOnboarding();
      ref.invalidate(onboardingCompletedProvider);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final signedIn = ref.watch(authUserProvider).value != null;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.setupTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.tune_rounded, color: colors.onPrimaryContainer),
                  const SizedBox(height: 10),
                  Text(
                    l10n.setupHeroTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(l10n.setupHeroBody),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(l10n.setupCategoryAppearance, style: Theme.of(context).textTheme.labelLarge),
            Card(
              child: Column(
                children: [
                  RadioGroup<String>(
                    groupValue: _themeMode,
                    onChanged: (value) {
                      if (value != null) setState(() => _themeMode = value);
                    },
                    child: Column(
                      children: [
                        RadioListTile(
                          value: 'system',
                          title: Text(l10n.setupThemeSystem),
                        ),
                        RadioListTile(value: 'light', title: Text(l10n.setupThemeLight)),
                        RadioListTile(value: 'dark', title: Text(l10n.setupThemeDark)),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.motion_photos_off_rounded),
                    title: Text(l10n.setupReducedMotionTitle),
                    subtitle: Text(l10n.setupReducedMotionBody),
                    value: _reducedMotion,
                    onChanged: (value) =>
                        setState(() => _reducedMotion = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(l10n.setupCategoryFeedback, style: Theme.of(context).textTheme.labelLarge),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.touch_app_rounded),
                    title: Text(l10n.setupHapticsTitle),
                    subtitle: Text(l10n.setupHapticsBody),
                    value: _haptics,
                    onChanged: (value) => setState(() => _haptics = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(l10n.setupCategoryPrivacy, style: Theme.of(context).textTheme.labelLarge),
            Card(
              child: SwitchListTile(
                secondary: const Icon(Icons.cloud_upload_rounded),
                title: Text(l10n.setupCloudBackupTitle),
                subtitle: Text(
                  signedIn
                      ? l10n.setupCloudBackupBody
                      : l10n.setupCloudBackupGuestBody,
                ),
                value: _cloudBackup,
                onChanged: signedIn
                    ? (value) => setState(() => _cloudBackup = value)
                    : null,
              ),
            ),
            const SizedBox(height: 26),
            FilledButton.icon(
              onPressed: _saving ? null : _finish,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(l10n.setupFinish),
            ),
          ],
        ),
      ),
    );
  }
}

class _LaunchScreen extends StatelessWidget {
  const _LaunchScreen();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}
