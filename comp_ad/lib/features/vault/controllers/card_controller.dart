import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/card_repository.dart';
import '../models/card_model.dart';

class CardState {
  final bool isLoading;
  final List<CardModel> cards;
  final CardModel? selectedCard;
  final bool isMaxBrightnessOn;
  final String? errorMessage;

  const CardState({
    this.isLoading = true,
    this.cards = const [],
    this.selectedCard,
    this.isMaxBrightnessOn = true,
    this.errorMessage,
  });

  CardState copyWith({
    bool? isLoading,
    List<CardModel>? cards,
    CardModel? selectedCard,
    bool? isMaxBrightnessOn,
    String? errorMessage,
  }) {
    return CardState(
      isLoading: isLoading ?? this.isLoading,
      cards: cards ?? this.cards,
      selectedCard: selectedCard ?? this.selectedCard,
      isMaxBrightnessOn: isMaxBrightnessOn ?? this.isMaxBrightnessOn,
      errorMessage: errorMessage,
    );
  }
}

class CardController extends StateNotifier<CardState> {
  final CardRepository _repository = CardRepository();

  CardController() : super(const CardState()) {
    loadCards();
  }

  Future<void> loadCards() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final cards = await _repository.getCards();
      final initialSelected = cards.isNotEmpty ? cards.first : null;
      state = state.copyWith(
        isLoading: false,
        cards: cards,
        selectedCard: initialSelected,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void selectCard(CardModel card) {
    state = state.copyWith(selectedCard: card);
  }

  void toggleMaxBrightness() {
    state = state.copyWith(isMaxBrightnessOn: !state.isMaxBrightnessOn);
  }

  Future<void> addCard(CardModel card) async {
    await _repository.saveCard(card);
    await loadCards();
    state = state.copyWith(selectedCard: card);
  }

  Future<void> deleteCard(String id) async {
    await _repository.deleteCard(id);
    await loadCards();
  }
}

final cardControllerProvider =
    StateNotifierProvider<CardController, CardState>((ref) {
  return CardController();
});
