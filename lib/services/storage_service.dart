import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../constrants.dart';

class StorageService extends GetxService {
  final GetStorage _storage = GetStorage();

  RxBool isDarkMode = true.obs;

  Future<StorageService> init() async {
    await GetStorage.init();

    return StorageService();
  }

  // Method to save boolean values (e.g., theme mode)
  Future<void> writeBool(String key, bool value) async {
    try {
      await _storage.write(key, value);
    } catch (e) {
      debugPrint("Error writing bool to storage: $e");
    }
  }

  // Method to read boolean values from storage
  bool readBool(String key, {bool defaultValue = false}) {
    try {
      return _storage.read<bool>(key) ?? defaultValue;
    } catch (e) {
      debugPrint("Error reading bool from storage: $e");
      return defaultValue;
    }
  }

  // Method to save int values (e.g., primary color)
  Future<void> writeInt(String key, int value) async {
    try {
      await _storage.write(key, value);
    } catch (e) {
      debugPrint("Error writing int to storage: $e");
    }
  }

  // Method to read int values from storage
  int readInt(String key, {int defaultValue = 0}) {
    try {
      return _storage.read<int>(key) ?? defaultValue;
    } catch (e) {
      debugPrint("Error reading int from storage: $e");
      return defaultValue;
    }
  }

  // Method to save string values (e.g., password)
  Future<void> writeString(String key, String value) async {
    try {
      await _storage.write(key, value);
    } catch (e) {
      debugPrint("Error writing string to storage: $e");
    }
  }

  // Method to read string values from storage
  String readString(String key, {String defaultValue = ''}) {
    try {
      return _storage.read<String>(key) ?? defaultValue;
    } catch (e) {
      debugPrint("Error reading string from storage: $e");
      return defaultValue;
    }
  }

  // Save the selected theme mode (dark or light)
  Future<void> setThemeMode(bool isDark) async {
    await writeBool(themeModeKey, isDark);
    isDarkMode.value = isDark;
  }

  // Get the current primary color from storage or fallback to default
  Color get primaryColor =>
      Color(readInt(primaryColorKey, defaultValue: primaryColor3));

  // Save primary color to storage
  Future<void> savePrimaryColor(int colorValue) async {
    await writeInt(primaryColorKey, colorValue);
  }

  // Method to clear storage (if needed)
  Future<void> clearStorage() async {
    await _storage.erase();
  }

  // Write generic data to cache as JSON
  Future<void> writeData<T>(String key, T data) async {
    if (data is Map<String, dynamic> || data is List) {
      await _storage.write(key, data); // Save raw data (Map or List)
    } else {
      throw Exception("Unsupported data type for caching");
    }
  }

  // Read generic data from cache
  Future<T?> readData<T>(String key) async {
    final cachedData = _storage.read(key);

    log("Cached Data:");
    if (cachedData == null) return null;

    // Return the cached data as is; you'll handle parsing externally
    return cachedData as T;
  }

  // Clear specific cache
  Future<void> clearCache(String key) async {
    await _storage.remove(key);
  }

  // Clear all cache
  Future<void> clearAllCache() async {
    await _storage.erase();
  }
}
