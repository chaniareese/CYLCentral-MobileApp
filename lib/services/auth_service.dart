import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isAuthenticated = false;
  Map<String, dynamic>? _userData;
  
  // Getters
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get userData => _userData;
  
  // Initialize auth state
  Future<void> init() async {
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
      }
    }
    notifyListeners();
  }
  
  // Login
  Future<void> login({required String email, required String password}) async {
    try {
      // First test if API is reachable
      final isConnected = await _apiService.testApiConnection();
      if (!isConnected) {
        throw Exception('Cannot connect to the server. Please check your network connection.');
      }
      
      // Try login
      final loginData = await _apiService.login(email: email, password: password);
      _isAuthenticated = true;
      _userData = loginData['user'];
      notifyListeners();
    } catch (e) {
      _isAuthenticated = false;
      _userData = null;
      rethrow;
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
      notifyListeners();
    } catch (e) {
      _isAuthenticated = false;
      _userData = null;
      rethrow;
    }
  }
  
  // Logout
  Future<void> logout() async {
    await _apiService.logout();
    _isAuthenticated = false;
    _userData = null;
    notifyListeners();
  }
}