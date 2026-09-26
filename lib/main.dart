import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/backup_repository_impl.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/screens/home_screen.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Edge-to-edge transparent system navigation and status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  // Initialize local Hive database
  final storageService = StorageService();
  await storageService.initialize();

  // Seed sample Second Brain atomic notes on very first launch
  final backupRepo = BackupRepositoryImpl(storageService: storageService);
  await backupRepo.seedSampleNotesIfEmpty();

  runApp(
    const ProviderScope(
      child: MemoryMapApp(),
    ),
  );
}

class MemoryMapApp extends ConsumerWidget {
  const MemoryMapApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      themeMode: themeState.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: ref.read(themeProvider.notifier).activeDarkTheme,
      home: const HomeScreen(),
    );
  }
}
