import 'package:shared_preferences/shared_preferences.dart';

class localStorageService {
  static Future<SharedPreferences> _prefsService() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  static Future<void> saveToken(String token) async {
    final prefs = await _prefsService();
    await prefs.setString('user_token', token);
  }

  static Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }

  static Future<void> saveFcmToken(String token) async {
    final prefs = await _prefsService();
    await prefs.setString("fcm_token", token);
  }

  static Future<String?> getFcmToken() async {
    final prefs = await _prefsService();
    return prefs.getString('fcm_token');
  }

  static Future<void> clearAll() async {
    final prefs = await _prefsService();

    prefs.remove("fcom_token");
    prefs.remove('user_token');
  }
}
