import 'package:flutter/material.dart';
import '/constants.dart';
import '/data/models/user_model.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  final User? user;

  const ProfileScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // If user is null, attempt to get it from auth provider
    final currentUser =
        user ??
        (authProvider.user != null ? User.fromMap(authProvider.user!) : null);

    // If we still don't have a user, show a loading indicator
    if (currentUser == null) {
      return Scaffold(
        backgroundColor: kMint,
        appBar: AppBar(
          title: const Text(
            'My Profile',
            style: TextStyle(
              fontSize: 16,
              color: kWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: kGreenGradient1),
          ),
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kGreen1),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kMint,
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontSize: 16,
            color: kWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: kGreenGradient1),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: kWhite),
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Profile Image
            CircleAvatar(
              radius: 60,
              backgroundColor: kGreen2.withOpacity(0.2),
              child:
                  currentUser.firstName.isNotEmpty &&
                          currentUser.lastName.isNotEmpty
                      ? Text(
                        '${currentUser.firstName[0]}${currentUser.lastName[0]}',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: kGreen1,
                        ),
                      )
                      : const Icon(Icons.person, size: 60, color: kGreen1),
            ),
            const SizedBox(height: 16),

            // User name
            Text(
              '${currentUser.firstName} ${currentUser.lastName}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kGreen1,
              ),
            ),
            const SizedBox(height: 4),

            // User email
            Text(
              currentUser.email,
              style: TextStyle(fontSize: 14, color: kGreen1.withOpacity(0.8)),
            ),
            const SizedBox(height: 24),

            // Profile details card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kGreen1,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildInfoRow(
                    'Contact Number',
                    currentUser.contactNumber ?? 'Not provided',
                  ),
                  const Divider(),
                  if (currentUser.region != null)
                    _buildInfoRow('Region', currentUser.region ?? ''),
                  if (currentUser.region != null) const Divider(),
                  if (currentUser.province != null)
                    _buildInfoRow('Province', currentUser.province ?? ''),
                  if (currentUser.province != null) const Divider(),
                  _buildInfoRow('Account Type', currentUser.role ?? 'Member'),
                  const Divider(),
                  _buildInfoRow(
                    'Joined',
                    currentUser.createdAt?.split(' ')[0] ?? 'Recently',
                  ),
                  const Divider(),

                  // Show user role for debugging/clarity
                  _buildInfoRow('Role', currentUser.role ?? 'Unknown'),
                  const Divider(),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Edit Profile Button
            _buildGreenGradientButton('Edit Profile', () {
              // Navigate to edit profile screen
            }),
            const SizedBox(height: 16),

            // Settings Button
            ElevatedButton(
              onPressed: () {
                // Navigate to settings screen
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: kGreen1,
                backgroundColor: Colors.white,
                side: BorderSide(color: kGreen1),
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Settings'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: kGreen1,
            ),
          ),
        ],
      ),
    );
  }

  // Implementing the GreenGradientButton here since it's missing
  Widget _buildGreenGradientButton(String text, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        gradient: kGreenGradient1,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: kGreen1.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
