import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import '/constants.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70, // Total navbar height
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
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
        children: [
          _buildNavItem(0, 'assets/icons/home.png', 'Home'),
          _buildNavItem(1, 'assets/icons/explore.png', 'Explore'),
          _buildNavItem(2, 'assets/icons/folder.png', 'My Events'),
          _buildNavItem(3, 'assets/icons/profile.png', 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath, String label) {
    bool isSelected = widget.currentIndex == index;
    bool isExplore = label == 'Explore';
    double iconSize = isExplore ? 32.0 : 24.0; // Bigger icon for Explore
    double fontSize = isExplore ? 14.0 : 12.0; // Bigger text for Explore

    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: Container(
        width: isExplore ? 80 : 70, // Wider container for Explore
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top indicator
            Container(
              width: 24,
              height: 4,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                gradient: isSelected ? kGreenGradient1 : null,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Icon with gradient
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: kGreenGradient1.colors,
                  begin: kGreenGradient1.begin as Alignment,
                  end: kGreenGradient1.end as Alignment,
                ).createShader(bounds);
              },
              child: Image.asset(
                iconPath,
                width: iconSize,
                height: iconSize,
                color:
                    Colors
                        .white, // The color will be overridden by gradient shader
                opacity: AlwaysStoppedAnimation(
                  isSelected ? 1.0 : 0.5,
                ), // 50% opacity when not selected
              ),
            ),
            const SizedBox(height: 4),
            // Label
            Opacity(
              opacity:
                  isSelected
                      ? 1.0
                      : 0.5, // Apply 50% opacity for inactive items
              child: Text(
                label,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight:
                      isSelected
                          ? FontWeight.w600
                          : FontWeight.w400, // SemiBold only when active
                  color: kGreen1, // Using green1 color directly
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
