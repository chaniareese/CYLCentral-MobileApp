//------------- Imports -------------//
import 'package:flutter/material.dart';
import 'dart:async';
import 'onboarding_screen.dart';
import 'package:cylcentral_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

//------------- Splash Screen Widget -------------//
/// Main splash screen that shows app logo with fade animation
/// Automatically navigates after 5 seconds based on user onboarding status
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

//------------- Splash Screen State -------------//
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Controls fade animation timing
  late Animation<double> _fadeAnimation; // Opacity transition curve

  //------- Initialization -------//
  @override
  void initState() {
    super.initState();
    // Setup fade animation with 800ms duration
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward(); // Start animation immediately

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _startNavigationTimer(); // Begin 5-second countdown
  }

  //------- Navigation Logic -------//
  /// Checks onboarding status and navigates accordingly after 5 seconds
  /// First-time users → Onboarding screen
  /// Returning users → Login screen
  void _startNavigationTimer() async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedOnboarding =
        prefs.getBool('hasCompletedOnboarding') ?? false;
    final userRole = prefs.getString('user_role');
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        // Safety check to prevent navigation on disposed widget
        if (hasCompletedOnboarding) {
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OnboardingScreen()),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Cleanup animation controller
    super.dispose();
  }

  //------- Build UI -------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMint, // Custom mint green background
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset(
            'assets/images/logo.gif', // Animated logo asset
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
