import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/spatial_colors.dart';
import '../../../core/theme/spatial_neumorphic.dart';
import '../../../core/widgets/spatial_glass.dart';
import '../models/note_model.dart';

class NoteEditorScreen extends StatefulWidget {
  final NoteModel? note;
  final Function(String title, String content, String? id) onSave;

  const NoteEditorScreen({
    super.key,
    this.note,
    required this.onSave,
  });

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _titleCtrl;
  late TextEditingController _contentCtrl;
  bool _isPreviewMode = false;
  bool _showAiSummary = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.note?.title ?? '');
    _contentCtrl = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  void _insertMarkdown(String prefix, [String suffix = '']) {
    final text = _contentCtrl.text;
    final selection = _contentCtrl.selection;
    final start = selection.start;
    final end = selection.end;

    if (start < 0 || end < 0) {
      _contentCtrl.text = '$text\n$prefix$suffix';
      return;
    }

    final selectedText = text.substring(start, end);
    final newText = text.replaceRange(start, end, '$prefix$selectedText$suffix');
    _contentCtrl.text = newText;
    _contentCtrl.selection = TextSelection.collapsed(offset: start + prefix.length + selectedText.length);
  }

  @override
  Widget build(BuildContext context) {
    final wordCount = _contentCtrl.text.trim().isEmpty
        ? 0
        : _contentCtrl.text.trim().split(RegExp(r'\s+')).length;

    return Scaffold(
      backgroundColor: SpatialColors.canvas,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: SpatialColors.onSurface),
          onPressed: () {
            // Auto save on back
            if (_titleCtrl.text.isNotEmpty || _contentCtrl.text.isNotEmpty) {
              widget.onSave(_titleCtrl.text, _contentCtrl.text, widget.note?.id);
            }
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.note == null ? 'New Scratchpad Note' : 'Edit Note',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: SpatialColors.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isPreviewMode ? LucideIcons.edit3 : LucideIcons.eye,
              color: SpatialColors.accentCyan,
            ),
            tooltip: _isPreviewMode ? 'Edit Mode' : 'Preview Mode',
            onPressed: () => setState(() => _isPreviewMode = !_isPreviewMode),
          ),
          IconButton(
            icon: const Icon(LucideIcons.check, color: SpatialColors.accentEmerald),
            tooltip: 'Save Note',
            onPressed: () {
              widget.onSave(_titleCtrl.text, _contentCtrl.text, widget.note?.id);
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Floating Spatial Glass Tool Ribbon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SpatialGlass(
                radius: 16,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildToolbarBtn('H1', () => _insertMarkdown('# ')),
                      _buildToolbarBtn('H2', () => _insertMarkdown('## ')),
                      _buildToolbarBtn('B', () => _insertMarkdown('**', '**'), isBold: true),
                      _buildToolbarBtn('I', () => _insertMarkdown('*', '*'), isItalic: true),
                      _buildToolbarBtn('Code', () => _insertMarkdown('```c\n', '\n```')),
                      _buildToolbarBtn('- [ ]', () => _insertMarkdown('- [ ] ')),
                      const SizedBox(width: 8),
                      // AI Offline Summary Pill
                      GestureDetector(
                        onTap: () => setState(() => _showAiSummary = !_showAiSummary),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: SpatialColors.accentIndigo.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: SpatialColors.accentIndigo.withValues(alpha: 0.5),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(LucideIcons.zap, size: 14, color: SpatialColors.accentIndigo),
                              SizedBox(width: 4),
                              Text(
                                'AI-Offline',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: SpatialColors.accentIndigo,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // AI Flash Pill Notification
            if (_showAiSummary)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: SpatialDecorations.raised(
                    radius: 12,
                    base: SpatialColors.surfaceContainerHigh,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(LucideIcons.sparkles, size: 16, color: SpatialColors.accentIndigo),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Local Offline Summary:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: SpatialColors.onSurface,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Core concepts analyzed: deterministic ISRs, FreeRTOS queue handles, and priority inversion prevention.',
                              style: TextStyle(
                                fontSize: 11,
                                color: SpatialColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _showAiSummary = false),
                        child: const Icon(LucideIcons.x, size: 14, color: SpatialColors.outline),
                      ),
                    ],
                  ),
                ),
              ),

            // Note Meta Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: SpatialDecorations.raised(
                  radius: 16,
                  base: SpatialColors.surfaceContainer,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleCtrl,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: SpatialColors.onSurface,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Note Title...',
                        hintStyle: TextStyle(color: SpatialColors.outline),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: SpatialColors.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$wordCount words',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'JetBrainsMono',
                                  color: SpatialColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: SpatialColors.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '#systems-study',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'JetBrainsMono',
                                  color: SpatialColors.accentCyan,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: SpatialDecorations.inset(
                            radius: 10,
                            base: SpatialColors.surfaceContainerLowest,
                          ),
                          child: const Row(
                            children: [
                              Icon(LucideIcons.database, size: 10, color: SpatialColors.accentEmerald),
                              SizedBox(width: 4),
                              Text(
                                'SQLite Synced',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontFamily: 'JetBrainsMono',
                                  color: SpatialColors.accentEmerald,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Content Area (Edit vs Preview)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: SpatialDecorations.inset(
                    radius: 18,
                    base: SpatialColors.surfaceContainerLowest,
                  ),
                  child: _isPreviewMode
                      ? Markdown(
                          data: _contentCtrl.text.isEmpty
                              ? '*No content written yet.*'
                              : _contentCtrl.text,
                          styleSheet: MarkdownStyleSheet(
                            h1: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: SpatialColors.onSurface,
                            ),
                            h2: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: SpatialColors.accentCyan,
                            ),
                            h3: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: SpatialColors.accentIndigo,
                            ),
                            p: const TextStyle(
                              fontSize: 14,
                              color: SpatialColors.onSurface,
                              height: 1.5,
                            ),
                            code: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              color: SpatialColors.accentCyan,
                              backgroundColor: SpatialColors.surfaceContainerHigh,
                              fontSize: 12,
                            ),
                            codeblockDecoration: BoxDecoration(
                              color: SpatialColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white10),
                            ),
                            blockquoteDecoration: BoxDecoration(
                              color: SpatialColors.surfaceContainer.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(8),
                              border: const Border(
                                left: BorderSide(color: SpatialColors.accentCyan, width: 3),
                              ),
                            ),
                          ),
                        )
                      : TextField(
                          controller: _contentCtrl,
                          maxLines: null,
                          expands: true,
                          style: const TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 13,
                            color: SpatialColors.onSurface,
                            height: 1.5,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Write offline markdown or paste code snippets here...',
                            hintStyle: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              color: SpatialColors.outline,
                              fontSize: 13,
                            ),
                            border: InputBorder.none,
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

  Widget _buildToolbarBtn(
    String label,
    VoidCallback onTap, {
    bool isBold = false,
    bool isItalic = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: SpatialDecorations.raised(
            radius: 8,
            base: SpatialColors.surfaceContainerHigh,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
              color: SpatialColors.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
