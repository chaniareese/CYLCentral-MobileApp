import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class ApiService {
  // Using dynamic API URL from Config class
  String get baseUrl => Config.apiBaseUrl;

  // Get the base URL without /api for direct API file access
  String get baseServerUrl {
    final url = Config.apiBaseUrl;
    if (url.endsWith('/api')) {
      return url.substring(0, url.length - 4);
    }
    return url;
  }

  // Utility function to clean PHP warnings from JSON responses
  String cleanJsonResponse(String response) {
    // If response contains HTML/PHP warnings
    if (response.contains('<br />') ||
        response.contains('<b>') ||
        response.contains('Warning') ||
        response.contains('Notice')) {
      // Extract valid JSON from the response
      final jsonStart = response.indexOf('{');
      final jsonEnd = response.lastIndexOf('}') + 1;

      if (jsonStart >= 0 && jsonEnd > jsonStart) {
        final cleanedJson = response.substring(jsonStart, jsonEnd);
        print(
          'Cleaned JSON response: Length before=${response.length}, after=${cleanedJson.length}',
        );
        return cleanedJson;
      }
    }
    // Return original if it doesn't need cleaning
    return response;
  }

  // Store the auth token
  String? _token;

  // Get the stored token
  Future<String?> getToken() async {
    if (_token != null) return _token;

    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Save the auth token
  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Clear the auth token on logout
  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Headers with authentication token
  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Test API connectivity with direct API file
  Future<bool> testApiConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseServerUrl/direct_api.php'),
        headers: {'Accept': 'application/json'},
      );

      print('Direct API test status: ${response.statusCode}');
      print('Direct API test response: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('API connection test error: $e');
      return false;
    }
  }

  // Login using direct API
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final loginEndpoint = '$baseServerUrl/direct_api.php?action=login';
      print('Trying login via: $loginEndpoint');

      final response = await http.post(
        Uri.parse(loginEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );
      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      // Use the utility method to clean any PHP warnings from the response
      String cleanedBody = cleanJsonResponse(response.body);

      final data = jsonDecode(cleanedBody);

      if (response.statusCode == 200 && data['status'] == 'success') {
        if (data['token'] != null) {
          await setToken(data['token']);
          print('Token saved successfully from login');
        }
        return data;
      } else {
        throw Exception(
          data['message'] ?? 'Login failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Login error: $e');
      throw Exception('Login failed: $e');
    }
  }

  // Register a new user
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
      print('Registering user via direct API: $endpoint');

      // Prepare registration data
      final registrationData = {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
      };

      // Add optional fields if they're not null
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

      print('Registration data: $registrationData');

      // Send registration request
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(registrationData),
      );
      print('Registration response status: ${response.statusCode}');
      print('Registration response body: ${response.body}');

      // Parse the response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final cleanedBody = cleanJsonResponse(response.body);
        final responseData = jsonDecode(cleanedBody);

        if (responseData['status'] == 'success') {
          // Store the authentication token
          if (responseData['token'] != null) {
            await setToken(responseData['token']);
            print('Authentication token stored successfully');
          }
          return responseData;
        } else {
          throw Exception(responseData['message'] ?? 'Registration failed');
        }
      } else {
        // Try to parse error response
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
      print('Registration error: $e');
      throw Exception('Registration failed: $e');
    }
  }

  // Get user profile
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

      print('Profile response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to get profile');
      }
    } catch (e) {
      print('Get profile error: $e');
      throw Exception('Failed to get profile: $e');
    }
  }

  // Update user profile
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

      print('Update profile response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      print('Update profile error: $e');
      throw Exception('Failed to update profile: $e');
    }
  }

  // Change password
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

      print('Change password response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to change password');
      }
    } catch (e) {
      print('Change password error: $e');
      throw Exception('Failed to change password: $e');
    }
  }

  // Logout user
  Future<void> logout() async {
    try {
      // Just clear the token locally
      await clearToken();
    } catch (e) {
      print('Logout error: $e');
      // Still clear token locally even if API call fails
      await clearToken();
    }
  }
}
