import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/note_repository.dart';
import '../models/note_model.dart';

class NoteState {
  final bool isLoading;
  final List<NoteModel> notes;
  final NoteModel? activeNote;
  final String? errorMessage;

  const NoteState({
    this.isLoading = true,
    this.notes = const [],
    this.activeNote,
    this.errorMessage,
  });

  NoteState copyWith({
    bool? isLoading,
    List<NoteModel>? notes,
    NoteModel? activeNote,
    String? errorMessage,
  }) {
    return NoteState(
      isLoading: isLoading ?? this.isLoading,
      notes: notes ?? this.notes,
      activeNote: activeNote,
      errorMessage: errorMessage,
    );
  }
}

class NoteController extends StateNotifier<NoteState> {
  final NoteRepository _repository = NoteRepository();

  NoteController() : super(const NoteState()) {
    loadNotes();
  }

  Future<void> loadNotes() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final notes = await _repository.getNotes();
      state = state.copyWith(isLoading: false, notes: notes);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void setActiveNote(NoteModel? note) {
    state = state.copyWith(activeNote: note);
  }

  Future<void> saveNote({
    String? id,
    required String title,
    required String content,
  }) async {
    final noteId = id ?? 'note_${DateTime.now().millisecondsSinceEpoch}';
    final note = NoteModel(
      id: noteId,
      title: title.isEmpty ? 'Untitled Note' : title,
      content: content,
      updatedAt: DateTime.now(),
    );
    await _repository.saveNote(note);
    await loadNotes();
    state = state.copyWith(activeNote: note);
  }

  Future<void> deleteNote(String id) async {
    await _repository.deleteNote(id);
    if (state.activeNote?.id == id) {
      state = state.copyWith(activeNote: null);
    }
    await loadNotes();
  }
}

final noteControllerProvider =
    StateNotifierProvider<NoteController, NoteState>((ref) {
  return NoteController();
});
