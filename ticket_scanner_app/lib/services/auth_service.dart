import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_client.dart';
import '../core/constants.dart';
import '../models/api_response.dart';
import '../models/user_model.dart';

class AuthService {
  /// Login — returns ApiResponse; saves token on success
  static Future<ApiResponse> login(String email, String password) async {
    final res = await ApiClient.post('/login', body: {
      'email': email,
      'password': password,
    });

    if (res.isSuccess && res.data != null) {
      final token = res.data['token'];
      final userJson = res.data['user'];
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(kTokenKey, token);
        if (userJson != null) {
          await prefs.setString(kUserKey, jsonEncode(userJson));
        }
      }
    }
    return res;
  }

  /// Register — returns ApiResponse; saves token on success
  static Future<ApiResponse> register({
    required String name,
    required String email,
    required String password,
    String role = 'attendee',
  }) async {
    final res = await ApiClient.post('/register', body: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password,
      'role': role,
    });

    if (res.isSuccess && res.data != null) {
      final token = res.data['token'];
      final userJson = res.data['user'];
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(kTokenKey, token);
        if (userJson != null) {
          await prefs.setString(kUserKey, jsonEncode(userJson));
        }
      }
    }
    return res;
  }

  /// Logout — removes token from storage
  static Future<void> logout() async {
    await ApiClient.post('/logout');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kTokenKey);
    await prefs.remove(kUserKey);
  }

  /// Load saved user from SharedPreferences (for auto-login)
  static Future<UserModel?> loadSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(kTokenKey);
    final userJson = prefs.getString(kUserKey);
    if (token == null || userJson == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(userJson));
    } catch (_) {
      return null;
    }
  }

  /// Fetch fresh user from API
  static Future<UserModel?> getUser() async {
    final res = await ApiClient.get('/user');
    if (res.isSuccess && res.data != null) {
      return UserModel.fromJson(res.data);
    }
    return null;
  }
}
