class Category {
  final String id;
  final String name;
  final int colorValue;
  final String iconName;
  final bool isDefault;
  final DateTime createdAt;

  const Category({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.iconName,
    this.isDefault = false,
    required this.createdAt,
  });

  Category copyWith({
    String? id,
    String? name,
    int? colorValue,
    String? iconName,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      iconName: iconName ?? this.iconName,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'colorValue': colorValue,
      'iconName': iconName,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      colorValue: json['colorValue'] as int? ?? 0xFF6366F1,
      iconName: json['iconName'] as String? ?? 'folder',
      isDefault: json['isDefault'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  // Predefined default categories
  static List<Category> get defaultCategories => [
    Category(
      id: 'cat_personal',
      name: 'Personal',
      colorValue: 0xFFF59E0B, // Amber warm
      iconName: 'user',
      isDefault: true,
      createdAt: DateTime(2026, 1, 1),
    ),
    Category(
      id: 'cat_study',
      name: 'Study',
      colorValue: 0xFF3B82F6, // Indigo blue
      iconName: 'book-open',
      isDefault: true,
      createdAt: DateTime(2026, 1, 1),
    ),
    Category(
      id: 'cat_ideas',
      name: 'Ideas',
      colorValue: 0xFF8B5CF6, // Purple violet
      iconName: 'sparkles',
      isDefault: true,
      createdAt: DateTime(2026, 1, 1),
    ),
    Category(
      id: 'cat_work',
      name: 'Work',
      colorValue: 0xFF10B981, // Emerald green
      iconName: 'briefcase',
      isDefault: true,
      createdAt: DateTime(2026, 1, 1),
    ),
    Category(
      id: 'cat_projects',
      name: 'Projects',
      colorValue: 0xFFEC4899, // Rose pink
      iconName: 'layout-grid',
      isDefault: true,
      createdAt: DateTime(2026, 1, 1),
    ),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
