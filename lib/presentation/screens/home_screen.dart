import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/note.dart';
import '../../domain/models/note_filter.dart';
import '../providers/notes_provider.dart';
import '../providers/theme_provider.dart';
import '../../widgets/category_island_bar.dart';
import '../../widgets/category_selector_sheet.dart';
import '../../widgets/floating_dock.dart';
import '../../widgets/note_island_card.dart';
import 'note_editor_screen.dart';
import 'search_screen.dart';
import 'settings_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _openNewNote(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, __, ___) => const NoteEditorScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _openNote(BuildContext context, Note note) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, __, ___) => NoteEditorScreen(initialNote: note),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _openSearch(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
  }

  void _openSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const SettingsSheet(),
    );
  }

  void _openAddCategory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => CategorySelectorSheet(
        selectedCategoryId: '',
        onSelected: (_) {},
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAmoled = themeState.isAmoled && isDark;

    final filter = ref.watch(noteFilterProvider);
    final isGridView = ref.watch(isGridViewProvider);
    final notesAsync = ref.watch(filteredNotesProvider);
    final recentNotes = ref.watch(recentlyViewedNotesProvider);

    String sectionTitle = 'MemoryMap';
    switch (filter.section) {
      case NoteSection.all:
        sectionTitle = 'MemoryMap';
        break;
      case NoteSection.favorites:
        sectionTitle = 'Favorites';
        break;
      case NoteSection.archived:
        sectionTitle = 'Archive';
        break;
      case NoteSection.trash:
        sectionTitle = 'Recycle Bin';
        break;
    }

    return Scaffold(
      backgroundColor: isAmoled
          ? AppColors.amoledBackground
          : (isDark ? AppColors.darkBackground : AppColors.lightBackground),
      body: Stack(
        children: [
          // Main Scrollable Area
          CustomScrollView(
            slivers: [
              // Top Minimalist App Bar & Header
              SliverToBoxAdapter(
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 16, 22, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top row with Date & Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'SECOND BRAIN',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.5,
                                color: isDark
                                    ? AppColors.darkTextTertiary
                                    : AppColors.lightTextTertiary,
                              ),
                            ),
                            Row(
                              children: [
                                // Empty trash button (only when on trash section)
                                if (filter.section == NoteSection.trash)
                                  IconButton(
                                    tooltip: 'Empty Trash',
                                    icon: const Icon(LucideIcons.trash2,
                                        size: 20, color: Color(0xFFEF4444)),
                                    onPressed: () {
                                      _showEmptyTrashDialog(context, ref);
                                    },
                                  ),
                                // Grid / List View Toggle
                                IconButton(
                                  tooltip: isGridView
                                      ? 'Switch to List'
                                      : 'Switch to Grid',
                                  icon: Icon(
                                    isGridView
                                        ? LucideIcons.layoutList
                                        : LucideIcons.layoutGrid,
                                    size: 20,
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                  ),
                                  onPressed: () {
                                    HapticFeedback.selectionClick();
                                    ref.read(isGridViewProvider.notifier).toggle();
                                  },
                                ),
                                // Settings Button
                                IconButton(
                                  tooltip: 'Settings & Storage',
                                  icon: Icon(
                                    LucideIcons.slidersHorizontal,
                                    size: 20,
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                  ),
                                  onPressed: () => _openSettings(context),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 2),

                        // Section Title in Large Clean Typography
                        Text(
                          sectionTitle,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.6,
                              ),
                        ),

                        const SizedBox(height: 14),

                        // Category chips bar (if All or Favorites)
                        if (filter.section == NoteSection.all ||
                            filter.section == NoteSection.favorites)
                          CategoryIslandBar(
                            onAddCategory: () => _openAddCategory(context),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // Smart Organization: Recently Viewed Carousel (All section only)
              if (filter.section == NoteSection.all &&
                  recentNotes.isNotEmpty &&
                  filter.selectedCategoryId == null &&
                  filter.searchQuery.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Row(
                            children: [
                              const Icon(LucideIcons.history,
                                  size: 14, color: AppColors.primaryLight),
                              const SizedBox(width: 6),
                              Text(
                                'RECENTLY VIEWED',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 84,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: recentNotes.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 10),
                            itemBuilder: (context, idx) {
                              final rNote = recentNotes[idx];
                              return GestureDetector(
                                onTap: () => _openNote(context, rNote),
                                child: Container(
                                  width: 170,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.darkSurfaceSubtle
                                        : AppColors.lightSurfaceSubtle,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isDark
                                          ? AppColors.darkBorder
                                          : AppColors.lightBorder,
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        rNote.title.isEmpty
                                            ? 'Untitled'
                                            : rNote.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${rNote.wordCount} words',
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          color: isDark
                                              ? AppColors.darkTextTertiary
                                              : AppColors.lightTextTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Note Islands Container
              notesAsync.when(
                data: (notes) {
                  if (notes.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildEmptyState(context, filter.section, isDark),
                    );
                  }

                  if (isGridView) {
                    // Staggered Floating Island Grid
                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
                      sliver: SliverMasonryGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        itemBuilder: (context, index) {
                          final note = notes[index];
                          return _buildDismissibleNote(
                            context: context,
                            ref: ref,
                            note: note,
                            child: NoteIslandCard(
                              note: note,
                              onTap: () => _openNote(context, note),
                            ),
                          );
                        },
                        childCount: notes.length,
                      ),
                    );
                  } else {
                    // Organic Floating Island List
                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final note = notes[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildDismissibleNote(
                                context: context,
                                ref: ref,
                                note: note,
                                child: NoteIslandCard(
                                  note: note,
                                  onTap: () => _openNote(context, note),
                                ),
                              ),
                            );
                          },
                          childCount: notes.length,
                        ),
                      ),
                    );
                  }
                },
                loading: () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
                error: (err, _) => SliverFillRemaining(
                  child: Center(child: Text('Error loading notes: $err')),
                ),
              ),
            ],
          ),

          // Floating Glass Dock anchored at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FloatingDock(
              onNewNote: () => _openNewNote(context),
              onOpenSearch: () => _openSearch(context),
              onOpenMenu: () => _openSettings(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDismissibleNote({
    required BuildContext context,
    required WidgetRef ref,
    required Note note,
    required Widget child,
  }) {
    return Dismissible(
      key: Key('note_${note.id}'),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.85),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(LucideIcons.pin, color: Colors.white, size: 22),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.secondary.withOpacity(0.85),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(LucideIcons.archive, color: Colors.white, size: 22),
      ),
      confirmDismiss: (direction) async {
        HapticFeedback.mediumImpact();
        if (direction == DismissDirection.startToEnd) {
          // Toggle Pin
          await ref.read(notesNotifierProvider.notifier).togglePin(note.id);
          return false; // Don't remove from view, state will update
        } else {
          // Toggle Archive
          await ref.read(notesNotifierProvider.notifier).toggleArchive(note.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                note.isArchived ? 'Note unarchived' : 'Note archived',
              ),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () =>
                    ref.read(notesNotifierProvider.notifier).toggleArchive(note.id),
              ),
            ),
          );
          return true;
        }
      },
      child: child,
    );
  }

  Widget _buildEmptyState(
      BuildContext context, NoteSection section, bool isDark) {
    IconData icon;
    String title;
    String subtitle;

    switch (section) {
      case NoteSection.all:
        icon = LucideIcons.feather;
        title = 'Quiet Mind, Open Canvas';
        subtitle =
            'Your second brain is serene.\nTap the + button to capture your next atomic thought.';
        break;
      case NoteSection.favorites:
        icon = LucideIcons.heart;
        title = 'No Favorites Yet';
        subtitle = 'Mark notes with the heart icon to access them here.';
        break;
      case NoteSection.archived:
        icon = LucideIcons.archive;
        title = 'Archive is Empty';
        subtitle = 'Swipe left on notes to archive them when completed.';
        break;
      case NoteSection.trash:
        icon = LucideIcons.trash2;
        title = 'Recycle Bin is Empty';
        subtitle = 'Deleted notes will appear here before permanent erasure.';
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceSubtle
                    : AppColors.lightSurfaceSubtle,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Icon(
                icon,
                size: 38,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.5,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showEmptyTrashDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Empty Recycle Bin?'),
        content: const Text(
          'All notes in the recycle bin will be permanently deleted. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              ref.read(notesNotifierProvider.notifier).emptyTrash();
            },
            child: const Text('Empty Trash'),
          ),
        ],
      ),
    );
  }
}
