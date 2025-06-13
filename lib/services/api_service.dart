import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config.dart';

// API SERVICE CLASS - Sends login requests to the backend and receives the user data.

class ApiService {
  // Get API base URL from config (for general use)
  String get baseUrl => Config.apiBaseUrl;

  // Get server URL without /api suffix for direct PHP file access
  String get baseServerUrl {
    final url = Config.apiBaseUrl;
    if (url.endsWith('/api')) {
      return url.substring(0, url.length - 4);
    }
    return url;
  }

  // Clean PHP warnings or HTML from JSON responses (for buggy backend responses)
  String cleanJsonResponse(String response) {
    if (response.contains('<br />') ||
        response.contains('<b>') ||
        response.contains('Warning') ||
        response.contains('Notice')) {
      final jsonStart = response.indexOf('{');
      final jsonEnd = response.lastIndexOf('}') + 1;
      if (jsonStart >= 0 && jsonEnd > jsonStart) {
        final cleanedJson = response.substring(jsonStart, jsonEnd);
        developer.log(
          'Cleaned JSON response: Length before=${response.length}, after=${cleanedJson.length}',
          name: 'ApiService',
        );
        return cleanedJson;
      }
    }
    // Return original if it doesn't need cleaning
    return response;
  }

  // Store the auth token in memory (for quick access)
  String? _token;

  // Use secure storage for sensitive tokens
  static const _secureStorage = FlutterSecureStorage();

  // Get the stored token from memory or secure storage
  Future<String?> getToken() async {
    if (_token != null) return _token;
    // Try secure storage first
    final secureToken = await _secureStorage.read(key: 'token');
    if (secureToken != null) {
      _token = secureToken;
      return secureToken;
    }
    // Fallback to SharedPreferences for legacy support
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Save the auth token to memory and secure storage
  Future<void> setToken(String token) async {
    _token = token;
    await _secureStorage.write(key: 'token', value: token);
    // Also save to SharedPreferences for legacy support (optional)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Remove the auth token from memory and secure storage
  Future<void> clearToken() async {
    _token = null;
    await _secureStorage.delete(key: 'token');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Build headers for API requests (adds Authorization if token exists)
  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Test API connectivity (OPTIONAL, for diagnostics)
  Future<bool> testApiConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseServerUrl/direct_api.php'),
        headers: {'Accept': 'application/json'},
      );
      developer.log(
        'Direct API test status: ${response.statusCode}',
        name: 'ApiService',
      );
      developer.log(
        'Direct API test response: ${response.body}',
        name: 'ApiService',
      );
      return response.statusCode == 200;
    } catch (e) {
      developer.log('API connection test error', error: e, name: 'ApiService');
      return false;
    }
  }

  // LOGIN: Authenticate user and get token + user data
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final loginEndpoint = '$baseServerUrl/direct_api.php?action=login';
      developer.log('Trying login via: $loginEndpoint', name: 'ApiService');
      final response = await http.post(
        Uri.parse(loginEndpoint),
        headers: await _getHeaders(),
        body: jsonEncode({'email': email, 'password': password}),
      );
      developer.log(
        'Login response status: ${response.statusCode}',
        name: 'ApiService',
      );
      developer.log(
        'Login response body: ${response.body}',
        name: 'ApiService',
      );
      String cleanedBody = cleanJsonResponse(response.body);
      final data = jsonDecode(cleanedBody);
      if (response.statusCode == 200 && data['status'] == 'success') {
        if (data['token'] != null) {
          await setToken(data['token']);
          developer.log(
            'Token saved successfully from login',
            name: 'ApiService',
          );
        }
        return data;
      } else {
        throw Exception(
          data['message'] ?? 'Login failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      developer.log('Login error', error: e, name: 'ApiService');
      throw Exception('Login failed: $e');
    }
  }

