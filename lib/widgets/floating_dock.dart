import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';
import '../domain/models/note_filter.dart';
import '../presentation/providers/notes_provider.dart';

class FloatingDock extends ConsumerWidget {
  final VoidCallback onNewNote;
  final VoidCallback onOpenSearch;
  final VoidCallback onOpenMenu;

  const FloatingDock({
    super.key,
    required this.onNewNote,
    required this.onOpenSearch,
    required this.onOpenMenu,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(noteFilterProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final dockBg = isDark
        ? const Color(0xFF13151D).withOpacity(0.85)
        : Colors.white.withOpacity(0.90);
    final dockBorder = isDark
        ? Colors.white.withOpacity(0.12)
        : Colors.black.withOpacity(0.08);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: dockBg,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: dockBorder, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.45 : 0.12),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // All Notes
                _buildNavItem(
                  context: context,
                  icon: LucideIcons.layers,
                  label: 'Notes',
                  isSelected: filter.section == NoteSection.all,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ref.read(noteFilterProvider.notifier).updateFilter(
                        (f) => f.copyWith(section: NoteSection.all));
                  },
                ),

                // Favorites
                _buildNavItem(
                  context: context,
                  icon: LucideIcons.heart,
                  label: 'Favorites',
                  isSelected: filter.section == NoteSection.favorites,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ref.read(noteFilterProvider.notifier).updateFilter(
                        (f) => f.copyWith(section: NoteSection.favorites));
                  },
                ),

                // Center New Note FAB (Arc Style)
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    onNewNote();
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.45),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        LucideIcons.plus,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),

                // Search
                _buildNavItem(
                  context: context,
                  icon: LucideIcons.search,
                  label: 'Search',
                  isSelected: false,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onOpenSearch();
                  },
                ),

                // More / Menu
                _buildNavItem(
                  context: context,
                  icon: LucideIcons.moreHorizontal,
                  label: 'More',
                  isSelected: filter.section == NoteSection.archived ||
                      filter.section == NoteSection.trash,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onOpenMenu();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const activeColor = AppColors.primaryLight;
    final inactiveColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: AnimatedScale(
            scale: isSelected ? 1.12 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? activeColor : inactiveColor,
                ),
                const SizedBox(height: 3),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isSelected ? 4 : 0,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: activeColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
