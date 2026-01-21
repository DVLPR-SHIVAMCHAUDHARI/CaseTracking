import 'package:shared_preferences/shared_preferences.dart';

class LocalDb {
  static const _keyUserId = "user_id";
  static const _keyUsername = "username";
  static const _keyDepartmentId = "department_id";
  static const _keyRoleId = "role_id";

  /// SAVE USER SESSION
  static Future<void> saveUser({
    required String userId,
    required String username,
    required String departmentId,
    required String roleId,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyDepartmentId, departmentId);
    await prefs.setString(_keyRoleId, roleId);
  }

  /// GETTERS
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  static Future<String?> getDepartmentId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDepartmentId);
  }

  static Future<String?> getRoleId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRoleId);
  }

  /// CHECK LOGIN
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyUserId);
  }

  /// CLEAR SESSION (LOGOUT)
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
