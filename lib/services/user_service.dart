import 'dart:convert';
import 'package:ec_ranking/models/user_model.dart';
import 'package:ec_ranking/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const baseURL = 'https://xxlrn8p4-7000.uks1.devtunnels.ms/api/users';

class UserService {
  final prefs = SharedPreferencesAsync();
  final authService = AuthService();

  Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  /// Common request wrapper with 401 retry
  Future<http.Response> _sendWithRetry(
    Future<http.Response> Function(String token) requestFn,
  ) async {
    String token = await prefs.getString('accessToken') ?? '';

    http.Response response = await requestFn(token);

    if (response.statusCode == 401) {
      final refreshed = await authService.refreshToken();
      if (refreshed) {
        token = await prefs.getString('accessToken') ?? '';
        response = await requestFn(token); // retry once
      }
    }

    return response;
  }

  /// Fetch User Info
  Future<UserModel> fetchUserInfo() async {
    final response = await _sendWithRetry(
      (token) => http.get(Uri.parse('$baseURL/me'), headers: _headers(token)),
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (decoded is Map && decoded.containsKey('user')) {
        return UserModel(
          name: decoded['user']['name'],
          email: decoded['user']['email'],
          address: decoded['user']['address'],
          phone: decoded['user']['phone'],
        );
      }
      return UserModel.fromJson(decoded);
    } else {
      throw Exception(_parseError(decoded, response, "Failed to load user"));
    }
  }

  /// Update User Info
  Future<UserModel> updateUser(UserModel user) async {
    final response = await _sendWithRetry(
      (token) => http.patch(
        Uri.parse('$baseURL/me'),
        headers: _headers(token),
        body: jsonEncode(user.toJson()),
      ),
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (decoded is Map && decoded.containsKey('user')) {
        return UserModel(
          name: decoded['user']['name'],
          email: decoded['user']['email'],
          address: decoded['user']['address'],
          phone: decoded['user']['phone'],
        );
      }
      return UserModel.fromJson(decoded);
    } else {
      throw Exception(_parseError(decoded, response, "Failed to update user"));
    }
  }

  /// Change Password
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final response = await _sendWithRetry(
      (token) => http.patch(
        Uri.parse('$baseURL/change-password'),
        headers: _headers(token),
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      final decoded = jsonDecode(response.body);
      throw Exception(
        _parseError(decoded, response, "Failed to change password"),
      );
    }
  }

  /// Parse backend error message
  String _parseError(dynamic decoded, http.Response response, String fallback) {
    String message = fallback;
    try {
      if (decoded is Map && decoded.containsKey('error')) {
        message = decoded['error'];
      } else if (decoded is Map && decoded.containsKey('message')) {
        message = decoded['message'];
      }
    } catch (_) {
      message = response.body;
    }
    return message;
  }
}
