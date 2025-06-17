import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../data/models/event_model.dart';
import '../config/api_config.dart';

class EventProvider with ChangeNotifier {
  List<Event> _events = [];
  bool _isLoading = false;
  String? _error;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Helper: Parse JSON safely, handling malformed API responses
  Map<String, dynamic>? _safeParseJson(String responseBody) {
    try {
      // Handle concatenated JSON objects (API info + data)
      if (responseBody.contains('}{')) {
        final parts = responseBody.split('}{');
        if (parts.length >= 2) {
          final eventsJson = '{' + parts[1];
          return json.decode(eventsJson);
        }
      }
      // Try direct parse
      return json.decode(responseBody);
    } catch (_) {
      // Try to extract any valid JSON with a 'data' field
      final RegExp jsonPattern = RegExp(r'(\{.*\})');
      final matches = jsonPattern.allMatches(responseBody);
      for (final match in matches) {
        final possibleJson = match.group(0);
        if (possibleJson != null) {
          try {
            final jsonData = json.decode(possibleJson);
            if (jsonData is Map<String, dynamic> &&
                jsonData.containsKey('data')) {
              return jsonData;
            }
          } catch (_) {}
        }
      }
      // Fallback: try last JSON object
      if (matches.isNotEmpty) {
        final lastMatch = matches.last.group(0);
        if (lastMatch != null) {
          try {
            return json.decode(lastMatch);
          } catch (_) {}
        }
      }
      return null;
    }
  }

  Future<void> fetchEvents({int limit = 10}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.directApiUrl}?action=events&limit=$limit'),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final jsonData = _safeParseJson(response.body);
        if (jsonData != null && jsonData.containsKey('data')) {
          _events = List<Event>.from(
            jsonData['data'].map((item) => Event.fromJson(item)),
          );
          debugPrint('Fetched events count: ${_events.length}');
        } else {
          _events = [];
          debugPrint('Fetched events count: 0');
        }
      } else {
        _events = [];
        debugPrint('Fetched events count: 0');
      }
    } catch (e) {
      _error = 'Error fetching events: $e';
      _events = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchEventsByProgram(String programId, {int limit = 10}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await http
          .get(
            Uri.parse(
              '${ApiConfig.directApiUrl}?action=events&program_id=$programId&limit=$limit',
            ),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final jsonData = _safeParseJson(response.body);
        if (jsonData != null && jsonData.containsKey('data')) {
          _events = List<Event>.from(
            jsonData['data'].map((item) => Event.fromJson(item)),
          );
        } else {
          _events = [];
        }
      } else {
        _events = [];
      }
    } catch (e) {
      _error = 'Error fetching events: $e';
      _events = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}