import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';
import '../presentation/providers/categories_provider.dart';
import '../presentation/providers/notes_provider.dart';

class CategoryIslandBar extends ConsumerWidget {
  final VoidCallback onAddCategory;

  const CategoryIslandBar({
    super.key,
    required this.onAddCategory,
  });

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'user':
        return LucideIcons.user;
      case 'book-open':
        return LucideIcons.bookOpen;
      case 'sparkles':
        return LucideIcons.sparkles;
      case 'briefcase':
        return LucideIcons.briefcase;
      case 'layout-grid':
        return LucideIcons.layoutGrid;
      case 'code':
        return LucideIcons.code;
      case 'heart':
        return LucideIcons.heart;
      case 'compass':
        return LucideIcons.compass;
      case 'zap':
        return LucideIcons.zap;
      default:
        return LucideIcons.folder;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final filter = ref.watch(noteFilterProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return categoriesAsync.when(
      data: (categories) {
        return SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: categories.length + 2, // 1 for All, 1 for + Add
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == 0) {
                // "All" chip
                final isSelected = filter.selectedCategoryId == null;
                return _buildChip(
                  context: context,
                  label: 'All Notes',
                  icon: LucideIcons.layers,
                  isSelected: isSelected,
                  accentColor: AppColors.primary,
                  onTap: () {
                    ref.read(noteFilterProvider.notifier).updateFilter(
                        (f) => f.copyWith(selectedCategoryId: () => null));
                  },
                );
              }

              if (index == categories.length + 1) {
                // Add category button
                return GestureDetector(
                  onTap: onAddCategory,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.plus,
                          size: 15,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'New',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final category = categories[index - 1];
              final isSelected = filter.selectedCategoryId == category.id;
              final catColor = Color(category.colorValue);

              return _buildChip(
                context: context,
                label: category.name,
                icon: _getIconData(category.iconName),
                isSelected: isSelected,
                accentColor: catColor,
                onTap: () {
                  if (isSelected) {
                    ref.read(noteFilterProvider.notifier).updateFilter(
                        (f) => f.copyWith(selectedCategoryId: () => null));
                  } else {
                    ref.read(noteFilterProvider.notifier).updateFilter(
                        (f) => f.copyWith(selectedCategoryId: () => category.id));
                  }
                },
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(height: 44),
      error: (_, __) => const SizedBox(height: 44),
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selectedBg = accentColor.withOpacity(isDark ? 0.22 : 0.14);
    final unselectedBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final selectedBorder = accentColor.withOpacity(0.6);
    final unselectedBorder = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? selectedBg : unselectedBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? selectedBorder : unselectedBorder,
                width: isSelected ? 1.5 : 1.0,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: accentColor.withOpacity(0.18),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 15,
                  color: isSelected
                      ? accentColor
                      : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
                const SizedBox(width: 7),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? (isDark ? Colors.white : accentColor)
                        : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
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
