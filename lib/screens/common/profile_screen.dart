import 'package:flutter/material.dart';
import '/constants.dart';
import '/data/models/user_model.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import 'edit_profile_screen.dart'; // <-- Import the EditProfileScreen

class ProfileScreen extends StatelessWidget {
  final User? user;

  const ProfileScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser =
        user ??
        (authProvider.user != null ? User.fromMap(authProvider.user!) : null);

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
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          // Profile Image
          CircleAvatar(
            radius: 48,
            backgroundColor: kGreen2.withOpacity(0.2),
            backgroundImage:
                (currentUser.profilePicture != null &&
                        currentUser.profilePicture!.isNotEmpty)
                    ? NetworkImage(currentUser.profilePicture!)
                    : null,
            child:
                (currentUser.profilePicture == null ||
                        currentUser.profilePicture!.isEmpty)
                    ? const Icon(Icons.person, size: 48, color: kGreen1)
                    : null,
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
          const SizedBox(height: 32),
          // Main options
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                _buildProfileListTile(
                  context,
                  icon: Icons.edit,
                  label: 'Edit Profile',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => EditProfileScreen(user: currentUser),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _buildProfileListTile(
                  context,
                  icon: Icons.lock,
                  label: 'Password',
                  onTap: () {
                    // TODO: Navigate to password screen
                  },
                ),
                const SizedBox(height: 8),
                _buildProfileListTile(
                  context,
                  icon: Icons.card_membership,
                  label: 'Membership',
                  onTap: () {
                    // TODO: Navigate to membership screen
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                gradient: kGreenGradient1,
                borderRadius: BorderRadius.circular(24),
              ),
              child: ElevatedButton.icon(
                onPressed: () async {
                  await authProvider.logout();
                  if (context.mounted) {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/login', (route) => false);
                  }
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  'LOG OUT',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileListTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: kGreenGradient1,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
        alignment: Alignment.center,
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: kGreen1,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: kGreen1),
      onTap: onTap,
    );
  }
}
