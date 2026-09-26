import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/note.dart';
import '../providers/notes_provider.dart';

class SmartOrganizationBar extends ConsumerWidget {
  final ValueChanged<Note> onNoteTap;

  const SmartOrganizationBar({super.key, required this.onNoteTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pinnedNotes = ref.watch(pinnedNotesProvider);

    if (pinnedNotes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primaryLight.withOpacity(0.08)
            : AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.primaryLight.withOpacity(0.2)
              : AppColors.primary.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.pin, size: 14, color: AppColors.primaryLight),
              const SizedBox(width: 6),
              Text(
                'PINNED TO MIND (${pinnedNotes.length})',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: isDark ? AppColors.primaryLight : AppColors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: pinnedNotes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final note = pinnedNotes[i];
                return GestureDetector(
                  onTap: () => onNoteTap(note),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                        width: 0.8,
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            note.isFavorite
                                ? LucideIcons.heart
                                : LucideIcons.fileText,
                            size: 13,
                            color: note.isFavorite
                                ? const Color(0xFFEF4444)
                                : AppColors.primaryLight,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            note.title.isEmpty ? 'Untitled' : note.title,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
