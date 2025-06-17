import 'package:flutter/material.dart';
import '/constants.dart';

// RoleBasedBottomNavBar: Shows navigation bar items based on the user's role.
// Admin/Exec/Director: Home, QR Scanner, Profile
// Member/Participant: Home, My Events, Profile

class RoleBasedBottomNavBar extends StatefulWidget {
  final int currentIndex; // Currently selected tab index
  final Function(int) onTap; // Callback for tab selection
  final String role; // User role string

  const RoleBasedBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.role,
  });

  @override
  State<RoleBasedBottomNavBar> createState() => _RoleBasedBottomNavBarState();
}

// State for the role-based bottom navigation bar
class _RoleBasedBottomNavBarState extends State<RoleBasedBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    // The navigation bar is wrapped in SafeArea to avoid system UI overlap
    return SafeArea(
      top: false,
      child: Container(
        height: 70, // Fixed height for nav bar
        decoration: BoxDecoration(
          color: kWhite, // Background color
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            // Subtle shadow for elevation
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // Build navigation items based on user role
          children: _getNavItems(),
        ),
      ),
    );
  }

  // Returns the list of navigation items based on user role
  // Admin/Exec/Director: Home, QR Scanner, Profile
  // Member/Participant: Home, My Events, Profile
  List<Widget> _getNavItems() {
    // Check for admin-like roles (case-sensitive, can be improved for normalization)
    final isAdmin =
        widget.role == 'admin' ||
        widget.role == 'execcommittee' ||
        widget.role == 'exec_com' ||
        widget.role == 'programdirector' ||
        widget.role == 'prog_director';
    if (isAdmin) {
      return [
        _buildNavItem(0, 'assets/icons/home.png', 'Home'),
        _buildNavItem(1, Icons.qr_code_scanner, 'Scanner', isIcon: true),
        _buildNavItem(2, 'assets/icons/profile.png', 'Profile'),
      ];
    } else {
      return [
        _buildNavItem(0, 'assets/icons/home.png', 'Home'),
        _buildNavItem(1, 'assets/icons/folder.png', 'My Events'),
        _buildNavItem(2, 'assets/icons/profile.png', 'Profile'),
      ];
    }
  }

  // Builds a single navigation item (icon and label)
  // index: tab index, icon: asset path or IconData, label: tab label
  // isIcon: true if using a Material icon, false for asset image
  Widget _buildNavItem(
    int index,
    dynamic icon,
    String label, {
    bool isIcon = false,
  }) {
    bool isSelected = widget.currentIndex == index;
    const double iconSize = 24.0;
    const double fontSize = 12.0;

    return GestureDetector(
      onTap: () => widget.onTap(index), // Notify parent of tab change
      child: Container(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top indicator bar for selected tab
            Container(
              width: 24,
              height: 4,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                gradient: isSelected ? kGreenGradient1 : null,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Icon (either Material or asset)
            isIcon
                ? Icon(
                  icon,
                  size: iconSize,
                  color: isSelected ? kGreen1 : kGreen1.withOpacity(0.5),
                )
                : ShaderMask(
                  shaderCallback: (Rect bounds) {
                    // Apply gradient to asset icon
                    return LinearGradient(
                      colors: kGreenGradient1.colors,
                      begin: kGreenGradient1.begin as Alignment,
                      end: kGreenGradient1.end as Alignment,
                    ).createShader(bounds);
                  },
                  child: Image.asset(
                    icon,
                    width: iconSize,
                    height: iconSize,
                    color: Colors.white,
                    opacity: AlwaysStoppedAnimation(isSelected ? 1.0 : 0.5),
                  ),
                ),
            const SizedBox(height: 4),
            // Tab label
            Opacity(
              opacity: isSelected ? 1.0 : 0.5,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: kGreen1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
