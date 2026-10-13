import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/services/preference_service.dart';
import 'package:get/get.dart';

class ThemeService extends GetxService {
  // Access the globally registered StorageService
  final PreferenceService _storage = Get.find<PreferenceService>();

  final List<FlexScheme> availableSchemes = [
    // --- Greens & Teals ---
    FlexScheme.green, // Clean classic forest green
    FlexScheme.money, // Rich financial green
    FlexScheme.jungle, // Lush tropical green
    // --- Warm Earthy & Sunset Tones ---
    FlexScheme.amber, // Warm gold & bronze
    FlexScheme.mango, // Vibrant orange & sunset yellow
    FlexScheme.espresso, // Deep warm coffee & mocha tones
    // --- Reds, Pinks & Purples ---
    FlexScheme.mandyRed, // Soft coral red
    FlexScheme.sakura, // Cherry blossom pink
    FlexScheme.purpleM3, // Modern Material 3 deep purple
    // --- Blues & Cool Tones ---
    FlexScheme.blumineBlue, // Deep denim & steel blue
    FlexScheme.shark, // Cool slate, charcoal & dark cyan
    // --- Standard ---
    FlexScheme.material, // Standard Material 3 default
  ];

  final Rx<FlexScheme> currentScheme = FlexScheme.material.obs;
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  ThemeService init() {
    _loadFromStorage();
    return this;
  }

  void _loadFromStorage() {
    // Load saved FlexScheme
    final savedSchemeName = _storage.getValue<String>(
      PreferenceKeys.themeScheme,
    );
    if (savedSchemeName != null) {
      currentScheme.value = FlexScheme.values.firstWhere(
        (e) => e.name == savedSchemeName,
        orElse: () => FlexScheme.material,
      );
    }

    // Load saved ThemeMode
    final savedModeName = _storage.getValue<String>(PreferenceKeys.themeMode);
    if (savedModeName != null) {
      themeMode.value = ThemeMode.values.firstWhere(
        (e) => e.name == savedModeName,
        orElse: () => ThemeMode.system,
      );
    }
  }

  Future<void> changeScheme(FlexScheme scheme) async {
    currentScheme.value = scheme;
    await _storage.setValue<String>(PreferenceKeys.themeScheme, scheme.name);
  }

  Future<void> changeThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    await _storage.setValue<String>(PreferenceKeys.themeMode, mode.name);
  }
}
