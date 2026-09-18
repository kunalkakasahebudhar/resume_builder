import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend_admin/core/constants/storage_keys.dart';

class LocalStorage {
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<void> saveToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString(StorageKeys.authToken, token);
  }

  Future<String?> getToken() async {
    final prefs = await _prefs;
    return prefs.getString(StorageKeys.authToken);
  }

  Future<void> saveAdminData(String adminJson) async {
    final prefs = await _prefs;
    await prefs.setString(StorageKeys.adminData, adminJson);
  }

  Future<String?> getAdminData() async {
    final prefs = await _prefs;
    return prefs.getString(StorageKeys.adminData);
  }

  Future<void> saveRememberMe(bool remember) async {
    final prefs = await _prefs;
    await prefs.setBool(StorageKeys.rememberMe, remember);
  }

  Future<bool> getRememberMe() async {
    final prefs = await _prefs;
    return prefs.getBool(StorageKeys.rememberMe) ?? false;
  }

  Future<void> clearAuth() async {
    final prefs = await _prefs;
    await prefs.remove(StorageKeys.authToken);
    await prefs.remove(StorageKeys.adminData);
  }
}
