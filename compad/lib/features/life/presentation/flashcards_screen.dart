import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/theme/app_theme.dart';
import '../../../core/database/app_database.dart';
import '../../../main.dart';
import '../../../shared/components/compad_card.dart';
import '../domain/spaced_repetition.dart';

class FlashcardsScreen extends ConsumerStatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  ConsumerState<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends ConsumerState<FlashcardsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedDeck = 'All';
  int _studyIndex = 0;
  bool _isAnswerRevealed = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddCardDialog(BuildContext context, AppDatabase db, List<String> existingDecks) {
    final deckCtrl = TextEditingController(text: existingDecks.isNotEmpty && existingDecks.first != 'All' ? existingDecks.first : 'Academics');
    final questionCtrl = TextEditingController();
    final answerCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add Flashcard',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: deckCtrl,
                decoration: const InputDecoration(
                  labelText: 'Subject / Deck Name (e.g. Data Structures, OS)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: questionCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Front / Question',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: answerCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Back / Answer or Key Formula',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  if (questionCtrl.text.isEmpty || answerCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter both question and answer')),
                    );
                    return;
                  }

                  final id = 'card_${DateTime.now().millisecondsSinceEpoch}';
                  await db.into(db.flashcardsTable).insert(
                        FlashcardsTableCompanion.insert(
                          id: id,
                          deckId: deckCtrl.text.trim().isEmpty ? 'General' : deckCtrl.text.trim(),
                          question: questionCtrl.text.trim(),
                          answer: answerCtrl.text.trim(),
                          box: const drift.Value(1),
                          easeFactor: const drift.Value(2.5),
                          repetitions: const drift.Value(0),
                          nextReviewDate: DateTime.now(),
                        ),
                      );

                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: const Text('Save Flashcard', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitReview(AppDatabase db, FlashcardsTableData card, int rating) async {
    final result = SpacedRepetitionEngine.review(
      currentBox: card.box,
      currentEaseFactor: card.easeFactor,
      currentRepetitions: card.repetitions,
      rating: rating,
    );

    await (db.update(db.flashcardsTable)..where((t) => t.id.equals(card.id))).write(
      FlashcardsTableCompanion(
        box: drift.Value(result.newBox),
        easeFactor: drift.Value(result.newEaseFactor),
        repetitions: drift.Value(result.newRepetitions),
        nextReviewDate: drift.Value(result.nextReviewDate),
      ),
    );

    setState(() {
      _isAnswerRevealed = false;
      _studyIndex += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final compadColors = theme.extension<CompadThemeColors>() ??
        (theme.brightness == Brightness.dark ? CompadThemeColors.dark : CompadThemeColors.light);

    final db = ref.watch(appDatabaseProvider);

    return StreamBuilder<List<FlashcardsTableData>>(
      stream: db.select(db.flashcardsTable).watch(),
      builder: (context, snapshot) {
        final allCards = snapshot.data ?? [];
        final decks = {'All', ...allCards.map((c) => c.deckId)}.toList();

        final filteredCards = _selectedDeck == 'All'
            ? allCards
            : allCards.where((c) => c.deckId == _selectedDeck).toList();

        final dueCards = filteredCards
            .where((c) => c.nextReviewDate.isBefore(DateTime.now().add(const Duration(hours: 1))))
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Flashcards & Spaced Repetition'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_rounded),
                tooltip: 'Add Flashcard',
                onPressed: () => _showAddCardDialog(context, db, decks),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Cards & Decks (${filteredCards.length})', icon: const Icon(Icons.style_rounded, size: 20)),
                Tab(text: 'Study Mode (${dueCards.length} Due)', icon: const Icon(Icons.psychology_rounded, size: 20)),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildCardsListTab(allCards, filteredCards, decks, compadColors, colorScheme, db),
              _buildStudyTab(dueCards, compadColors, colorScheme, db),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddCardDialog(context, db, decks),
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            icon: const Icon(Icons.add_rounded),
            label: const Text('New Card'),
          ),
        );
      },
    );
  }

  Widget _buildCardsListTab(
    List<FlashcardsTableData> allCards,
    List<FlashcardsTableData> cards,
    List<String> decks,
    CompadThemeColors compadColors,
    ColorScheme colorScheme,
    AppDatabase db,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // SUMMARY BANNER
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  compadColors.lifeTint,
                  compadColors.lifeTint.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: compadColors.lifeTint.withValues(alpha: 0.3),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.white24,
                  child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Leitner SM-2 Mastery Engine',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total: ${allCards.length} cards across ${decks.length - 1} deck(s). Reviews scheduled automatically.',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // DECK FILTER CHIPS
          if (decks.length > 1) ...[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: decks.map((deck) {
                  final isSelected = _selectedDeck == deck;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(deck),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() {
                          _selectedDeck = deck;
                          _studyIndex = 0;
                          _isAnswerRevealed = false;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],

          if (cards.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: CompadCard(
                padding: const EdgeInsets.all(28),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.style_outlined, size: 52, color: compadColors.subtext),
                      const SizedBox(height: 12),
                      const Text(
                        'No flashcards yet',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Create question & answer flashcards to memorize definitions, formulas, and diagrams using spaced repetition.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: compadColors.subtext),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _showAddCardDialog(context, db, decks),
                        icon: const Icon(Icons.add),
                        label: const Text('Add First Card'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            ...cards.map((card) => _buildCardTile(card, compadColors, colorScheme, db)),
        ],
      ),
    );
  }

  Widget _buildCardTile(
    FlashcardsTableData card,
    CompadThemeColors compadColors,
    ColorScheme colorScheme,
    AppDatabase db,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CompadCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: compadColors.lifeTint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    card.deckId,
                    style: TextStyle(
                      color: compadColors.lifeTint,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Box ${card.box} / 5',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  onPressed: () async {
                    await (db.delete(db.flashcardsTable)..where((t) => t.id.equals(card.id))).go();
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Q: ${card.question}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(
              'A: ${card.answer}',
              style: TextStyle(fontSize: 13, color: compadColors.subtext),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyTab(
    List<FlashcardsTableData> dueCards,
    CompadThemeColors compadColors,
    ColorScheme colorScheme,
    AppDatabase db,
  ) {
    if (dueCards.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline_rounded, size: 60, color: compadColors.success),
              const SizedBox(height: 16),
              const Text(
                'All caught up for today!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'No flashcards due right now. You can add more cards or check back tomorrow.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: compadColors.subtext),
              ),
            ],
          ),
        ),
      );
    }

    final currentIndex = _studyIndex % dueCards.length;
    final card = dueCards[currentIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Card ${currentIndex + 1} of ${dueCards.length}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: compadColors.lifeTint.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  card.deckId,
                  style: TextStyle(color: compadColors.lifeTint, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // STUDY CARD FLIPPER
          InkWell(
            onTap: () {
              setState(() => _isAnswerRevealed = !_isAnswerRevealed);
            },
            borderRadius: BorderRadius.circular(24),
            child: Container(
              constraints: const BoxConstraints(minHeight: 220),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isAnswerRevealed ? 'ANSWER' : 'QUESTION',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      color: _isAnswerRevealed ? compadColors.success : compadColors.lifeTint,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _isAnswerRevealed ? card.answer : card.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.4),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _isAnswerRevealed ? 'Tap to hide answer' : 'Tap to reveal answer',
                    style: TextStyle(fontSize: 12, color: compadColors.subtext),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // RATING BUTTONS (Appears when answer is revealed!)
          if (_isAnswerRevealed) ...[
            const Text(
              'How well did you know this?',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withValues(alpha: 0.15),
                      foregroundColor: Colors.red,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => _submitReview(db, card, 1),
                    child: const Text('Again\n(Box 1)', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.withValues(alpha: 0.15),
                      foregroundColor: Colors.orange,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => _submitReview(db, card, 3),
                    child: const Text('Hard\n(+1 day)', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.withValues(alpha: 0.15),
                      foregroundColor: Colors.green,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => _submitReview(db, card, 4),
                    child: const Text('Good\n(+3 days)', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.withValues(alpha: 0.15),
                      foregroundColor: Colors.blue,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => _submitReview(db, card, 5),
                    child: const Text('Easy\n(+6 days)', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ] else
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => setState(() => _isAnswerRevealed = true),
              icon: const Icon(Icons.visibility_rounded),
              label: const Text('Reveal Answer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
        ],
      ),
    );
  }
}
