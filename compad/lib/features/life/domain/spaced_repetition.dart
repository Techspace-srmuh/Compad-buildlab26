import 'dart:math';

class FlashcardReviewResult {
  final int newBox;
  final double newEaseFactor;
  final int newRepetitions;
  final int intervalDays;
  final DateTime nextReviewDate;

  const FlashcardReviewResult({
    required this.newBox,
    required this.newEaseFactor,
    required this.newRepetitions,
    required this.intervalDays,
    required this.nextReviewDate,
  });
}

class SpacedRepetitionEngine {
  /// Hybrid Leitner + SuperMemo SM-2 algorithm
  /// rating: 0..5 (0 = blackout, 3 = pass with effort, 5 = perfect recall)
  static FlashcardReviewResult review({
    required int currentBox,
    required double currentEaseFactor,
    required int currentRepetitions,
    required int rating, // 0 to 5
    DateTime? fromDate,
  }) {
    final now = fromDate ?? DateTime.now();
    int newBox = currentBox;
    double newEaseFactor = currentEaseFactor;
    int newRepetitions = currentRepetitions;
    int intervalDays = 1;

    // SM-2 Ease Factor calculation
    // EF' = EF + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
    newEaseFactor = currentEaseFactor + (0.1 - (5 - rating) * (0.08 + (5 - rating) * 0.02));
    if (newEaseFactor < 1.3) newEaseFactor = 1.3;

    if (rating >= 3) {
      // Successful recall
      if (currentRepetitions == 0) {
        intervalDays = 1;
      } else if (currentRepetitions == 1) {
        intervalDays = 6;
      } else {
        intervalDays = (currentRepetitions * newEaseFactor).round();
      }
      newRepetitions += 1;
      // Advance Leitner box (max 5)
      newBox = min(5, currentBox + 1);
    } else {
      // Failed recall - reset to Box 1, restart interval
      newRepetitions = 0;
      intervalDays = 1;
      newBox = 1;
    }

    final nextReview = now.add(Duration(days: intervalDays));

    return FlashcardReviewResult(
      newBox: newBox,
      newEaseFactor: double.parse(newEaseFactor.toStringAsFixed(2)),
      newRepetitions: newRepetitions,
      intervalDays: intervalDays,
      nextReviewDate: nextReview,
    );
  }
}
