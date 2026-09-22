import 'package:frontend_userside/app/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<void> saveToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString(AppConstants.keyToken, token);
  }

  Future<String?> getToken() async {
    final prefs = await _prefs;
    return prefs.getString(AppConstants.keyToken);
  }

  Future<void> saveUserData(String userJson) async {
    final prefs = await _prefs;
    await prefs.setString(AppConstants.keyUserData, userJson);
  }

  Future<String?> getUserData() async {
    final prefs = await _prefs;
    return prefs.getString(AppConstants.keyUserData);
  }

  Future<void> saveRememberMe(bool remember) async {
    final prefs = await _prefs;
    await prefs.setBool(AppConstants.keyRememberMe, remember);
  }

  Future<bool> getRememberMe() async {
    final prefs = await _prefs;
    return prefs.getBool(AppConstants.keyRememberMe) ?? false;
  }

  Future<void> saveThemeMode(String mode) async {
    final prefs = await _prefs;
    await prefs.setString(AppConstants.keyThemeMode, mode);
  }

  Future<String?> getThemeMode() async {
    final prefs = await _prefs;
    return prefs.getString(AppConstants.keyThemeMode);
  }

  Future<void> clearAuth() async {
    final prefs = await _prefs;
    await prefs.remove(AppConstants.keyToken);
    await prefs.remove(AppConstants.keyUserData);
  }
}
