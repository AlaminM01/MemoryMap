import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants/app_constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  late Box<Map> _notesBox;
  late Box<Map> _categoriesBox;
  late Box<Map> _tagsBox;
  late Box _settingsBox;

  Box<Map> get notesBox => _notesBox;
  Box<Map> get categoriesBox => _categoriesBox;
  Box<Map> get tagsBox => _tagsBox;
  Box get settingsBox => _settingsBox;

  Future<void> initialize() async {
    if (_isInitialized) return;

    await Hive.initFlutter();

    _notesBox = await Hive.openBox<Map>(AppConstants.notesBoxName);
    _categoriesBox = await Hive.openBox<Map>(AppConstants.categoriesBoxName);
    _tagsBox = await Hive.openBox<Map>(AppConstants.tagsBoxName);
    _settingsBox = await Hive.openBox(AppConstants.settingsBoxName);

    _isInitialized = true;
    if (kDebugMode) {
      print('MemoryMap: Hive local database initialized successfully.');
    }
  }

  Future<void> optimizeDatabase() async {
    if (!_isInitialized) return;
    await _notesBox.compact();
    await _categoriesBox.compact();
    await _tagsBox.compact();
  }

  Future<void> clearAll() async {
    await _notesBox.clear();
    await _categoriesBox.clear();
    await _tagsBox.clear();
    await _settingsBox.clear();
  }
}
