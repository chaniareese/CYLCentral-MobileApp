import 'package:flutter/material.dart';

class BottomNavBarAdmin extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const BottomNavBarAdmin({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner),
          label: 'QR Scanner',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
