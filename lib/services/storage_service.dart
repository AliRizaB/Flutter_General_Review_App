import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageKeys {
  //
  static const String themeScheme = 'theme_scheme';
  static const String themeMode = 'theme_mode';

  static const String apiGame = 'api_game';
  static const String apiMovie = 'api_movie';
  static const String apiSeries = 'api_series';
  static const String apiAnime = 'api_anime';
  static const String apiBook = 'api_book';
}

class StorageService extends GetxController {
  // Flutterda servisler get ile kullanımda genellikle
  // late ve final ile tanıtılırlar edilirler.
  late final SharedPreferences _preferences;
  var selectedCategoryKey = RxnString();

  // Bu servisler sonradan Future init() ile initialize edilirler.
  Future<StorageService> init() async {
    _preferences = await SharedPreferences.getInstance();
    return this;
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
}
