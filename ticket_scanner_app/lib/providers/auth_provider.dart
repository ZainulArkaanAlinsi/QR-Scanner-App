import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _initialized = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;
  bool get initialized => _initialized;

  /// Called on app start — tries to restore session from SharedPreferences
  Future<void> initialize() async {
    _user = await AuthService.loadSavedUser();
    _initialized = true;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _error = null;

    final res = await AuthService.login(email, password);
    if (res.isSuccess && res.data != null) {
      _user = UserModel.fromJson(res.data['user']);
      _setLoading(false);
      return true;
    } else {
      _error = res.message;
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String role = 'attendee',
  }) async {
    _setLoading(true);
    _error = null;

    final res = await AuthService.register(
      name: name,
      email: email,
      password: password,
      role: role,
    );
    if (res.isSuccess && res.data != null) {
      _user = UserModel.fromJson(res.data['user']);
      _setLoading(false);
      return true;
    } else {
      _error = res.message;
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    _user = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}
