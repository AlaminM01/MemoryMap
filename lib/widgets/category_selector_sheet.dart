import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:uuid/uuid.dart';
import '../core/theme/app_colors.dart';
import '../domain/models/category.dart';
import '../presentation/providers/categories_provider.dart';

class CategorySelectorSheet extends ConsumerStatefulWidget {
  final String selectedCategoryId;
  final ValueChanged<String> onSelected;

  const CategorySelectorSheet({
    super.key,
    required this.selectedCategoryId,
    required this.onSelected,
  });

  @override
  ConsumerState<CategorySelectorSheet> createState() =>
      _CategorySelectorSheetState();
}

class _CategorySelectorSheetState extends ConsumerState<CategorySelectorSheet> {
  bool _isCreatingNew = false;
  final TextEditingController _nameController = TextEditingController();
  int _selectedColor = 0xFF6366F1;
  String _selectedIcon = 'folder';

  final List<int> _availableColors = [
    0xFF6366F1, // Indigo
    0xFF3B82F6, // Blue
    0xFF06B6D4, // Cyan
    0xFF10B981, // Emerald
    0xFFF59E0B, // Amber
    0xFFEF4444, // Red
    0xFFEC4899, // Pink
    0xFF8B5CF6, // Violet
  ];

  final List<String> _availableIcons = [
    'folder',
    'user',
    'book-open',
    'sparkles',
    'briefcase',
    'layout-grid',
    'code',
    'heart',
    'zap',
  ];

  IconData _resolveIcon(String name) {
    switch (name) {
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
      case 'zap':
        return LucideIcons.zap;
      default:
        return LucideIcons.folder;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createCategory() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final newCat = Category(
      id: const Uuid().v4(),
      name: name,
      colorValue: _selectedColor,
      iconName: _selectedIcon,
      isDefault: false,
      createdAt: DateTime.now(),
    );

    await ref.read(categoriesNotifierProvider.notifier).saveCategory(newCat);
    widget.onSelected(newCat.id);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isCreatingNew ? 'Create Category' : 'Select Category',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                icon: Icon(
                  _isCreatingNew ? LucideIcons.x : LucideIcons.plus,
                  size: 20,
                ),
                onPressed: () {
                  setState(() => _isCreatingNew = !_isCreatingNew);
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (_isCreatingNew) ...[
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Category Name (e.g. Design, Philosophy)',
                prefixIcon: const Icon(LucideIcons.tag, size: 18),
                fillColor: isDark
                    ? AppColors.darkSurfaceSubtle
                    : AppColors.lightSurfaceSubtle,
              ),
            ),
            const SizedBox(height: 14),

            // Color selection
            const Text(
              'Color Palette',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _availableColors.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final colVal = _availableColors[i];
                  final isSelected = _selectedColor == colVal;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = colVal),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Color(colVal),
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(LucideIcons.check,
                              color: Colors.white, size: 18)
                          : null,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            // Icon selection
            const Text(
              'Icon',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _availableIcons.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final iconName = _availableIcons[i];
                  final isSelected = _selectedIcon == iconName;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = iconName),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Color(_selectedColor).withOpacity(0.2)
                            : (isDark
                                ? AppColors.darkSurfaceSubtle
                                : AppColors.lightSurfaceSubtle),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Color(_selectedColor)
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        _resolveIcon(iconName),
                        size: 20,
                        color: isSelected
                            ? Color(_selectedColor)
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _createCategory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(_selectedColor),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Create Category',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ] else ...[
            categoriesAsync.when(
              data: (categories) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final cat = categories[i];
                    final isSelected = cat.id == widget.selectedCategoryId;
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(cat.colorValue).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _resolveIcon(cat.iconName),
                          size: 18,
                          color: Color(cat.colorValue),
                        ),
                      ),
                      title: Text(
                        cat.name,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(LucideIcons.check,
                              color: Color(cat.colorValue), size: 20)
                          : null,
                      onTap: () {
                        widget.onSelected(cat.id);
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator.adaptive()),
              error: (err, _) => Text('Error: $err'),
            ),
          ],
        ],
      ),
    );
  }
}
