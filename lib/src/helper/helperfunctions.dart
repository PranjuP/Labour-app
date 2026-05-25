import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static const String _keyLoggedIn = 'LOGGED_IN';
  static const String _keyUserID = 'USER_ID';
  static const String _keyUserName = 'USER_NAME';
  static const String _keyUserEmail = 'USER_EMAIL';

  // ── Logged-in flag ─────────────────────────────────────────────────────────

  static Future<void> saveUserLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, value);
  }

  static Future<bool?> getUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn);
  }

  // ── User ID ────────────────────────────────────────────────────────────────

  static Future<void> saveUserID(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserID, uid);
  }

  static Future<String?> getUserID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserID);
  }

  // ── User name ──────────────────────────────────────────────────────────────

  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  // ── User email ─────────────────────────────────────────────────────────────

  static Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserEmail, email);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  // ── Clear all (logout) ─────────────────────────────────────────────────────

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
