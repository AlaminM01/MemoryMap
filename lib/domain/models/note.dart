import '../../core/utils/text_utils.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final String categoryId;
  final List<String> tagIds;
  final bool isPinned;
  final bool isFavorite;
  final bool isArchived;
  final bool isTrashed;
  final int colorIndex; // 0 for default neutral, 1..6 for subtle organic island tints
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastViewedAt;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.categoryId,
    this.tagIds = const [],
    this.isPinned = false,
    this.isFavorite = false,
    this.isArchived = false,
    this.isTrashed = false,
    this.colorIndex = 0,
    required this.createdAt,
    required this.updatedAt,
    this.lastViewedAt,
  });

  int get wordCount => TextUtils.countWords(content);
  int get readingTimeMinutes => TextUtils.calculateReadingTime(content);
  String get preview => TextUtils.getPreview(content);

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? categoryId,
    List<String>? tagIds,
    bool? isPinned,
    bool? isFavorite,
    bool? isArchived,
    bool? isTrashed,
    int? colorIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastViewedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      categoryId: categoryId ?? this.categoryId,
      tagIds: tagIds ?? this.tagIds,
      isPinned: isPinned ?? this.isPinned,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
      isTrashed: isTrashed ?? this.isTrashed,
      colorIndex: colorIndex ?? this.colorIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastViewedAt: lastViewedAt ?? this.lastViewedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'categoryId': categoryId,
      'tagIds': tagIds,
      'isPinned': isPinned,
      'isFavorite': isFavorite,
      'isArchived': isArchived,
      'isTrashed': isTrashed,
      'colorIndex': colorIndex,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastViewedAt': lastViewedAt?.toIso8601String(),
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? 'cat_personal',
      tagIds: (json['tagIds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      isPinned: json['isPinned'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      isTrashed: json['isTrashed'] as bool? ?? false,
      colorIndex: json['colorIndex'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      lastViewedAt: json['lastViewedAt'] != null
          ? DateTime.parse(json['lastViewedAt'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
