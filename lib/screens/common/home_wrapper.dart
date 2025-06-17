// HomeWrapper: Decides which main screen to show based on user role after login.
// Converts the user map from AuthProvider to a User model and navigates accordingly.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/data/models/user_model.dart';
import 'main_screen.dart';

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userMap = authProvider.user;

    // Show loading indicator if user data is not yet available
    // TODO: Handle this more gracefully in UI
    if (userMap == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Convert user map to User model and return the appropriate screen directly
    final user = User.fromMap(userMap);
    return MainScreen(user: user);
  }
}
