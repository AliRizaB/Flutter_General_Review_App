import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/services/storage_service.dart';
import 'package:get/get.dart';

class ThemeService extends GetxService {
  // Access the globally registered StorageService
  final StorageService _storage = Get.find<StorageService>();

  final List<FlexScheme> availableSchemes = [
    // --- Modern Tech, Neon & Cyber ---
    FlexScheme.ebonyClay, // High-contrast neon purple & cyan
    FlexScheme.outerSpace, // Deep cosmic slate & icy blue
    FlexScheme.deepBlue, // Vibrant tech blue
    FlexScheme.blumineBlue, // Denim & steel blue
    FlexScheme.shark, // Slate, charcoal & cyan
    FlexScheme.aquaBlue, // Deep ocean aqua
    // --- Expressive Reds, Pinks & Purples ---
    FlexScheme.barossa, // Deep wine red & plum
    FlexScheme.mandyRed, // Coral red & soft rose
    FlexScheme.redWine, // Deep bordeaux burgundy
    FlexScheme.sakura, // Soft cherry blossom pink
    FlexScheme.indigo, // Deep indigo & violet
    FlexScheme.deepPurple, // Expressive deep purple
    FlexScheme.purpleM3, // Royal Material 3 purple
    // --- Greens & Teals ---
    FlexScheme.wasabi, // Sage green & vibrant lime
    FlexScheme.jungle, // Lush tropical forest
    FlexScheme.green, // Classic forest green
    FlexScheme.money, // Financial mint green
    FlexScheme.shadGreen, // Clean teal & mint
    // --- Warm Earthy & Sunset Tones ---
    FlexScheme.mango, // Sunset orange & coral
    FlexScheme.amber, // Warm gold & bronze
    FlexScheme.espresso, // Rich mocha & coffee tones
    FlexScheme.damask, // Warm terracotta & copper
    // --- Standards & Basics ---
    FlexScheme.material, // Standard Material 3
    FlexScheme.greyLaw, // Cool corporate slate grey
  ];

  final Rx<FlexScheme> currentScheme = FlexScheme.material.obs;
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  ThemeService init() {
    _loadFromStorage();
    return this;
  }

  void _loadFromStorage() {
    // Load saved FlexScheme
    final savedSchemeName = _storage.getValue<String>(StorageKeys.themeScheme);
    if (savedSchemeName != null) {
      currentScheme.value = FlexScheme.values.firstWhere(
        (e) => e.name == savedSchemeName,
        orElse: () => FlexScheme.material,
      );
    }

    // Load saved ThemeMode
    final savedModeName = _storage.getValue<String>(StorageKeys.themeMode);
    if (savedModeName != null) {
      themeMode.value = ThemeMode.values.firstWhere(
        (e) => e.name == savedModeName,
        orElse: () => ThemeMode.system,
      );
    }
  }

  Future<void> changeScheme(FlexScheme scheme) async {
    currentScheme.value = scheme;
    await _storage.setValue<String>(StorageKeys.themeScheme, scheme.name);
  }

  Future<void> changeThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    await _storage.setValue<String>(StorageKeys.themeMode, mode.name);
  }
}
