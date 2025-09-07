import 'package:ec_ranking/models/user_model.dart';
import 'package:ec_ranking/services/auth_service.dart';
import 'package:ec_ranking/viewmodels/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  final prefs = SharedPreferencesAsync();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String? accessToken;
  String? refreshToken;

  Future<String> getToken() async {
    accessToken = await prefs.getString('accessToken');
    refreshToken = await prefs.getString('refreshToken');
    return accessToken ?? '';
  }

  ///
  Future<bool> login(UserModel user) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (await AuthService().loginUser(user)) {
        UserViewModel().setUser(user);
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

  ///
  Future<bool> register(UserModel user) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (await AuthService().registerUser(user)) {
        UserViewModel().setUser(user);
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

  ///
  Future<bool> refreshUserToken() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (await AuthService().refreshToken()) {
        await UserViewModel().fetchUser();
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

  ///
  Future<bool> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (await AuthService().logoutUser()) {
        UserViewModel().clearUser();
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
