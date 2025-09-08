import 'dart:convert';
import 'package:ec_ranking/models/user_model.dart';
import 'package:ec_ranking/viewmodels/user_viewmodel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const baseURL = 'https://xxlrn8p4-7000.uks1.devtunnels.ms/api/auth';

class AuthService {
  final prefs = SharedPreferencesAsync();

  Map<String, String> _defaultHeaders({String? token}) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// ✅ Common error parser
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

  /// Register User
  Future<bool> registerUser(UserModel user) async {
    final response = await http.post(
      Uri.parse('$baseURL/register'),
      headers: _defaultHeaders(),
      body: jsonEncode(user.toJson()),
    );

    final decoded = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      _handleAuthSuccess(decoded);
      return true;
    } else {
      throw Exception(
        _parseError(decoded, response, "Failed to register user"),
      );
    }
  }

  /// Login User
  Future<bool> loginUser(UserModel user) async {
    final response = await http.post(
      Uri.parse('$baseURL/login'),
      headers: _defaultHeaders(),
      body: jsonEncode(user.toJson()),
    );

    final decoded = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      _handleAuthSuccess(decoded);
      return true;
    } else if (response.statusCode == 401) {
      throw Exception("Invalid credentials. Please try again.");
    } else {
      throw Exception(_parseError(decoded, response, "Failed to login user"));
    }
  }

  /// ✅ Extract and save tokens + user info
  void _handleAuthSuccess(Map decoded) async {
    if (decoded.containsKey('user')) {
      final userData = decoded['user'];
      if (userData is Map) {
        UserViewModel().setUser(
          UserModel(
            name: userData['name'],
            email: userData['email'],
            address: userData['address'],
            phone: userData['phone'],
          ),
        );
      }
    }
    if (decoded.containsKey('tokens')) {
      final tokens = decoded['tokens'];
      if (tokens is Map) {
        await prefs.setString('accessToken', tokens['accessToken'] ?? '');
        await prefs.setString('refreshToken', tokens['refreshToken'] ?? '');
      }
    }
  }

  /// Refresh User token
  Future<bool> refreshToken() async {
    final accessToken = await prefs.getString('accessToken') ?? '';
    final refreshToken = await prefs.getString('refreshToken') ?? '';

    final response = await http.post(
      Uri.parse('$baseURL/refresh'),
      headers: _defaultHeaders(token: accessToken),
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    final decoded = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (decoded is Map && decoded.containsKey('tokens')) {
        final tokens = decoded['tokens'];
        await prefs.setString('accessToken', tokens['accessToken'] ?? '');
        await prefs.setString('refreshToken', tokens['refreshToken'] ?? '');
      }
      return true;
    } else {
      throw Exception(
        _parseError(decoded, response, "Failed to refresh token"),
      );
    }
  }

  /// Logout User (with retry if token expired)
  Future<bool> logoutUser({bool retrying = false}) async {
    final accessToken = await prefs.getString('accessToken') ?? '';

    final response = await http.post(
      Uri.parse('$baseURL/logout'),
      headers: _defaultHeaders(token: accessToken),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      UserViewModel().clearUser();
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');
      return true;
    } else if (response.statusCode == 401 && !retrying) {
      // token expired → refresh once
      final refreshed = await refreshToken();
      if (refreshed) {
        return await logoutUser(retrying: true);
      }
      return false;
    } else {
      final decoded = jsonDecode(response.body);
      throw Exception(_parseError(decoded, response, "Failed to logout user"));
    }
  }
}
