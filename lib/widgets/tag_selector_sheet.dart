import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:uuid/uuid.dart';
import '../core/theme/app_colors.dart';
import '../domain/models/tag.dart';
import '../presentation/providers/tags_provider.dart';

class TagSelectorSheet extends ConsumerStatefulWidget {
  final List<String> selectedTagIds;
  final ValueChanged<List<String>> onSelected;

  const TagSelectorSheet({
    super.key,
    required this.selectedTagIds,
    required this.onSelected,
  });

  @override
  ConsumerState<TagSelectorSheet> createState() => _TagSelectorSheetState();
}

class _TagSelectorSheetState extends ConsumerState<TagSelectorSheet> {
  late List<String> _currentSelection;
  final TextEditingController _newTagController = TextEditingController();
  bool _isCreating = false;
  int _newTagColor = 0xFF06B6D4;

  final List<int> _tagColors = [
    0xFF06B6D4, // Cyan
    0xFF6366F1, // Indigo
    0xFF10B981, // Emerald
    0xFFF59E0B, // Amber
    0xFFEF4444, // Red
    0xFFEC4899, // Pink
    0xFF8B5CF6, // Violet
    0xFF84CC16, // Lime
  ];

  @override
  void initState() {
    super.initState();
    _currentSelection = List.from(widget.selectedTagIds);
  }

  @override
  void dispose() {
    _newTagController.dispose();
    super.dispose();
  }

  Future<void> _createTag() async {
    final rawName = _newTagController.text.trim().toLowerCase();
    if (rawName.isEmpty) return;
    final cleanName = rawName.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '');

    final newTag = Tag(
      id: const Uuid().v4(),
      name: cleanName,
      colorValue: _newTagColor,
      createdAt: DateTime.now(),
    );

    await ref.read(tagsNotifierProvider.notifier).saveTag(newTag);
    setState(() {
      _currentSelection.add(newTag.id);
      _newTagController.clear();
      _isCreating = false;
    });
    widget.onSelected(_currentSelection);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tagsAsync = ref.watch(tagsStreamProvider);

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
              const Text(
                'Assign Tags',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              IconButton(
                icon: Icon(
                  _isCreating ? LucideIcons.x : LucideIcons.plus,
                  size: 20,
                ),
                onPressed: () {
                  setState(() => _isCreating = !_isCreating);
                },
              ),
            ],
          ),

          if (_isCreating) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newTagController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'New tag name...',
                      prefixIcon: Icon(LucideIcons.hash, size: 16),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _createTag,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(_newTagColor),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Tag color chooser
            SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _tagColors.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (_, i) {
                  final c = _tagColors[i];
                  final isSelected = _newTagColor == c;
                  return GestureDetector(
                    onTap: () => setState(() => _newTagColor = c),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Color(c),
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 2.5)
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],

          const SizedBox(height: 12),

          tagsAsync.when(
            data: (tags) {
              if (tags.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text('No tags yet. Create one!')),
                );
              }

              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tags.map((tag) {
                  final isSelected = _currentSelection.contains(tag.id);
                  final tagColor = Color(tag.colorValue);

                  return FilterChip(
                    label: Text('#${tag.name}'),
                    selected: isSelected,
                    selectedColor: tagColor.withOpacity(0.2),
                    checkmarkColor: tagColor,
                    backgroundColor: isDark
                        ? AppColors.darkSurfaceSubtle
                        : AppColors.lightSurfaceSubtle,
                    side: BorderSide(
                      color: isSelected ? tagColor : Colors.transparent,
                    ),
                    labelStyle: TextStyle(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? tagColor
                          : (isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _currentSelection.add(tag.id);
                        } else {
                          _currentSelection.remove(tag.id);
                        }
                      });
                      widget.onSelected(_currentSelection);
                    },
                  );
                }).toList(),
              );
            },
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
            error: (e, _) => Text('Error: $e'),
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Apply Tags',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
