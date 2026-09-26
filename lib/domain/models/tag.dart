class Tag {
  final String id;
  final String name;
  final int colorValue;
  final DateTime createdAt;

  const Tag({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.createdAt,
  });

  Tag copyWith({
    String? id,
    String? name,
    int? colorValue,
    DateTime? createdAt,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'colorValue': colorValue,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'] as String,
      name: json['name'] as String,
      colorValue: json['colorValue'] as int? ?? 0xFF06B6D4,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  static List<Tag> get defaultTags => [
    Tag(
      id: 'tag_urgent',
      name: 'urgent',
      colorValue: 0xFFEF4444,
      createdAt: DateTime(2026, 1, 1),
    ),
    Tag(
      id: 'tag_deep_work',
      name: 'deep-work',
      colorValue: 0xFF6366F1,
      createdAt: DateTime(2026, 1, 1),
    ),
    Tag(
      id: 'tag_architecture',
      name: 'architecture',
      colorValue: 0xFF0EA5E9,
      createdAt: DateTime(2026, 1, 1),
    ),
    Tag(
      id: 'tag_reading',
      name: 'reading',
      colorValue: 0xFF10B981,
      createdAt: DateTime(2026, 1, 1),
    ),
    Tag(
      id: 'tag_zen',
      name: 'zen',
      colorValue: 0xFF84CC16,
      createdAt: DateTime(2026, 1, 1),
    ),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tag && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
