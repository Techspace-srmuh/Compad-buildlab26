import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/sharing_history_repository.dart';
import '../models/sharing_history_model.dart';

class SharingHistoryState {
  final bool isLoading;
  final List<SharingHistoryModel> history;
  final String? errorMessage;

  const SharingHistoryState({
    this.isLoading = true,
    this.history = const [],
    this.errorMessage,
  });

  SharingHistoryState copyWith({
    bool? isLoading,
    List<SharingHistoryModel>? history,
    String? errorMessage,
  }) {
    return SharingHistoryState(
      isLoading: isLoading ?? this.isLoading,
      history: history ?? this.history,
      errorMessage: errorMessage,
    );
  }
}

class SharingHistoryController extends StateNotifier<SharingHistoryState> {
  final SharingHistoryRepository _repository = SharingHistoryRepository();

  SharingHistoryController() : super(const SharingHistoryState()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final history = await _repository.getHistory();
      state = state.copyWith(isLoading: false, history: history);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> logTransfer({
    required String title,
    required String payloadType,
    required String direction,
    required String transport,
    required String peerInfo,
    required int itemCount,
    String? rawJson,
  }) async {
    final item = SharingHistoryModel(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      payloadType: payloadType,
      direction: direction,
      transport: transport,
      peerInfo: peerInfo,
      timestamp: DateTime.now().toIso8601String(),
      itemCount: itemCount,
      rawJson: rawJson,
    );
    await _repository.addHistoryItem(item);
    await loadHistory();
  }

  Future<void> deleteItem(String id) async {
    await _repository.deleteHistoryItem(id);
    await loadHistory();
  }

  Future<void> clearAll() async {
    await _repository.clearAllHistory();
    await loadHistory();
  }
}

final sharingHistoryControllerProvider =
    StateNotifierProvider<SharingHistoryController, SharingHistoryState>((ref) {
  return SharingHistoryController();
});
