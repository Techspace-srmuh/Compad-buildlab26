import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/spatial_colors.dart';
import '../../../core/theme/spatial_neumorphic.dart';
import '../controllers/note_controller.dart';
import '../models/note_model.dart';
import 'note_editor_screen.dart';

class ScratchpadScreen extends ConsumerWidget {
  const ScratchpadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(noteControllerProvider);
    final controller = ref.read(noteControllerProvider.notifier);

    return Scaffold(
      backgroundColor: SpatialColors.canvas,
      body: SafeArea(
        child: state.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: SpatialColors.accentCyan),
              )
            : Stack(
                children: [
                  SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Micro Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'OFFLINE KNOWLEDGE BASE',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                    color: SpatialColors.accentIndigo,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Study Scratchpad',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: SpatialColors.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: SpatialDecorations.inset(
                                radius: 12,
                                base: SpatialColors.surfaceContainerLowest,
                              ),
                              child: Text(
                                '${state.notes.length} Cached Notes',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'JetBrainsMono',
                                  fontWeight: FontWeight.bold,
                                  color: SpatialColors.accentCyan,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Search or Filter Pill Bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: SpatialDecorations.inset(
                            radius: 14,
                            base: SpatialColors.surfaceContainerLowest,
                          ),
                          child: const Row(
                            children: [
                              Icon(LucideIcons.search, size: 16, color: SpatialColors.outline),
                              SizedBox(width: 10),
                              Text(
                                'Search raw UTF-8 notes & snippets...',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: SpatialColors.outline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Notes List
                        if (state.notes.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(32),
                            decoration: SpatialDecorations.raised(radius: 20),
                            child: const Column(
                              children: [
                                Icon(LucideIcons.fileText, size: 40, color: SpatialColors.outline),
                                SizedBox(height: 12),
                                Text(
                                  'Scratchpad Empty',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: SpatialColors.onSurface,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Tap the + button below to create your first encrypted offline markdown note.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12, color: SpatialColors.onSurfaceVariant),
                                ),
                              ],
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.notes.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final note = state.notes[index];
                              return _buildNoteCard(context, note, controller);
                            },
                          ),
                        const SizedBox(height: 90), // Bottom padding for FAB & dock
                      ],
                    ),
                  ),

                  // Floating Neumorphic + New Note Button
                  Positioned(
                    bottom: 96,
                    right: 20,
                    child: GestureDetector(
                      onTap: () => _openNoteEditor(context, null, controller),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: SpatialColors.surfaceContainerHighest,
                          border: Border.all(
                            color: SpatialColors.accentIndigo.withValues(alpha: 0.6),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: SpatialColors.accentIndigo.withValues(alpha: 0.4),
                              blurRadius: 18,
                              offset: const Offset(0, 4),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.7),
                              blurRadius: 16,
                              offset: const Offset(4, 6),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.edit3,
                            size: 24,
                            color: SpatialColors.accentIndigo,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildNoteCard(
    BuildContext context,
    NoteModel note,
    NoteController controller,
  ) {
    final previewText = note.content.replaceAll(RegExp(r'[#*`\->\[\]]'), '').trim();
    final dateString = DateFormat('MMM dd, hh:mm a').format(note.updatedAt);
    final wordCount = note.content.trim().isEmpty
        ? 0
        : note.content.trim().split(RegExp(r'\s+')).length;

    return Dismissible(
      key: Key(note.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: SpatialColors.accentCoral.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(LucideIcons.trash2, color: SpatialColors.accentCoral),
      ),
      onDismissed: (_) => controller.deleteNote(note.id),
      child: GestureDetector(
        onTap: () => _openNoteEditor(context, note, controller),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: SpatialDecorations.raised(
            radius: 18,
            base: SpatialColors.surfaceContainer,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: SpatialColors.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: SpatialColors.accentIndigo.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$wordCount words',
                      style: const TextStyle(
                        fontSize: 10,
                        fontFamily: 'JetBrainsMono',
                        color: SpatialColors.accentIndigo,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                previewText.isEmpty ? 'Empty note...' : previewText,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: SpatialColors.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.clock, size: 12, color: SpatialColors.outline),
                      const SizedBox(width: 4),
                      Text(
                        dateString,
                        style: const TextStyle(
                          fontSize: 11,
                          fontFamily: 'JetBrainsMono',
                          color: SpatialColors.outline,
                        ),
                      ),
                    ],
                  ),
                  const Icon(LucideIcons.chevronRight, size: 16, color: SpatialColors.outline),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openNoteEditor(
    BuildContext context,
    NoteModel? note,
    NoteController controller,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteEditorScreen(
          note: note,
          onSave: (title, content, id) {
            controller.saveNote(title: title, content: content, id: id);
          },
        ),
      ),
    );
  }
}
