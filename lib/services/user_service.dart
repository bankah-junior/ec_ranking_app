import 'dart:convert';
import 'package:ec_ranking/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const baseURL = 'http://10.0.2.2:7000/api/users';

class UserService {
  final prefs = SharedPreferencesAsync();

  /// Fetch User Info
  Future<UserModel> fetchUser() async {
    final String accessToken =
        await SharedPreferencesAsync().getString('accessToken') ?? '';

    final response = await http.get(
      Uri.parse('$baseURL/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
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
      } else {
        return UserModel.fromJson(jsonDecode(response.body));
      }
    } else {
      String message = "Failed to load user";
      try {
        if (decoded is Map && decoded.containsKey('error')) {
          message = decoded['error'];
        } else if (decoded is Map && decoded.containsKey('message')) {
          message = decoded['message'];
        }
      } catch (_) {
        message = response.body;
      }
      throw Exception(message);
    }
  }

  /// Update User Info
  Future<UserModel> updateUser(UserModel user) async {
    final String accessToken =
        await SharedPreferencesAsync().getString('accessToken') ?? '';

    final response = await http.patch(
      Uri.parse('$baseURL/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(user.toJson()),
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
      } else {
        return UserModel.fromJson(jsonDecode(response.body));
      }
    } else {
      String message = "Failed to update user";
      try {
        if (decoded is Map && decoded.containsKey('error')) {
          message = decoded['error'];
        } else if (decoded is Map && decoded.containsKey('message')) {
          message = decoded['message'];
        }
      } catch (_) {
        message = response.body;
      }
      throw Exception(message);
    }
  }

  /// Change User Password
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final String accessToken =
        await SharedPreferencesAsync().getString('accessToken') ?? '';

    final response = await http.patch(
      Uri.parse('$baseURL/change-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode != 200 || response.statusCode != 201) {
      String message = "Failed to change password";
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded.containsKey('error')) {
          message = decoded['error'];
        } else if (decoded is Map && decoded.containsKey('message')) {
          message = decoded['message'];
        }
      } catch (_) {
        message = response.body;
      }
      throw Exception(message);
    }
  }
}
