import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import '../services/api_service.dart';

// AuthProvider: Handles authentication state, login, registration, profile, and logout for the app.
class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isAuthenticated = false; // True if user is logged in
  bool _isLoading = false; // True if an auth-related request is in progress
  Map<String, dynamic>? _userData; // Stores user profile data
  String? _errorMessage; // Stores error messages for UI

  // Getters for state and user data
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get userData => _userData;
  Map<String, dynamic>? get user => _userData; // Alias getter for compatibility
  String? get errorMessage => _errorMessage;

  // Initialize authentication state on app start
  // Checks for saved token and fetches user profile if available
  Future<void> initializeAuth() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _apiService.getToken();
      if (token != null) {
        _isAuthenticated = true;
        try {
          // Get user profile if token exists
          final profileData = await _apiService.getProfile();
          _userData = profileData['user'];
        } catch (e) {
          // Token might be invalid, clear it
          developer.log(
            'Failed to get profile with token',
            error: e,
            name: 'AuthProvider',
          );
          await _apiService.clearToken();
          _isAuthenticated = false;
          _userData = null;
          _errorMessage = "Session expired. Please log in again.";
        }
      }
    } catch (e) {
      developer.log('Error initializing auth', error: e, name: 'AuthProvider');
      _errorMessage = "Failed to initialize authentication.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Backwards compatibility with old method name
  Future<void> init() async {
    await initializeAuth();
  }

  // Login with email and password
  // On success, saves user data and sets authenticated state
  Future<void> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final loginData = await _apiService.login(
        email: email,
        password: password,
      );

      // Check if we have user data
      if (loginData['user'] != null) {
        _userData = loginData['user'];
        _isAuthenticated = true;
      } else if (loginData['status'] == 'success') {
        // If no user data but success, set minimal data
        _userData = {'email': email};
        _isAuthenticated = true;
      } else {
        throw Exception('Login response missing user data');
      }
    } catch (e) {
      _isAuthenticated = false;
      _userData = null;
      _errorMessage = e.toString();
      rethrow; // TODO: Handle errors more gracefully in UI
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register a new user
  // On success, saves user data and sets authenticated state
  Future<void> register({
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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final registerData = await _apiService.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        contactNumber: contactNumber,
        birthdate: birthdate,
        employmentStatus: employmentStatus,
        company: company,
        region: region,
        province: province,
      );

      _isAuthenticated = true;
      _userData = registerData['user'];
    } catch (e) {
      _isAuthenticated = false;
      _userData = null;
      _errorMessage = e.toString();
      rethrow; // TODO: Handle errors more gracefully in UI
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user profile
  // Accepts a map of profile fields to update
  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.updateProfile(profileData);
      _userData = result['user'];
    } catch (e) {
      _errorMessage = e.toString();
      rethrow; // TODO: Handle errors more gracefully in UI
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Change user password
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.changePassword(currentPassword, newPassword);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow; // TODO: Handle errors more gracefully in UI
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout user and clear local state
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.logout();
    } catch (e) {
      developer.log('Logout error', error: e, name: 'AuthProvider');
    } finally {
      // Always clear local data even if server logout fails
      _isAuthenticated = false;
      _userData = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error message for UI
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
