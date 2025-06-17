import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  // Simulate fetching unread notifications from backend
  Future<void> fetchUnreadCount() async {
    // TODO: Replace with real API call
    await Future.delayed(const Duration(milliseconds: 500));
    // Example: set to 0 or any number for demo
    _unreadCount = 0;
    notifyListeners();
  }

  // Call this when notifications are read
  void markAllAsRead() {
    _unreadCount = 0;
    notifyListeners();
  }

  // For demo/testing: set count
  void setUnreadCount(int count) {
    _unreadCount = count;
    notifyListeners();
  }
}
