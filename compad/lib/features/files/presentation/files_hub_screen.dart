import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/app_database.dart';
import '../../../main.dart';

class FilesHubScreen extends ConsumerStatefulWidget {
  const FilesHubScreen({super.key});

  @override
  ConsumerState<FilesHubScreen> createState() => _FilesHubScreenState();
}

class _FilesHubScreenState extends ConsumerState<FilesHubScreen> {
  int _selectedFilter = 0; // 0 = All, 1 = Notes, 2 = PYQs, 3 = Packs
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final compadColors = theme.extension<CompadThemeColors>() ??
        (theme.brightness == Brightness.dark ? CompadThemeColors.dark : CompadThemeColors.light);

    final db = ref.watch(appDatabaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Files & Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'New Note',
            onPressed: () => context.push('/life/notebook'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Search files and notes...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
              child: Row(
                children: [
                  _buildFilterChip('All Files', 0),
                  const SizedBox(width: 8),
                  _buildFilterChip('Notes', 1),
                  const SizedBox(width: 8),
                  _buildFilterChip('PYQs', 2),
                  const SizedBox(width: 8),
                  _buildFilterChip('Shared Packs', 3),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Content List from Database
            Expanded(
              child: FutureBuilder<List<NotesTableData>>(
                future: db.select(db.notesTable).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final allNotes = snapshot.data ?? [];
                  final filteredNotes = allNotes.where((n) {
                    final matchesSearch = n.title.toLowerCase().contains(_searchQuery) ||
                        n.content.toLowerCase().contains(_searchQuery);
                    if (!matchesSearch) return false;
                    if (_selectedFilter == 1) return true;
                    if (_selectedFilter == 2) return n.folder.toLowerCase().contains('pyq');
                    return true;
                  }).toList();

                  // Friendly Empty State when there is no data
                  if (filteredNotes.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                color: compadColors.academicsTint.withAlpha(25),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.folder_open_rounded,
                                size: 48,
                                color: compadColors.academicsTint,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'No Files Yet',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Create a quick study note or import past papers from classmates.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () => context.push('/life/notebook'),
                              icon: const Icon(Icons.note_add_rounded),
                              label: const Text('Create First Note'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = filteredNotes[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: colorScheme.outlineVariant.withAlpha(60)),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: compadColors.campusTint.withAlpha(30),
                            child: Icon(Icons.description_rounded, color: compadColors.campusTint, size: 22),
                          ),
                          title: Text(
                            note.title.isNotEmpty ? note.title : 'Untitled Note',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            note.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
                          ),
                          trailing: Icon(Icons.chevron_right_rounded, color: colorScheme.onSurfaceVariant),
                          onTap: () => context.push('/life/notebook'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilter == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) setState(() => _selectedFilter = index);
      },
    );
  }
}
