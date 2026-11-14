import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

abstract class StorageKeys {
  //
  static const String themeScheme = 'theme_scheme';
  static const String themeMode = 'theme_mode';

  static const String apiGame = 'api_game';
  static const String apiGameClientId = "client_id";
  static const String apiGameClientSecret = "client_secret";
  static const String apiMovieAndSeries = 'api_movie';
  static const String apiAnime = 'api_anime';
  static const String apiBook = 'api_book';

  static const String languageCode = 'languageCode';
}

class StorageService extends GetxController {
  // Flutterda servisler get ile kullanımda genellikle
  // late ve final ile tanıtılırlar edilirler.
  late final SharedPreferences _preferences;
  var selectedCategoryKey = RxnString();

  final selectedLanguageCode = 'en'.obs;

  // Bu servisler sonradan Future init() ile initialize edilirler.
  Future<StorageService> init() async {
    _preferences = await SharedPreferences.getInstance();

    // default dil olarak.
    selectedLanguageCode.value =
        getValue<String>(StorageKeys.languageCode) ?? 'en';

    return this;
  }

  Future<void> setLanguageCode(String code) async {
    selectedLanguageCode.value = code;
    await setValue(StorageKeys.languageCode, code);
  }

  Future<bool> setValue<T>(String key, T value) async {
    try {
      if (value is String) {
        return await _preferences.setString(key, value);
      } else if (value is int) {
        return await _preferences.setInt(key, value);
      } else if (value is double) {
        return await _preferences.setDouble(key, value);
      } else if (value is bool) {
        return await _preferences.setBool(key, value);
      } else if (value is List<String>) {
        return await _preferences.setStringList(key, value);
      } else {
        throw ArgumentError("Not Supported Data Type: ${value.runtimeType}");
      }
    } catch (e) {
      debugPrint("Error: While adding data $e");
      return false;
    }
  }

  T? getValue<T>(String key) {
    try {
      if (T == String) {
        return _preferences.getString(key) as T?;
      } else if (T == int) {
        return _preferences.getInt(key) as T?;
      } else if (T == bool) {
        return _preferences.getBool(key) as T?;
      } else if (T == double) {
        return _preferences.getDouble(key) as T?;
      } else if (T == List<String>) {
        return _preferences.getStringList(key) as T?;
      } else {
        throw ArgumentError("Not Supported Data Type");
      }
    } on Exception catch (e) {
      debugPrint("Error: While Getting data: $e");
      return null;
    }
  }

  Future<bool> remove(String key) async {
    try {
      return await _preferences.remove(key);
    } catch (e) {
      debugPrint("Error: While Removing Data; $e");
      return false;
    }
  }

  Future<bool> clear() async {
    try {
      return await _preferences.clear();
    } catch (e) {
      debugPrint("Error: While Clearing DataSet; $e");
      return false;
    }
  }

  bool hasKey(String key) {
    return _preferences.containsKey(key);
  }

  T getValueOrDefault<T>(String key, T defaultValue) {
    return getValue<T>(key) ?? defaultValue;
  }

  Map<String, dynamic> getAllValues() {
    final keys = _preferences.getKeys();
    final map = <String, dynamic>{};

    for (var key in keys) {
      map[key] = _preferences.get(key);
    }

    return map;
  }

  // Image saving
  // Image Writing
  Future<String?> pickAndSaveImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1200,
      maxHeight: 1200,
    );

    if (pickedFile == null) return null;

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String extension = path.extension(pickedFile.path);
    final String fileName =
        '${DateTime.now().millisecondsSinceEpoch}$extension';
    final String savedPath = path.join(appDocDir.path, fileName);

    final File permanentImage = await File(pickedFile.path).copy(savedPath);
    return permanentImage.path;
  }

  // Image Deletion
  Future<void> deleteImageFile(String? filePath) async {
    if (filePath == null || filePath.isEmpty) return;
    try {
      final file = File(filePath);
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }
}
