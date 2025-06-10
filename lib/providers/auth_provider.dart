import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isAuthenticated = false;
  bool _isLoading = false;
  Map<String, dynamic>? _userData;
  String? _errorMessage;
  
  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get userData => _userData;
  Map<String, dynamic>? get user => _userData; // Alias getter for compatibility
  String? get errorMessage => _errorMessage;
  
  // Initialize auth state
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
          print('Failed to get profile with token: $e');
          await _apiService.clearToken();
          _isAuthenticated = false;
          _userData = null;
          _errorMessage = "Session expired. Please log in again.";
        }
      }
    } catch (e) {
      print('Error initializing auth: $e');
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
  
  // Login
  Future<void> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final loginData = await _apiService.login(
        email: email, 
        password: password
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
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Register
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
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Update profile
  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final result = await _apiService.updateProfile(profileData);
      _userData = result['user'];
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Change password
  Future<void> changePassword(String currentPassword, String newPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      await _apiService.changePassword(currentPassword, newPassword);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _apiService.logout();
    } catch (e) {
      print('Logout error: $e');
    } finally {
      // Always clear local data even if server logout fails
      _isAuthenticated = false;
      _userData = null;
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}