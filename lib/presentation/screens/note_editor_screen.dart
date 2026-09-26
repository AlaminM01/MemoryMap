import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/models/note.dart';
import '../../domain/models/tag.dart';
import '../providers/categories_provider.dart';
import '../providers/notes_provider.dart';
import '../providers/tags_provider.dart';
import '../providers/theme_provider.dart';
import '../../widgets/tag_selector_sheet.dart';
import '../../widgets/category_selector_sheet.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final Note? initialNote;

  const NoteEditorScreen({super.key, this.initialNote});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _categoryId;
  late List<String> _tagIds;
  late bool _isPinned;
  late bool _isFavorite;
  late bool _isArchived;
  late int _colorIndex;
  late DateTime _createdAt;
  bool _hasChanges = false;
  bool _isPreviewMode = false;

  @override
  void initState() {
    super.initState();
    final note = widget.initialNote;
    _titleController = TextEditingController(text: note?.title ?? '');
    _contentController = TextEditingController(text: note?.content ?? '');
    _categoryId = note?.categoryId ?? 'cat_personal';
    _tagIds = List.from(note?.tagIds ?? []);
    _isPinned = note?.isPinned ?? false;
    _isFavorite = note?.isFavorite ?? false;
    _isArchived = note?.isArchived ?? false;
    _colorIndex = note?.colorIndex ?? 0;
    _createdAt = note?.createdAt ?? DateTime.now();

    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);

    // If editing existing note, mark as viewed
    if (note != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(notesNotifierProvider.notifier).markNoteViewed(note.id);
      });
    }
  }

  void _onTextChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    } else {
      setState(() {}); // refresh metrics
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    // If completely empty and new, just close without saving
    if (title.isEmpty && content.isEmpty && widget.initialNote == null) {
      Navigator.of(context).pop();
      return;
    }

    final id = widget.initialNote?.id ?? const Uuid().v4();
    final note = Note(
      id: id,
      title: title.isEmpty ? 'Untitled Note' : title,
      content: content,
      categoryId: _categoryId,
      tagIds: _tagIds,
      isPinned: _isPinned,
      isFavorite: _isFavorite,
      isArchived: _isArchived,
      colorIndex: _colorIndex,
      createdAt: _createdAt,
      updatedAt: DateTime.now(),
      lastViewedAt: DateTime.now(),
    );

    await ref.read(notesNotifierProvider.notifier).saveNote(note);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _openCategoryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => CategorySelectorSheet(
        selectedCategoryId: _categoryId,
        onSelected: (catId) {
          setState(() {
            _categoryId = catId;
            _hasChanges = true;
          });
        },
      ),
    );
  }

  void _openTagPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => TagSelectorSheet(
        selectedTagIds: _tagIds,
        onSelected: (tagIds) {
          setState(() {
            _tagIds = tagIds;
            _hasChanges = true;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAmoled = themeState.isAmoled && isDark;

    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final tagsAsync = ref.watch(tagsStreamProvider);

    final palette = AppColors.islandPalettes[
        _colorIndex.clamp(0, AppColors.islandPalettes.length - 1)];
    final islandBg = palette.getBg(isDark, isAmoled);
    final accentColor = palette.getAccent(isDark, isAmoled);

    final category = categoriesAsync.maybeWhen(
      data: (cats) => cats.firstWhere(
        (c) => c.id == _categoryId,
        orElse: () => cats.first,
      ),
      orElse: () => null,
    );

    final selectedTags = tagsAsync.maybeWhen(
      data: (tags) => tags.where((t) => _tagIds.contains(t.id)).toList(),
      orElse: () => <Tag>[],
    );

    final wordCount = _contentController.text.trim().isEmpty
        ? 0
        : _contentController.text.trim().split(RegExp(r'\s+')).length;
    final readingTime = (wordCount / 200).ceil().clamp(1, 999);

    final heroTag = widget.initialNote != null
        ? 'note_island_${widget.initialNote!.id}'
        : 'note_island_new';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _saveNote();
      },
      child: Scaffold(
        backgroundColor: islandBg,
        appBar: AppBar(
          backgroundColor: islandBg,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft),
            onPressed: _saveNote,
          ),
          actions: [
            // Preview Toggle
            IconButton(
              tooltip: _isPreviewMode ? 'Edit Mode' : 'Preview Mode',
              icon: Icon(_isPreviewMode ? LucideIcons.edit3 : LucideIcons.eye),
              onPressed: () {
                setState(() => _isPreviewMode = !_isPreviewMode);
              },
            ),
            // Pin Toggle
            IconButton(
              tooltip: _isPinned ? 'Unpin' : 'Pin',
              icon: Icon(
                _isPinned ? LucideIcons.pinOff : LucideIcons.pin,
                color: _isPinned ? accentColor : null,
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _isPinned = !_isPinned;
                  _hasChanges = true;
                });
              },
            ),
            // Favorite Toggle
            IconButton(
              tooltip: _isFavorite ? 'Unfavorite' : 'Favorite',
              icon: Icon(
                _isFavorite ? LucideIcons.heart : LucideIcons.heart,
                color: _isFavorite ? const Color(0xFFEF4444) : null,
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _isFavorite = !_isFavorite;
                  _hasChanges = true;
                });
              },
            ),
            // Save Button
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton(
                onPressed: _saveNote,
                style: TextButton.styleFrom(
                  backgroundColor: accentColor.withOpacity(0.15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Done',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Hero(
          tag: heroTag,
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Meta bar: Category picker & Tags button
                        Row(
                          children: [
                            // Category Selector Button
                            GestureDetector(
                              onTap: _openCategoryPicker,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: category != null
                                      ? Color(category.colorValue).withOpacity(0.14)
                                      : accentColor.withOpacity(0.14),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: category != null
                                        ? Color(category.colorValue).withOpacity(0.3)
                                        : accentColor.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      LucideIcons.folder,
                                      size: 14,
                                      color: category != null
                                          ? Color(category.colorValue)
                                          : accentColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      category?.name ?? 'Select Category',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: category != null
                                            ? Color(category.colorValue)
                                            : accentColor,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      LucideIcons.chevronDown,
                                      size: 13,
                                      color: category != null
                                          ? Color(category.colorValue)
                                          : accentColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            // Tags Selector Button
                            GestureDetector(
                              onTap: _openTagPicker,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkSurfaceSubtle
                                      : AppColors.lightSurfaceSubtle,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.darkBorder
                                        : AppColors.lightBorder,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      LucideIcons.tag,
                                      size: 13,
                                      color: isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.lightTextSecondary,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      _tagIds.isEmpty
                                          ? '+ Tags'
                                          : '${_tagIds.length} tags',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.lightTextSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Selected Tags Cloud
                        if (selectedTags.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: selectedTags.map((tag) {
                              return Chip(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                backgroundColor:
                                    Color(tag.colorValue).withOpacity(0.12),
                                side: BorderSide(
                                  color: Color(tag.colorValue).withOpacity(0.3),
                                ),
                                label: Text(
                                  '#${tag.name}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(tag.colorValue),
                                  ),
                                ),
                                deleteIcon: const Icon(LucideIcons.x, size: 12),
                                onDeleted: () {
                                  setState(() {
                                    _tagIds.remove(tag.id);
                                    _hasChanges = true;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],

                        const SizedBox(height: 20),

                        // Title Input
                        TextField(
                          controller: _titleController,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                height: 1.25,
                              ),
                          decoration: InputDecoration(
                            hintText: 'Idea Title...',
                            hintStyle: TextStyle(
                              color: isDark
                                  ? AppColors.darkTextTertiary
                                  : AppColors.lightTextTertiary,
                              fontWeight: FontWeight.w700,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            filled: false,
                          ),
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                        ),

                        const SizedBox(height: 6),

                        // Date and Metrics Bar
                        Text(
                          '${DateFormatter.formatFullDate(_createdAt)} • $wordCount words • ~$readingTime min read',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.darkTextTertiary
                                : AppColors.lightTextTertiary,
                          ),
                        ),

                        const SizedBox(height: 16),
                        Divider(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          thickness: 0.8,
                        ),
                        const SizedBox(height: 12),

                        // Body Content or Preview Mode
                        if (_isPreviewMode)
                          _buildMarkdownPreview(context, isDark)
                        else
                          TextField(
                            controller: _contentController,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  height: 1.65,
                                  fontSize: 16,
                                ),
                            decoration: InputDecoration(
                              hintText:
                                  'Write your thoughts, ideas, markdown or atomic notes here...\n\nSupports:\n# Headers\n- Bullet points\n> Quotes',
                              hintStyle: TextStyle(
                                color: isDark
                                    ? AppColors.darkTextTertiary
                                    : AppColors.lightTextTertiary,
                                height: 1.6,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              filled: false,
                            ),
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                      ],
                    ),
                  ),
                ),

                // Bottom Formatting & Island Color Palette Toolbar
                _buildBottomToolbar(context, isDark, accentColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMarkdownPreview(BuildContext context, bool isDark) {
    final text = _contentController.text;
    if (text.trim().isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            'Nothing to preview yet. Switch back to edit mode to write.',
            style: TextStyle(
              color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    // Split lines and render simple rich styled blocks
    final lines = text.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        if (line.startsWith('# ')) {
          return Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 6),
            child: Text(
              line.substring(2),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          );
        } else if (line.startsWith('## ')) {
          return Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Text(
              line.substring(3),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        } else if (line.startsWith('### ')) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Text(
              line.substring(4),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          );
        } else if (line.startsWith('> ')) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              border: const Border(
                left: BorderSide(color: AppColors.primary, width: 3),
              ),
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
            ),
            child: Text(
              line.substring(2),
              style: const TextStyle(fontStyle: FontStyle.italic, height: 1.45),
            ),
          );
        } else if (line.startsWith('- ') || line.startsWith('* ')) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(' •  ', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(line.substring(2), style: const TextStyle(height: 1.5)),
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Text(
              line.isEmpty ? ' ' : line,
              style: const TextStyle(height: 1.55, fontSize: 15.5),
            ),
          );
        }
      }).toList(),
    );
  }

  Widget _buildBottomToolbar(
      BuildContext context, bool isDark, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Insert Markdown helpers
            IconButton(
              icon: const Icon(LucideIcons.heading1, size: 18),
              tooltip: 'Heading',
              onPressed: () => _insertText('# '),
            ),
            IconButton(
              icon: const Icon(LucideIcons.list, size: 18),
              tooltip: 'List Item',
              onPressed: () => _insertText('- '),
            ),
            IconButton(
              icon: const Icon(LucideIcons.quote, size: 18),
              tooltip: 'Quote',
              onPressed: () => _insertText('> '),
            ),
            IconButton(
              icon: const Icon(LucideIcons.checkSquare, size: 18),
              tooltip: 'Checklist',
              onPressed: () => _insertText('- [ ] '),
            ),

            const Spacer(),

            // Island Tint Picker
            PopupMenuButton<int>(
              tooltip: 'Island Color Tint',
              icon: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.4),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              onSelected: (idx) {
                setState(() {
                  _colorIndex = idx;
                  _hasChanges = true;
                });
              },
              itemBuilder: (context) {
                return List.generate(AppColors.islandPalettes.length, (i) {
                  final pal = AppColors.islandPalettes[i];
                  return PopupMenuItem<int>(
                    value: i,
                    child: Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: pal.getAccent(isDark, false),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(pal.name),
                        if (_colorIndex == i) ...[
                          const Spacer(),
                          const Icon(LucideIcons.check, size: 16),
                        ],
                      ],
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _insertText(String prefix) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final start = selection.start >= 0 ? selection.start : text.length;

    final newText = text.replaceRange(start, start, prefix);
    _contentController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + prefix.length),
    );
  }
}
