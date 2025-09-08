import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserViewModel extends ChangeNotifier {
  SharedPreferences? _prefs;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  UserModel? _user;
  UserModel? get user => _user;

  String? accessToken;
  String? refreshToken;

  UserViewModel() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    await loadUserFromPrefs();
  }

  /// Save user both locally and to prefs
  void setUser(UserModel user) async {
    _user = user;
    notifyListeners();

    final userJson = jsonEncode(user.toJson());
    await _prefs?.setString('user', userJson);
  }

  /// Load user from SharedPreferences
  Future<void> loadUserFromPrefs() async {
    final userJson = _prefs?.getString('user');
    if (userJson != null) {
      _user = UserModel.fromJson(jsonDecode(userJson));
      notifyListeners();
    }
  }

  void clearUser() async {
    _user = null;
    accessToken = null;
    refreshToken = null;
    await _prefs?.remove('user');
    notifyListeners();
  }

  Future<void> fetchUser() async {
    _setLoading(true);
    try {
      final userInfo = await UserService().fetchUserInfo();
      setUser(userInfo);

      accessToken = _prefs?.getString('accessToken');
      refreshToken = _prefs?.getString('refreshToken');
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }

  Future<void> updateUser(UserModel user) async {
    _setLoading(true);
    try {
      await UserService().updateUser(user);
      await fetchUser();
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    _setLoading(true);
    try {
      await UserService().changePassword(currentPassword, newPassword);
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
