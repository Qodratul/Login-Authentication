import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

// Service untuk menyimpan dan mengambil data user
class UserStorageService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userDataKey = 'userData';

  // Simpan data user ke SharedPreferences
  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userDataKey, jsonEncode(user.toJson()));
  }

  // Ambil data user dari SharedPreferences
  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userDataKey);

    if (userData == null) {
      return null;
    }

    return UserModel.fromJson(jsonDecode(userData));
  }

  // Cek status login
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Hapus data user saat logout
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_userDataKey);
  }
}