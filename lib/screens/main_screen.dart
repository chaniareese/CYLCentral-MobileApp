import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '/constants.dart';
// import '../screens/explore_screen.dart';  // Create this if it doesn't exist
// import '../screens/my_events_screen.dart';  // Create this if it doesn't exist
import '../components/navbar.dart';
import '../data/models/user_model.dart';

class MainScreen extends StatefulWidget {
  final User user;
  
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(user: widget.user),
      _buildPlaceholderScreen('Explore'),  // Replace with actual screen when available
      _buildPlaceholderScreen('My Events'),  // Replace with actual screen when available
      ProfileScreen(user: widget.user),
    ];
  }

  // Placeholder screen for tabs that aren't implemented yet
  Widget _buildPlaceholderScreen(String name) {
    return Scaffold(
      backgroundColor: kMint,
      appBar: AppBar(
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            color: kWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: kGreenGradient),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Text(
          '$name Screen - Coming Soon',
          style: const TextStyle(fontSize: 18, color: kGreen1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}