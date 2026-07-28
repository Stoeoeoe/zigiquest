import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/database/app_database.dart';
import '../core/services/sync_coordinator.dart';
import '../features/auth_gate.dart';
import '../features/achievements_screen.dart';
import '../features/community_screen.dart';
import '../features/discover_screen.dart';
import '../features/remote_photos_screen.dart';
import '../features/screens.dart';
import '../l10n/app_localizations.dart';

final settingsProvider = StreamProvider<AppPreference>(
  (ref) => ref.watch(databaseProvider).watchSettings(),
);

final router = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => HomeShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: '/', builder: (_, _) => const TodayScreen())],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/history', builder: (_, _) => const HistoryScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/quests', builder: (_, _) => const QuestsScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/discover',
              builder: (_, _) => const DiscoverScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (_, _) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
    GoRoute(path: '/discover', builder: (_, _) => const DiscoverScreen()),
    GoRoute(path: '/community', builder: (_, _) => const CommunityScreen()),
    GoRoute(
      path: '/achievements',
      builder: (_, _) => const AchievementsScreen(),
    ),
    GoRoute(path: '/session', builder: (_, _) => const LiveSessionScreen()),
    GoRoute(
      path: '/cloud-photos',
      builder: (_, _) => const RemotePhotosScreen(),
    ),
  ],
);

class ZigiQuestApp extends ConsumerWidget {
  const ZigiQuestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(syncCoordinatorProvider);
    final settings = ref.watch(settingsProvider).value;
    final mode = switch (settings?.themeMode) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: settings?.locale != null ? Locale(settings!.locale!) : null,
      debugShowCheckedModeBanner: false,
      themeMode: mode,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      builder: (context, child) =>
          AuthGate(child: child ?? const SizedBox.shrink()),
      routerConfig: router,
    );
  }

  ThemeData _theme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final colors = ColorScheme.fromSeed(
      seedColor: dark ? const Color(0xff61d6a5) : const Color(0xff08765b),
      brightness: brightness,
      primary: dark ? const Color(0xff72ddb1) : const Color(0xff08765b),
      secondary: dark ? const Color(0xffffc374) : const Color(0xffdc7d28),
      tertiary: dark ? const Color(0xffffa985) : const Color(0xffb4482e),
      surface: dark ? const Color(0xff111a17) : const Color(0xfff8fbf6),
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
    );
    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        displayLarge: base.textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: -2.2,
        ),
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -.6,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          color: colors.onSurface,
          fontWeight: FontWeight.w900,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colors.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: colors.outlineVariant.withValues(alpha: .55)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: colors.surfaceContainerLow,
        indicatorColor: colors.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
          ),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
        linearTrackColor: colors.surfaceContainerHighest,
        linearMinHeight: 8,
        borderRadius: BorderRadius.circular(99),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
        side: BorderSide(color: colors.outlineVariant),
        labelStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class HomeShell extends StatelessWidget {
  const HomeShell({required this.shell, super.key});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: shell,
    bottomNavigationBar: NavigationBar(
      selectedIndex: shell.currentIndex,
      onDestinationSelected: (index) =>
          shell.goBranch(index, initialLocation: index == shell.currentIndex),
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.wb_sunny_outlined),
          selectedIcon: const Icon(Icons.wb_sunny_rounded),
          label: AppLocalizations.of(context)!.navToday,
        ),
        NavigationDestination(
          icon: const Icon(Icons.insights_outlined),
          selectedIcon: const Icon(Icons.insights_rounded),
          label: AppLocalizations.of(context)!.navHistory,
        ),
        NavigationDestination(
          icon: const Icon(Icons.auto_awesome_outlined),
          selectedIcon: const Icon(Icons.auto_awesome),
          label: AppLocalizations.of(context)!.navQuests,
        ),
        NavigationDestination(
          icon: const Icon(Icons.lightbulb_outline_rounded),
          selectedIcon: const Icon(Icons.lightbulb_rounded),
          label: AppLocalizations.of(context)!.navKnowledge,
        ),
        NavigationDestination(
          icon: const Icon(Icons.tune_outlined),
          selectedIcon: const Icon(Icons.tune_rounded),
          label: AppLocalizations.of(context)!.navSettings,
        ),
      ],
    ),
  );
}
