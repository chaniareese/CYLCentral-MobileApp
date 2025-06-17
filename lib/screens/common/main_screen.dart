import 'package:flutter/material.dart';
import '/screens/common/home_screen.dart';
import '/screens/common/profile_screen.dart';
import '/screens/admin/qr_scanner_screen.dart';
import '/screens/member/my_events_screen.dart';
// import '/constants.dart';
// import '../components/navbar_admin.dart';
// import '../components/navbar_member.dart';
import '/components/role_based_navbar.dart';
import '/data/models/user_model.dart';

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
    _currentIndex = 0; // Always reset index on init
    isAdmin = widget.user.isAdmin;
    if (isAdmin) {
      // Admin/Program Director/Exec Committee: Home, QR Scanner, Profile
      _screens = [
        HomeScreen(user: widget.user),
        const QRScannerScreen(),
        ProfileScreen(user: widget.user),
      ];
    } else {
      // Member/Participant: Home, My Events, Profile (removed Notifications)
      _screens = [
        HomeScreen(user: widget.user),
        const MyEventsScreen(),
        ProfileScreen(user: widget.user),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxIndex = isAdmin ? 2 : 2;
    final safeIndex = _currentIndex.clamp(0, maxIndex);
    final role = (widget.user.role ?? '').toLowerCase().replaceAll(' ', '');
    return Scaffold(
      body: _screens[safeIndex],
      bottomNavigationBar: RoleBasedBottomNavBar(
        currentIndex: safeIndex,
        onTap: (index) {
          if (index <= maxIndex) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        role: role,
      ),
    );
  }
}
