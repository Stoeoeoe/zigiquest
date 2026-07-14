import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';
import 'supabase_bootstrap.dart';
import 'sync_service.dart';
import 'sync_status.dart';

class SyncCoordinator with WidgetsBindingObserver {
  SyncCoordinator(this._database, this._client);
  final AppDatabase _database;
  final SupabaseClient? _client;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  final _statusController = StreamController<SyncStatus>.broadcast();
  SyncStatus _status = const SyncStatus(isSignedIn: false);
  bool _flushing = false;

  Stream<SyncStatus> get status async* {
    yield _status;
    yield* _statusController.stream;
  }

  void _setStatus(SyncStatus value) {
    _status = value;
    if (!_statusController.isClosed) _statusController.add(value);
  }

  void start() {
    WidgetsBinding.instance.addObserver(this);
    _subscription ??= Connectivity().onConnectivityChanged.listen((results) {
      if (!results.contains(ConnectivityResult.none)) flush();
    });
    unawaited(_restoreLastSuccess().whenComplete(flush));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) flush();
  }

  Future<int> flush() async {
    if (_flushing) return 0;
    final userId = _client?.auth.currentUser?.id;
    if (userId == null) {
      _setStatus(const SyncStatus(isSignedIn: false));
      return 0;
    }
    _flushing = true;
    _setStatus(_status.copyWith(isSignedIn: true, isSyncing: true));
    try {
      final result = await SyncService(_database, _client).synchronize();
      final now = DateTime.now();
      await SharedPreferencesAsync().setString(
        _lastSyncKey(userId),
        now.toUtc().toIso8601String(),
      );
      _setStatus(
        _status.copyWith(
          isSignedIn: true,
          isSyncing: false,
          lastSyncedAt: now,
          clearError: true,
        ),
      );
      return result.uploaded;
    } catch (error) {
      _setStatus(
        _status.copyWith(
          isSignedIn: true,
          isSyncing: false,
          lastError: '$error',
        ),
      );
      return 0;
    } finally {
      _flushing = false;
    }
  }

  Future<void> _restoreLastSuccess() async {
    final userId = _client?.auth.currentUser?.id;
    if (userId == null) return;
    final value = await SharedPreferencesAsync().getString(
      _lastSyncKey(userId),
    );
    final parsed = value == null ? null : DateTime.tryParse(value)?.toLocal();
    _setStatus(_status.copyWith(isSignedIn: true, lastSyncedAt: parsed));
  }

  String _lastSyncKey(String userId) => 'sync.last_success.$userId';

  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    await _subscription?.cancel();
    await _statusController.close();
  }
}

final syncCoordinatorProvider = Provider<SyncCoordinator>((ref) {
  final coordinator = SyncCoordinator(
    ref.watch(databaseProvider),
    configuredSupabase(),
  );
  coordinator.start();
  ref.onDispose(coordinator.dispose);
  return coordinator;
});

final syncStatusProvider = StreamProvider<SyncStatus>(
  (ref) => ref.watch(syncCoordinatorProvider).status,
);
