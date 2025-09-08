import 'package:ec_ranking/models/user_model.dart';
import 'package:ec_ranking/services/auth_service.dart';
import 'package:ec_ranking/viewmodels/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  final userVM = UserViewModel();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String? accessToken;
  String? refreshToken;

  /// Load tokens from SharedPreferences
  Future<String> getToken() async {
    final prefs = SharedPreferencesAsync();
    accessToken = await prefs.getString('accessToken') ?? '';
    refreshToken = await prefs.getString('refreshToken') ?? '';
    return accessToken ?? '';
  }

  /// Login
  Future<bool> login(UserModel user) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await AuthService().loginUser(user);
      if (success) {
        final prefs = await SharedPreferences.getInstance();
        accessToken = prefs.getString('accessToken');
        refreshToken = prefs.getString('refreshToken');
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Register
  Future<bool> register(UserModel user) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await AuthService().registerUser(user);
      if (success) {
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Refresh Token
  Future<bool> refreshUserToken() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await AuthService().refreshToken();
      if (success) {
        final prefs = await SharedPreferences.getInstance();
        accessToken = prefs.getString('accessToken');
        refreshToken = prefs.getString('refreshToken');
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Logout
  Future<bool> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await AuthService().logoutUser();
      if (success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('accessToken');
        await prefs.remove('refreshToken');
        userVM.clearUser();
        accessToken = null;
        refreshToken = null;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }
}
