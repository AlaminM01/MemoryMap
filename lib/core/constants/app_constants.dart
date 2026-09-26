/// Application wide constants for MemoryMap
class AppConstants {
  static const String appName = 'MemoryMap';
  static const String appTagline = 'Second Brain & Knowledge Map';
  static const String appVersion = '1.0.0';

  // Hive Box Names
  static const String notesBoxName = 'memorymap_notes_box';
  static const String categoriesBoxName = 'memorymap_categories_box';
  static const String tagsBoxName = 'memorymap_tags_box';
  static const String settingsBoxName = 'memorymap_settings_box';

  // Settings Keys
  static const String themeModeKey = 'app_theme_mode';
  static const String isAmoledKey = 'app_is_amoled';
  static const String isGridViewKey = 'app_is_grid_view';
  static const String sortByKey = 'app_sort_by';
  static const String hasSeededSampleDataKey = 'app_has_seeded_sample_data';

  // Note defaults
  static const int maxPreviewCharacters = 180;
  static const int wordsPerMinuteReadingSpeed = 200;

  // Animation Durations
  static const Duration defaultAnimDuration = Duration(milliseconds: 300);
  static const Duration quickAnimDuration = Duration(milliseconds: 180);
  static const Duration slowAnimDuration = Duration(milliseconds: 500);
}
