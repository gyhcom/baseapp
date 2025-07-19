import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';

/// Abstract interface for local storage operations
abstract class LocalStorage {
  // ========== STRING OPERATIONS ==========
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);

  // ========== BOOLEAN OPERATIONS ==========
  Future<void> setBool(String key, bool value);
  Future<bool> getBool(String key, {bool defaultValue = false});

  // ========== INTEGER OPERATIONS ==========
  Future<void> setInt(String key, int value);
  Future<int> getInt(String key, {int defaultValue = 0});

  // ========== DOUBLE OPERATIONS ==========
  Future<void> setDouble(String key, double value);
  Future<double> getDouble(String key, {double defaultValue = 0.0});

  // ========== LIST OPERATIONS ==========
  Future<void> setStringList(String key, List<String> value);
  Future<List<String>> getStringList(String key, {List<String>? defaultValue});

  // ========== OBJECT OPERATIONS (using Hive) ==========
  Future<void> setObject<T>(String key, T value);
  Future<T?> getObject<T>(String key);

  // ========== BULK OPERATIONS ==========
  Future<void> setMap(Map<String, dynamic> data);
  Future<Map<String, dynamic>> getAll();

  // ========== UTILITY OPERATIONS ==========
  Future<void> remove(String key);
  Future<void> clear();
  Future<bool> containsKey(String key);
  Future<Set<String>> getKeys();
}

/// Implementation of LocalStorage using SharedPreferences and Hive
class LocalStorageImpl implements LocalStorage {
  LocalStorageImpl({
    required SharedPreferences sharedPreferences,
    required Box hiveBox,
  }) : _sharedPreferences = sharedPreferences,
       _hiveBox = hiveBox;

  final SharedPreferences _sharedPreferences;
  final Box _hiveBox;

  // ========== STRING OPERATIONS ==========

  @override
  Future<void> setString(String key, String value) async {
    await _sharedPreferences.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return _sharedPreferences.getString(key);
  }

  // ========== BOOLEAN OPERATIONS ==========

  @override
  Future<void> setBool(String key, bool value) async {
    await _sharedPreferences.setBool(key, value);
  }

  @override
  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    return _sharedPreferences.getBool(key) ?? defaultValue;
  }

  // ========== INTEGER OPERATIONS ==========

  @override
  Future<void> setInt(String key, int value) async {
    await _sharedPreferences.setInt(key, value);
  }

  @override
  Future<int> getInt(String key, {int defaultValue = 0}) async {
    return _sharedPreferences.getInt(key) ?? defaultValue;
  }

  // ========== DOUBLE OPERATIONS ==========

  @override
  Future<void> setDouble(String key, double value) async {
    await _sharedPreferences.setDouble(key, value);
  }

  @override
  Future<double> getDouble(String key, {double defaultValue = 0.0}) async {
    return _sharedPreferences.getDouble(key) ?? defaultValue;
  }

  // ========== LIST OPERATIONS ==========

  @override
  Future<void> setStringList(String key, List<String> value) async {
    await _sharedPreferences.setStringList(key, value);
  }

  @override
  Future<List<String>> getStringList(
    String key, {
    List<String>? defaultValue,
  }) async {
    return _sharedPreferences.getStringList(key) ?? defaultValue ?? <String>[];
  }

  // ========== OBJECT OPERATIONS (using Hive) ==========

  @override
  Future<void> setObject<T>(String key, T value) async {
    await _hiveBox.put(key, value);
  }

  @override
  Future<T?> getObject<T>(String key) async {
    final value = _hiveBox.get(key);
    return value is T ? value : null;
  }

  // ========== BULK OPERATIONS ==========

  @override
  Future<void> setMap(Map<String, dynamic> data) async {
    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is String) {
        await setString(key, value);
      } else if (value is bool) {
        await setBool(key, value);
      } else if (value is int) {
        await setInt(key, value);
      } else if (value is double) {
        await setDouble(key, value);
      } else if (value is List<String>) {
        await setStringList(key, value);
      } else {
        await setObject(key, value);
      }
    }
  }

  @override
  Future<Map<String, dynamic>> getAll() async {
    final prefs = <String, dynamic>{};

    // Get all SharedPreferences keys
    final prefsKeys = _sharedPreferences.getKeys();
    for (final key in prefsKeys) {
      final value = _sharedPreferences.get(key);
      if (value != null) {
        prefs[key] = value;
      }
    }

    // Get all Hive keys
    final hiveKeys = _hiveBox.keys;
    for (final key in hiveKeys) {
      if (key is String) {
        final value = _hiveBox.get(key);
        if (value != null) {
          prefs[key] = value;
        }
      }
    }

    return prefs;
  }

  // ========== UTILITY OPERATIONS ==========

  @override
  Future<void> remove(String key) async {
    await _sharedPreferences.remove(key);
    await _hiveBox.delete(key);
  }

  @override
  Future<void> clear() async {
    await _sharedPreferences.clear();
    await _hiveBox.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    return _sharedPreferences.containsKey(key) || _hiveBox.containsKey(key);
  }

  @override
  Future<Set<String>> getKeys() async {
    final keys = <String>{};
    keys.addAll(_sharedPreferences.getKeys());
    keys.addAll(_hiveBox.keys.whereType<String>());
    return keys;
  }
}

/// Extension methods for common storage operations
extension LocalStorageExtension on LocalStorage {
  // ========== AUTH TOKEN OPERATIONS ==========

  Future<void> setAccessToken(String token) =>
      setString(AppConstants.accessTokenKey, token);

  Future<String?> getAccessToken() => getString(AppConstants.accessTokenKey);

  Future<void> setRefreshToken(String token) =>
      setString(AppConstants.refreshTokenKey, token);

  Future<String?> getRefreshToken() => getString(AppConstants.refreshTokenKey);

  Future<void> clearTokens() async {
    await remove(AppConstants.accessTokenKey);
    await remove(AppConstants.refreshTokenKey);
  }

  // ========== USER DATA OPERATIONS ==========

  Future<void> setUserData(Map<String, dynamic> userData) =>
      setObject(AppConstants.userDataKey, userData);

  Future<Map<String, dynamic>?> getUserData() =>
      getObject<Map<String, dynamic>>(AppConstants.userDataKey);

  Future<void> clearUserData() => remove(AppConstants.userDataKey);

  // ========== APP SETTINGS OPERATIONS ==========

  Future<void> setThemeMode(String themeMode) =>
      setString(AppConstants.themeKey, themeMode);

  Future<String?> getThemeMode() => getString(AppConstants.themeKey);

  Future<void> setLanguageCode(String languageCode) =>
      setString(AppConstants.languageKey, languageCode);

  Future<String?> getLanguageCode() => getString(AppConstants.languageKey);

  Future<void> setIsFirstLaunch(bool isFirstLaunch) =>
      setBool(AppConstants.isFirstLaunchKey, isFirstLaunch);

  Future<bool> getIsFirstLaunch() =>
      getBool(AppConstants.isFirstLaunchKey, defaultValue: true);

  // ========== AUTHENTICATION STATUS ==========

  Future<bool> get isLoggedIn async {
    final accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }

  Future<void> logout() async {
    await clearTokens();
    await clearUserData();
  }
}
