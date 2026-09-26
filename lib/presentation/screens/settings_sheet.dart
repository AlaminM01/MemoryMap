import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/note_filter.dart';
import '../providers/backup_provider.dart';
import '../providers/notes_provider.dart';
import '../providers/theme_provider.dart';

class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 18),

            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(LucideIcons.brain, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      AppConstants.appName,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      'v${AppConstants.appVersion} • Offline Second Brain',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),

            // Sections Navigator (Archive & Trash)
            const Text(
              'Organize',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(LucideIcons.archive, color: AppColors.secondary),
              title: const Text('Archived Notes'),
              subtitle: const Text('Notes tucked away for reference'),
              trailing: const Icon(LucideIcons.chevronRight, size: 18),
              onTap: () {
                Navigator.pop(context);
                ref.read(noteFilterProvider.notifier).updateFilter(
                    (f) => f.copyWith(section: NoteSection.archived));
              },
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(LucideIcons.trash2, color: Color(0xFFEF4444)),
              title: const Text('Trash & Recycle Bin'),
              subtitle: const Text('Deleted notes (can be restored)'),
              trailing: const Icon(LucideIcons.chevronRight, size: 18),
              onTap: () {
                Navigator.pop(context);
                ref.read(noteFilterProvider.notifier).updateFilter(
                    (f) => f.copyWith(section: NoteSection.trash));
              },
            ),

            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),

            // Appearance & Themes
            const Text(
              'Appearance',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),

            // Theme Mode Selector
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text('System'),
                  icon: Icon(LucideIcons.smartphone, size: 16),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text('Light'),
                  icon: Icon(LucideIcons.sun, size: 16),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text('Dark'),
                  icon: Icon(LucideIcons.moon, size: 16),
                ),
              ],
              selected: {themeState.themeMode},
              onSelectionChanged: (Set<ThemeMode> newSelection) {
                ref
                    .read(themeProvider.notifier)
                    .setThemeMode(newSelection.first);
              },
            ),

            const SizedBox(height: 12),

            // AMOLED Toggle
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('AMOLED Pure Black'),
              subtitle: const Text('True #000000 black for OLED battery saving'),
              value: themeState.isAmoled,
              activeColor: AppColors.primaryLight,
              onChanged: (val) {
                ref.read(themeProvider.notifier).toggleAmoled(val);
              },
            ),

            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),

            // Backup & Export (Requirement 7)
            const Text(
              'Backup & Knowledge Export',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(LucideIcons.downloadCloud, color: AppColors.primary),
              title: const Text('Backup to Local File'),
              subtitle: const Text('Export all notes and categories to JSON'),
              onTap: () async {
                try {
                  final path =
                      await ref.read(backupNotifierProvider.notifier).saveToFile();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Backup saved locally:\n$path')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Backup failed: $e')),
                    );
                  }
                }
              },
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(LucideIcons.share2, color: AppColors.primaryLight),
              title: const Text('Share Knowledge Base JSON'),
              subtitle: const Text('Export JSON and share via system sheet'),
              onTap: () async {
                try {
                  final json =
                      await ref.read(backupNotifierProvider.notifier).exportJson();
                  await Share.share(
                    json,
                    subject: 'MemoryMap Knowledge Base Export',
                  );
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Share failed: $e')),
                    );
                  }
                }
              },
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(LucideIcons.uploadCloud, color: Color(0xFF10B981)),
              title: const Text('Restore from Backup File'),
              subtitle: const Text('Select a .json backup file to import'),
              onTap: () async {
                final files = await FilePicker.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['json'],
                );

                if (files.isNotEmpty && files.first.path != null) {
                  try {
                    final count = await ref
                        .read(backupNotifierProvider.notifier)
                        .restoreFromFile(files.first.path!);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Successfully restored $count notes!')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Restore error: $e')),
                      );
                    }
                  }
                }
              },
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(LucideIcons.sparkles, color: Color(0xFFF59E0B)),
              title: const Text('Seed Sample Notes'),
              subtitle: const Text('Add sample Second Brain atomic notes'),
              onTap: () async {
                await ref.read(backupNotifierProvider.notifier).seedSampleData();
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sample atomic notes added!')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
