import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/date_formatter.dart';
import '../domain/models/note.dart';
import '../presentation/providers/categories_provider.dart';
import '../presentation/providers/notes_provider.dart';
import '../presentation/providers/tags_provider.dart';
import '../presentation/providers/theme_provider.dart';

class NoteIslandCard extends ConsumerWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const NoteIslandCard({
    super.key,
    required this.note,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAmoled = themeState.isAmoled && isDark;

    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final tagsAsync = ref.watch(tagsStreamProvider);

    // Island Palette
    final palette = AppColors.islandPalettes[
        note.colorIndex.clamp(0, AppColors.islandPalettes.length - 1)];

    final cardBg = palette.getBg(isDark, isAmoled);
    final cardBorder = palette.getBorder(isDark, isAmoled);
    final accentColor = palette.getAccent(isDark, isAmoled);

    // Resolve category
    final category = categoriesAsync.maybeWhen(
      data: (cats) => cats.firstWhere(
        (c) => c.id == note.categoryId,
        orElse: () => cats.first,
      ),
      orElse: () => null,
    );

    // Resolve tags
    final activeTags = tagsAsync.maybeWhen(
      data: (tags) => tags.where((t) => note.tagIds.contains(t.id)).toList(),
      orElse: () => [],
    );

    return Hero(
      tag: 'note_island_${note.id}',
      flightShuttleBuilder: (flightContext, animation, flightDirection,
          fromHeroContext, toHeroContext) {
        return Material(
          color: Colors.transparent,
          child: toHeroContext.widget,
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: () {
            HapticFeedback.mediumImpact();
            if (onLongPress != null) {
              onLongPress!();
            } else {
              _showQuickActionsSheet(context, ref);
            }
          },
          borderRadius: BorderRadius.circular(24),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: note.isPinned
                    ? accentColor.withOpacity(0.5)
                    : cardBorder,
                width: note.isPinned ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : cardBorder.withOpacity(0.2),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top row: Category, Pin, and Favorite indicator
                Row(
                  children: [
                    if (category != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(category.colorValue).withOpacity(0.14),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color(category.colorValue).withOpacity(0.3),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                            color: Color(category.colorValue),
                          ),
                        ),
                      ),
                    const Spacer(),
                    if (note.isPinned)
                      Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.pin,
                          size: 13,
                          color: accentColor,
                        ),
                      ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        ref
                            .read(notesNotifierProvider.notifier)
                            .toggleFavorite(note.id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Icon(
                          note.isFavorite
                              ? LucideIcons.heart
                              : LucideIcons.heart,
                          size: 16,
                          color: note.isFavorite
                              ? const Color(0xFFEF4444)
                              : (isDark
                                  ? AppColors.darkTextTertiary
                                  : AppColors.lightTextTertiary),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Note Title
                Text(
                  note.title.trim().isEmpty ? 'Untitled Note' : note.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        height: 1.25,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Note Preview
                if (note.preview.isNotEmpty)
                  Text(
                    note.preview,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          height: 1.45,
                          fontSize: 13.5,
                        ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),

                // Tag chips
                if (activeTags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: activeTags.take(3).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.06)
                              : Colors.black.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '#${tag.name}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],

                const SizedBox(height: 14),

                // Footer: Date and Read time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormatter.formatNoteDate(note.updatedAt),
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.lightTextTertiary,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.clock,
                          size: 11,
                          color: isDark
                              ? AppColors.darkTextTertiary
                              : AppColors.lightTextTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${note.readingTimeMinutes}m read',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.darkTextTertiary
                                : AppColors.lightTextTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showQuickActionsSheet(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pill indicator
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),

              Text(
                note.title.isEmpty ? 'Quick Actions' : note.title,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 16),

              // Island Color Palette Picker
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppColors.islandPalettes.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, idx) {
                    final pal = AppColors.islandPalettes[idx];
                    final isSelected = note.colorIndex == idx;
                    return GestureDetector(
                      onTap: () {
                        ref.read(notesNotifierProvider.notifier).saveNote(
                              note.copyWith(
                                colorIndex: idx,
                                updatedAt: DateTime.now(),
                              ),
                            );
                        Navigator.pop(sheetContext);
                      },
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: pal.getAccent(isDark, false).withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? pal.getAccent(isDark, false)
                                : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: pal.getAccent(isDark, false),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),

              // Actions
              ListTile(
                leading: Icon(
                  note.isPinned ? LucideIcons.pinOff : LucideIcons.pin,
                  color: AppColors.primary,
                ),
                title: Text(note.isPinned ? 'Unpin Note' : 'Pin to Top'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  ref.read(notesNotifierProvider.notifier).togglePin(note.id);
                },
              ),
              ListTile(
                leading: Icon(
                  note.isFavorite ? LucideIcons.heartOff : LucideIcons.heart,
                  color: const Color(0xFFEF4444),
                ),
                title: Text(note.isFavorite
                    ? 'Remove from Favorites'
                    : 'Add to Favorites'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  ref
                      .read(notesNotifierProvider.notifier)
                      .toggleFavorite(note.id);
                },
              ),
              ListTile(
                leading: Icon(
                  note.isArchived ? LucideIcons.archiveRestore : LucideIcons.archive,
                  color: AppColors.secondary,
                ),
                title: Text(note.isArchived ? 'Unarchive Note' : 'Archive Note'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  ref
                      .read(notesNotifierProvider.notifier)
                      .toggleArchive(note.id);
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.trash2, color: Color(0xFFEF4444)),
                title: const Text(
                  'Move to Trash',
                  style: TextStyle(color: Color(0xFFEF4444)),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  ref.read(notesNotifierProvider.notifier).moveToTrash(note.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
