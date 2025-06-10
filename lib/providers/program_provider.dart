import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../data/models/program_model.dart';

class ProgramProvider with ChangeNotifier {
  List<Program> _programs = [];
  bool _isLoading = false;
  String? _error;

  List<Program> get programs => _programs;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> fetchPrograms() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try both API endpoints - first the direct_api.php
      print('Attempting to fetch programs from direct_api.php...');
      
      final response = await http.get(
        Uri.parse('${kApiBaseUrl}/direct_api.php?action=programs'),
        headers: {'Accept': 'application/json'},
      );
      
      print('Programs API Response Status: ${response.statusCode}');
      print('Programs API Response Body: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['status'] == 'success' && responseData.containsKey('data')) {
          // Process the response from direct_api.php
          _programs = (responseData['data'] as List)
              .map((program) => Program.fromJson(program))
              .toList();
          
          print('Successfully fetched ${_programs.length} programs from direct_api.php');
        } else {
          // If direct_api.php doesn't work, try the Laravel API route
          print('direct_api.php returned error or invalid format, trying Laravel API...');
          await _fetchFromLaravelApi();
        }
      } else {
        // If direct_api.php fails, try the Laravel API route
        print('direct_api.php request failed with status ${response.statusCode}, trying Laravel API...');
        await _fetchFromLaravelApi();
      }
    } catch (e) {
      print('Error fetching programs from direct_api.php: $e');
      
      // Try the Laravel API as fallback
      try {
        await _fetchFromLaravelApi();
      } catch (innerE) {
        print('Error fetching programs from Laravel API: $innerE');
        _error = 'Network error: Unable to connect to either API endpoint';
        _programs = []; // Reset to empty list on error
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> _fetchFromLaravelApi() async {
    print('Attempting to fetch programs from Laravel API...');
    
    final laravelResponse = await http.get(
      Uri.parse('${kApiBaseUrl}/api/programs'),
      headers: {'Accept': 'application/json'},
    );
    
    print('Laravel API Response Status: ${laravelResponse.statusCode}');
    print('Laravel API Response Body: ${laravelResponse.body}');
    
    if (laravelResponse.statusCode == 200) {
      final Map<String, dynamic> laravelData = json.decode(laravelResponse.body);
      
      if (laravelData['success'] == true && laravelData.containsKey('data')) {
        _programs = (laravelData['data'] as List)
            .map((program) => Program.fromJson(program))
            .toList();
            
        print('Successfully fetched ${_programs.length} programs from Laravel API');
      } else {
        _error = 'Failed to load programs: ${laravelData['message'] ?? 'API returned invalid format'}';
        _programs = [];
      }
    } else {
      _error = 'Server error: ${laravelResponse.statusCode}';
      _programs = [];
    }
  }
  
  // // Method to generate dummy programs data for testing UI when API fails
  // void generateDummyData() {
  //   _programs = List.generate(
  //     4,
  //     (index) => Program(
  //       id: 'P00${index + 1}',
  //       name: 'Sample Program ${index + 1}',
  //       description: 'This is a sample program description for testing the UI layout.',
  //       programType: 'Workshop',
  //       logo: null,
  //       programHeaderPhoto: null,
  //       totalEvents: index + 1,
  //       programStatus: 'Active',
  //       publicationStatus: 'Published',
  //       establishmentDate: '2025-01-01',
  //     ),
  //   );
  //   _isLoading = false;
  //   _error = null;
  //   notifyListeners();
  // }
}