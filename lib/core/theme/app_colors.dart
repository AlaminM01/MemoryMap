import 'package:flutter/material.dart';

class AppColors {
  // Brand accents (Arc / Notion / Zen inspired)
  static const Color primary = Color(0xFF6366F1); // Modern Electric Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFF06B6D4); // Cyan
  static const Color accent = Color(0xFFF43F5E); // Warm Crimson Rose

  // Light Palette (Warm Japanese Rice Paper & Slate)
  static const Color lightBackground = Color(0xFFFBFBF9);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSubtle = Color(0xFFF4F4F0);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE8E8E2);
  static const Color lightBorderSubtle = Color(0xFFF0F0EA);
  static const Color lightTextPrimary = Color(0xFF18181B);
  static const Color lightTextSecondary = Color(0xFF71717A);
  static const Color lightTextTertiary = Color(0xFFA1A1AA);

  // Dark Palette (Obsidian & Smoked Glass)
  static const Color darkBackground = Color(0xFF0F1117);
  static const Color darkSurface = Color(0xFF171A23);
  static const Color darkSurfaceSubtle = Color(0xFF1E222D);
  static const Color darkCard = Color(0xFF1A1D27);
  static const Color darkBorder = Color(0xFF282C3A);
  static const Color darkBorderSubtle = Color(0xFF202330);
  static const Color darkTextPrimary = Color(0xFFF4F4F5);
  static const Color darkTextSecondary = Color(0xFFA1A1AA);
  static const Color darkTextTertiary = Color(0xFF71717A);

  // AMOLED Palette (True Pitch Black & High Contrast)
  static const Color amoledBackground = Color(0xFF000000);
  static const Color amoledSurface = Color(0xFF080808);
  static const Color amoledSurfaceSubtle = Color(0xFF121212);
  static const Color amoledCard = Color(0xFF0D0D0D);
  static const Color amoledBorder = Color(0xFF222222);
  static const Color amoledBorderSubtle = Color(0xFF181818);
  static const Color amoledTextPrimary = Color(0xFFFFFFFF);
  static const Color amoledTextSecondary = Color(0xFF9E9E9E);
  static const Color amoledTextTertiary = Color(0xFF616161);

  // Organic Island Palettes (6 subtle color tints for note islands)
  static const List<IslandPalette> islandPalettes = [
    // 0: Neutral Glass
    IslandPalette(
      name: 'Default',
      lightBg: Color(0xFFFFFFFF),
      lightBorder: Color(0xFFE8E8E2),
      lightAccent: Color(0xFF6366F1),
      darkBg: Color(0xFF1A1D27),
      darkBorder: Color(0xFF2E3344),
      darkAccent: Color(0xFF818CF8),
      amoledBg: Color(0xFF101010),
      amoledBorder: Color(0xFF242424),
      amoledAccent: Color(0xFF818CF8),
    ),
    // 1: Amber Solar
    IslandPalette(
      name: 'Solar',
      lightBg: Color(0xFFFFFBEB),
      lightBorder: Color(0xFFFDE68A),
      lightAccent: Color(0xFFD97706),
      darkBg: Color(0xFF231F14),
      darkBorder: Color(0xFF453612),
      darkAccent: Color(0xFFFBBF24),
      amoledBg: Color(0xFF161205),
      amoledBorder: Color(0xFF382907),
      amoledAccent: Color(0xFFFBBF24),
    ),
    // 2: Indigo Aurora
    IslandPalette(
      name: 'Aurora',
      lightBg: Color(0xFFEEF2FF),
      lightBorder: Color(0xFFC7D2FE),
      lightAccent: Color(0xFF4F46E5),
      darkBg: Color(0xFF16192E),
      darkBorder: Color(0xFF2B3363),
      darkAccent: Color(0xFF818CF8),
      amoledBg: Color(0xFF0A0D1E),
      amoledBorder: Color(0xFF1E244A),
      amoledAccent: Color(0xFF818CF8),
    ),
    // 3: Emerald Zen
    IslandPalette(
      name: 'Zen',
      lightBg: Color(0xFFECFDF5),
      lightBorder: Color(0xFFA7F3D0),
      lightAccent: Color(0xFF059669),
      darkBg: Color(0xFF12241D),
      darkBorder: Color(0xFF1B4938),
      darkAccent: Color(0xFF34D399),
      amoledBg: Color(0xFF061710),
      amoledBorder: Color(0xFF123425),
      amoledAccent: Color(0xFF34D399),
    ),
    // 4: Rose Petal
    IslandPalette(
      name: 'Rose',
      lightBg: Color(0xFFFFF1F2),
      lightBorder: Color(0xFFFECDD3),
      lightAccent: Color(0xFFE11D48),
      darkBg: Color(0xFF27151A),
      darkBorder: Color(0xFF501C2B),
      darkAccent: Color(0xFFFB7185),
      amoledBg: Color(0xFF19090E),
      amoledBorder: Color(0xFF3B101D),
      amoledAccent: Color(0xFFFB7185),
    ),
    // 5: Lavender Dream
    IslandPalette(
      name: 'Lavender',
      lightBg: Color(0xFFF5F3FF),
      lightBorder: Color(0xFFDDD6FE),
      lightAccent: Color(0xFF7C3AED),
      darkBg: Color(0xFF1E172E),
      darkBorder: Color(0xFF3E2863),
      darkAccent: Color(0xFFA78BFA),
      amoledBg: Color(0xFF110822),
      amoledBorder: Color(0xFF2A1549),
      amoledAccent: Color(0xFFA78BFA),
    ),
  ];
}

class IslandPalette {
  final String name;
  final Color lightBg;
  final Color lightBorder;
  final Color lightAccent;
  final Color darkBg;
  final Color darkBorder;
  final Color darkAccent;
  final Color amoledBg;
  final Color amoledBorder;
  final Color amoledAccent;

  const IslandPalette({
    required this.name,
    required this.lightBg,
    required this.lightBorder,
    required this.lightAccent,
    required this.darkBg,
    required this.darkBorder,
    required this.darkAccent,
    required this.amoledBg,
    required this.amoledBorder,
    required this.amoledAccent,
  });

  Color getBg(bool isDark, bool isAmoled) {
    if (isAmoled) return amoledBg;
    if (isDark) return darkBg;
    return lightBg;
  }

  Color getBorder(bool isDark, bool isAmoled) {
    if (isAmoled) return amoledBorder;
    if (isDark) return darkBorder;
    return lightBorder;
  }

  Color getAccent(bool isDark, bool isAmoled) {
    if (isAmoled) return amoledAccent;
    if (isDark) return darkAccent;
    return lightAccent;
  }
}
