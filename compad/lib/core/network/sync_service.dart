import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import '../database/app_database.dart';

abstract class RemoteSyncClient {
  Future<bool> pushItem({
    required String entityType,
    required String action,
    required Map<String, dynamic> payload,
  });

  Future<Map<String, dynamic>?> fetchUpdates({
    required String entityType,
    required DateTime since,
  });
}

class MockRemoteSyncClient implements RemoteSyncClient {
  @override
  Future<bool> pushItem({
    required String entityType,
    required String action,
    required Map<String, dynamic> payload,
  }) async {
    // Simulate remote network delay
    await Future.delayed(const Duration(milliseconds: 300));
    // In mock mode, pretend remote sync succeeds 100% of the time when called
    debugPrint('[RemoteSync] Synced $entityType ($action): ${payload['id'] ?? ''}');
    return true;
  }

  @override
  Future<Map<String, dynamic>?> fetchUpdates({
    required String entityType,
    required DateTime since,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {};
  }
}

class SyncService {
  final AppDatabase db;
  final RemoteSyncClient remoteClient;
  bool _isSyncing = false;
  Timer? _periodicTimer;

  SyncService({
    required this.db,
    RemoteSyncClient? client,
  }) : remoteClient = client ?? MockRemoteSyncClient();

  void startSyncWorker({Duration interval = const Duration(seconds: 30)}) {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(interval, (_) => syncOutbox());
  }

  void stopSyncWorker() {
    _periodicTimer?.cancel();
  }

  /// Appends an action to the outbox queue
  Future<void> enqueue({
    required String entityType,
    required String action,
    required Map<String, dynamic> payload,
  }) async {
    final entry = OutboxSyncQueueCompanion.insert(
      id: '${entityType}_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}',
      entityType: entityType,
      action: action,
      payloadJson: jsonEncode(payload),
      status: const Value('PENDING'),
      retryCount: const Value(0),
      createdAt: DateTime.now(),
    );

    await db.into(db.outboxSyncQueue).insert(entry);
    debugPrint('[SyncService] Enqueued $action for $entityType');

    // Attempt immediate sync
    syncOutbox();
  }

  /// Processes all pending outbox entries with exponential backoff
  Future<int> syncOutbox() async {
    if (_isSyncing) return 0;
    _isSyncing = true;
    int syncedCount = 0;

    try {
      final now = DateTime.now();
      // Select items where status is PENDING or nextRetryAt <= now
      final pendingItems = await (db.select(db.outboxSyncQueue)
            ..where((tbl) => tbl.status.equals('PENDING'))
            ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]))
          .get();

      for (final item in pendingItems) {
        if (item.nextRetryAt != null && item.nextRetryAt!.isAfter(now)) {
          continue; // Waiting for backoff duration
        }

        try {
          final payload = jsonDecode(item.payloadJson) as Map<String, dynamic>;
          final success = await remoteClient.pushItem(
            entityType: item.entityType,
            action: item.action,
            payload: payload,
          );

          if (success) {
            // Delete from outbox once synced
            await (db.delete(db.outboxSyncQueue)..where((tbl) => tbl.id.equals(item.id))).go();
            syncedCount++;
          } else {
            _handleSyncFailure(item);
          }
        } catch (e) {
          debugPrint('[SyncService] Error syncing item ${item.id}: $e');
          _handleSyncFailure(item);
        }
      }
    } finally {
      _isSyncing = false;
    }

    return syncedCount;
  }

  Future<void> _handleSyncFailure(OutboxSyncQueueData item) async {
    final nextRetryCount = item.retryCount + 1;
    // Exponential backoff: 2^retryCount * 5 seconds (max 10 minutes)
    final backoffSeconds = min(600, pow(2, nextRetryCount) * 5).toInt();
    final nextRetryTime = DateTime.now().add(Duration(seconds: backoffSeconds));

    await (db.update(db.outboxSyncQueue)..where((tbl) => tbl.id.equals(item.id))).write(
      OutboxSyncQueueCompanion(
        retryCount: Value(nextRetryCount),
        nextRetryAt: Value(nextRetryTime),
        status: const Value('PENDING'),
      ),
    );
  }
}
