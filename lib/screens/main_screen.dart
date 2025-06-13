import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/admin/qr_scanner_screen.dart';
import '../screens/member/notifications_screen.dart';
import '../screens/member/my_events_screen.dart';
// import '/constants.dart';
// import '../components/navbar_admin.dart';
// import '../components/navbar_member.dart';
import '../components/role_based_navbar.dart';
import '../data/models/user_model.dart';

// MainScreen: The main navigation screen for the app.
// Shows different navigation tabs and screens based on user role.
class MainScreen extends StatefulWidget {
  final User user; // The logged-in user

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // Tracks the selected tab
  late List<Widget> _screens; // List of screens for navigation
  late bool isAdmin =
      false; // True if user is admin, program director, or exec committee

  @override
  void initState() {
    super.initState();
    // Determine user role and set up navigation tabs
    // (Replace print with logger in production)
    // print('MainScreen user role: ${widget.user.role}');
    isAdmin = widget.user.isAdmin;
    if (isAdmin) {
      // Admin/Program Director/Exec Committee: Home, QR Scanner, Profile
      _screens = [
        HomeScreen(user: widget.user),
        QRScannerScreen(),
        ProfileScreen(user: widget.user),
      ];
    } else {
      // Member/Participant: Home, Notifications, My Events, Profile
      _screens = [
        HomeScreen(user: widget.user),
        NotificationsScreen(),
        MyEventsScreen(),
        ProfileScreen(user: widget.user),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the role string directly from the user model for the nav bar
    final userRole = widget.user.role ?? 'participant';
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: RoleBasedBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        role: userRole,
      ),
    );
  }
}
