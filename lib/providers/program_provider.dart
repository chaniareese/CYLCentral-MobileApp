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
      final response = await http.get(
        Uri.parse('${kApiBaseUrl}/direct_api.php?action=programs'),
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 'success' &&
            responseData.containsKey('data')) {
          _programs = (responseData['data'] as List<dynamic>)
              .map((program) => Program.fromJson(program))
              .toList();
          debugPrint('Fetched programs count: ${_programs.length}');
        } else {
          // Try Laravel API as fallback
          await _fetchFromLaravelApi();
        }
      } else {
        // Try Laravel API as fallback
        await _fetchFromLaravelApi();
      }
    } catch (e) {
      // Try Laravel API as fallback
      try {
        await _fetchFromLaravelApi();
      } catch (innerE) {
        _error = 'Network error: Unable to connect to either API endpoint';
        _programs = [];
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchFromLaravelApi() async {
    final laravelResponse = await http.get(
      Uri.parse('${kApiBaseUrl}/api/programs'),
      headers: {'Accept': 'application/json'},
    );
    if (laravelResponse.statusCode == 200) {
      final Map<String, dynamic> laravelData = json.decode(laravelResponse.body);
      if (laravelData['success'] == true && laravelData.containsKey('data')) {
        _programs = (laravelData['data'] as List<dynamic>)
            .map((program) => Program.fromJson(program))
            .toList();
        debugPrint('Fetched programs count (Laravel): ${_programs.length}');
      } else {
        _error =
            'Failed to load programs: ${laravelData['message'] ?? 'API returned invalid format'}';
        _programs = [];
      }
    } else {
      _error = 'Server error: ${laravelResponse.statusCode}';
      _programs = [];
    }
  }
}
