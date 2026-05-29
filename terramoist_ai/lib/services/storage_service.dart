import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/farm.dart';
import '../models/user.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Auth tokens
  static Future<void> setAuthToken(String token) async {
    await _prefs.setString('auth_token', token);
  }

  static String? getAuthToken() {
    return _prefs.getString('auth_token');
  }

  static Future<void> clearAuthToken() async {
    await _prefs.remove('auth_token');
  }

  // User data
  static Future<void> setUser(User user) async {
    await _prefs.setString('user', jsonEncode(user.toJson()));
  }

  static User? getUser() {
    final userJson = _prefs.getString('user');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  static Future<void> clearUser() async {
    await _prefs.remove('user');
  }

  // Login state
  static Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool('isLoggedIn', value);
  }

  static bool isLoggedIn() {
    return _prefs.getBool('isLoggedIn') ?? false;
  }

  // Selected farm
  static Future<void> setSelectedFarm(Farm farm) async {
    await _prefs.setString('selected_farm', jsonEncode(farm.toJson()));
  }

  static Farm? getSelectedFarm() {
    final farmJson = _prefs.getString('selected_farm');
    if (farmJson != null) {
      return Farm.fromJson(jsonDecode(farmJson));
    }
    return null;
  }

  static Future<void> clearSelectedFarm() async {
    await _prefs.remove('selected_farm');
  }

  // Settings
  static Future<void> setNotificationEnabled(bool enabled) async {
    await _prefs.setBool('notifications_enabled', enabled);
  }

  static bool getNotificationEnabled() {
    return _prefs.getBool('notifications_enabled') ?? true;
  }

  static Future<void> setUnitSystem(String system) async {
    await _prefs.setString('unit_system', system);
  }

  static String getUnitSystem() {
    return _prefs.getString('unit_system') ?? 'metric';
  }

  // Clear all data (logout)
  static Future<void> clearAll() async {
    await clearAuthToken();
    await clearUser();
    await setLoggedIn(false);
    await clearSelectedFarm();
  }
}
