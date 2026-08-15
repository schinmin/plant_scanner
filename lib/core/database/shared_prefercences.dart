import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class localStorageService {
  static const _userTokenKey = 'user_token';
  static const _secureStorage = FlutterSecureStorage();

  static Future<SharedPreferences> _prefsService() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _userTokenKey, value: token);
    final prefs = await _prefsService();
    await prefs.remove(_userTokenKey);
  }

  static Future<String?> getUserToken() async {
    final secureToken = await _secureStorage.read(key: _userTokenKey);
    if (secureToken != null && secureToken.isNotEmpty) {
      return secureToken;
    }

    final prefs = await _prefsService();
    final legacyToken = prefs.getString(_userTokenKey);
    if (legacyToken == null || legacyToken.isEmpty) return null;

    await _secureStorage.write(key: _userTokenKey, value: legacyToken);
    await prefs.remove(_userTokenKey);
    return legacyToken;
  }

  static Future<void> clearUserToken() async {
    await _secureStorage.delete(key: _userTokenKey);
    final prefs = await _prefsService();
    await prefs.remove(_userTokenKey);
  }

  static Future<void> saveFcmToken(String token) async {
    final prefs = await _prefsService();
    await prefs.setString("fcm_token", token);
  }

  static Future<String?> getFcmToken() async {
    final prefs = await _prefsService();
    return prefs.getString('fcm_token');
  }
}
