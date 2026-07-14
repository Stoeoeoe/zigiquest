class SyncStatus {
  const SyncStatus({
    required this.isSignedIn,
    this.isSyncing = false,
    this.lastSyncedAt,
    this.lastError,
  });

  final bool isSignedIn;
  final bool isSyncing;
  final DateTime? lastSyncedAt;
  final String? lastError;

  SyncStatus copyWith({
    bool? isSignedIn,
    bool? isSyncing,
    DateTime? lastSyncedAt,
    String? lastError,
    bool clearError = false,
  }) => SyncStatus(
    isSignedIn: isSignedIn ?? this.isSignedIn,
    isSyncing: isSyncing ?? this.isSyncing,
    lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    lastError: clearError ? null : lastError ?? this.lastError,
  );
}
