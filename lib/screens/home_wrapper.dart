// HomeWrapper: Decides which main screen to show based on user role after login.
// Converts the user map from AuthProvider to a User model and navigates accordingly.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../data/models/user_model.dart';
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

    // Convert user map to User model for type safety and role helpers
    final user = User.fromMap(userMap);
    //print('User role after login: \\${user.role}'); // Debug print
    final role = user.role?.toLowerCase().replaceAll(' ', '');

    // Decide which main screen to show based on role
    Widget destination;
    if (role == 'admin' ||
        role == 'programdirector' ||
        role == 'execcommittee') {
      destination = MainScreen(user: user); // Admin/Exec/Director
    } else if (role == 'member') {
      destination = MainScreen(user: user); // Member
    } else {
      destination = MainScreen(user: user); // Participant or fallback
    }

    // Use addPostFrameCallback to avoid navigation during build and guard context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (context) => destination));
      }
    });

    // Show loading indicator while navigating
    // TODO: Handle this more gracefully in UI
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
