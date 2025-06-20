import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/program_provider.dart'; // Add this import
import 'providers/event_provider.dart'; // Add this import for EventProvider
import 'providers/notification_provider.dart'; // Add this import for NotificationProvider
import 'screens/common/login_screen.dart';
import 'screens/common/register_screen.dart';
import 'screens/common/home_screen.dart';
import 'screens/common/splash_screen.dart';
import 'screens/common/onboarding_screen.dart';
import 'screens/common/main_screen.dart';
import 'screens/common/profile_screen.dart';
// import 'screens/explore_screen.dart'; // Make sure to import explore_screen.dart
// import 'screens/member/my_events_screen.dart'; // Make sure to import my_events_screen.dart
import 'data/models/user_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProgramProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()), // Add this line
        ChangeNotifierProvider(create: (_) => NotificationProvider()), // Add this line
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CYLCentral',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          fontFamily: 'Poppins',
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          // '/get_started': (context) => const GetStartedScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeWrapper(),
        },
      ),
    );
  }
}

// This wrapper ensures user data is properly passed to MainScreen
class HomeWrapper extends StatelessWidget {
  const HomeWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userMap = authProvider.user;

    if (userMap == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Convert user map to User model
    final user = User.fromMap(userMap);

    // Navigate to the main screen with the user data
    return MainScreen(user: user);
  }
}
