import 'package:ec_ranking/models/user_model.dart';
import 'package:ec_ranking/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel extends ChangeNotifier {
  final prefs = SharedPreferencesAsync();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  UserModel? _user;
  UserModel? get user => _user;

  String? accessToken;
  String? refreshToken;

  /// set user info
  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  ///
  Future<void> fetchUser() async {
    _isLoading = true;
    _errorMessage = null;

    try {
      _user = await UserService().fetchUserInfo();
      accessToken = await prefs.getString('accessToken');
      refreshToken = await prefs.getString('refreshToken');
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// set user to null
  void clearUser() {
    _user = null;
    notifyListeners();
  }

  ///
  Future<void> updateUser(UserModel user) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await UserService().updateUser(user);
      await fetchUser();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  ///
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await UserService().changePassword(currentPassword, newPassword);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
