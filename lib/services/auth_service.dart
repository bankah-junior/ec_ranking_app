import 'dart:convert';
import 'package:ec_ranking/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const baseURL = 'https://xxlrn8p4-7000.uks1.devtunnels.ms/api/auth';

class AuthService {
  final prefs = SharedPreferencesAsync();

  /// Check if server is online
  Future<bool> healthCheck() async {
    final response = await http.get(
      Uri.parse("https://xxlrn8p4-7000.uks1.devtunnels.ms/api/health"),
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE',
      },
    );
    if (response.statusCode != 200 || response.statusCode != 201) {
      throw Exception('Server is down!!');
    }
    return true;
  }

  /// Register User
  Future<bool> registerUser(UserModel user) async {
    final response = await http.post(
      Uri.parse('$baseURL/register'),
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE',
      },
      body: jsonEncode(user.toJson()),
    );

    final decoded = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (decoded is Map && decoded.containsKey('tokens')) {
        final tokens = decoded['tokens'];
        if (tokens is Map) {
          await prefs.setString('accessToken', tokens['accessToken']);
          await prefs.setString('refreshToken', tokens['refreshToken']);
        }
      }
      return true;
    } else {
      String message = "Failed to register user";
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

  /// Login User
  Future<bool> loginUser(UserModel user) async {
    final response = await http.post(
      Uri.parse('$baseURL/login'),
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE',
      },
      body: jsonEncode(user.toJson()),
    );

    final decoded = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (decoded is Map && decoded.containsKey('tokens')) {
        final tokens = decoded['tokens'];
        if (tokens is Map) {
          await prefs.setString('accessToken', tokens['accessToken']);
          await prefs.setString('refreshToken', tokens['refreshToken']);
        }
      }
      return true;
    } else {
      String message = "Failed to login user";
      try {
        if (decoded is Map && decoded.containsKey('error')) {
          message = decoded['error'];
        } else if (decoded is Map && decoded.containsKey('message')) {
          message = decoded['message'];
        }
      } catch (_) {
        message = response.body;
      }
      // print(user.toJson());
      throw Exception(message);
    }
  }

  /// Refresh User token
  Future<bool> refreshToken() async {
    final String accessToken =
        await SharedPreferencesAsync().getString('accessToken') ?? '';
    final String refreshToken =
        await SharedPreferencesAsync().getString('refreshToken') ?? '';

    final response = await http.post(
      Uri.parse('$baseURL/refresh'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE',
      },
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    final decoded = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (decoded is Map && decoded.containsKey('refreshToken')) {
        await prefs.setString('refreshToken', decoded['refreshToken']);
      }
      return true;
    } else {
      String message = "Failed to refresh token";
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

  /// Logout User
  Future<bool> logoutUser() async {
    final response = await http.post(
      Uri.parse('$baseURL/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      await SharedPreferencesAsync().remove('accessToken');
      await SharedPreferencesAsync().remove('refreshToken');
      return true;
    } else {
      String message = "Failed to logout user";
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