  // REGISTER: Create a new user account
  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? contactNumber,
    String? birthdate,
    String? employmentStatus,
    String? company,
    String? region,
    String? province,
  }) async {
    try {
      final endpoint = '$baseServerUrl/direct_api.php?action=register';
      developer.log(
        'Registering user via direct API: $endpoint',
        name: 'ApiService',
      );
      final registrationData = {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
      };
      if (contactNumber != null && contactNumber.isNotEmpty) {
        registrationData['contact_number'] = contactNumber;
      }
      if (birthdate != null && birthdate.isNotEmpty) {
        registrationData['birthdate'] = birthdate;
      }
      if (employmentStatus != null && employmentStatus.isNotEmpty) {
        registrationData['employment_status'] = employmentStatus;
      }
      if (company != null && company.isNotEmpty) {
        registrationData['company'] = company;
      }
      if (region != null && region.isNotEmpty) {
        registrationData['region'] = region;
      }
      if (province != null && province.isNotEmpty) {
        registrationData['province'] = province;
      }
      developer.log('Registration data: $registrationData', name: 'ApiService');
      final response = await http.post(
        Uri.parse(endpoint),
        headers: await _getHeaders(),
        body: jsonEncode(registrationData),
      );
      developer.log(
        'Registration response status: ${response.statusCode}',
        name: 'ApiService',
      );
      developer.log(
        'Registration response body: ${response.body}',
        name: 'ApiService',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final cleanedBody = cleanJsonResponse(response.body);
        final responseData = jsonDecode(cleanedBody);
        if (responseData['status'] == 'success') {
          if (responseData['token'] != null) {
            await setToken(responseData['token']);
            developer.log(
              'Authentication token stored successfully',
              name: 'ApiService',
            );
          }
          return responseData;
        } else {
          throw Exception(responseData['message'] ?? 'Registration failed');
        }
      } else {
        try {
          final errorResponse = jsonDecode(response.body);
          throw Exception(
            errorResponse['message'] ??
                'Registration failed with status: ${response.statusCode}',
          );
        } catch (e) {
          throw Exception(
            'Registration failed with status: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      developer.log('Registration error', error: e, name: 'ApiService');
      throw Exception('Registration failed: $e');
    }
  }

  // GET PROFILE: Fetch the authenticated user's profile
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }
      final profileEndpoint = '$baseServerUrl/direct_api.php?action=profile';
      final response = await http.get(
        Uri.parse(profileEndpoint),
        headers: await _getHeaders(),
      );
      developer.log(
        'Profile response status: ${response.statusCode}',
        name: 'ApiService',
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to get profile');
      }
    } catch (e) {
      developer.log('Get profile error', error: e, name: 'ApiService');
      throw Exception('Failed to get profile: $e');
    }
  }

  // UPDATE PROFILE: Update the authenticated user's profile
  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> profileData,
  ) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }
      final profileEndpoint = '$baseServerUrl/direct_api.php?action=profile';
      final response = await http.put(
        Uri.parse(profileEndpoint),
        headers: await _getHeaders(),
        body: jsonEncode(profileData),
      );
      developer.log(
        'Update profile response status: ${response.statusCode}',
        name: 'ApiService',
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      developer.log('Update profile error', error: e, name: 'ApiService');
      throw Exception('Failed to update profile: $e');
    }
  }

  // CHANGE PASSWORD: Change the authenticated user's password
  Future<Map<String, dynamic>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }
      final endpoint = '$baseServerUrl/direct_api.php?action=change_password';
      final response = await http.post(
        Uri.parse(endpoint),
        headers: await _getHeaders(),
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );
      developer.log(
        'Change password response status: ${response.statusCode}',
        name: 'ApiService',
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to change password');
      }
    } catch (e) {
      developer.log('Change password error', error: e, name: 'ApiService');
      throw Exception('Failed to change password: $e');
    }
  }

  // LOGOUT: Clear the user's token (local only)
  Future<void> logout() async {
    try {
      await clearToken();
    } catch (e) {
      developer.log('Logout error', error: e, name: 'ApiService');
      await clearToken();
    }
  }
}
