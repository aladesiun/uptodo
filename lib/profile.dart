import 'package:flutter/material.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Title
              const Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Lato',
                ),
              ),
              const SizedBox(height: 24),
              // Profile Image
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF8875FF), width: 2),
                ),
                child: ClipOval(
                  child: Container(
                    color: const Color(0xFF1D1D1D),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Color(0xFF535353),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // User Name
              const Text(
                'Martha Hays',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Lato',
                ),
              ),
              const SizedBox(height: 20),
              // Stats Row
              Row(
                children: [
                  Expanded(child: _buildStatButton('10 Task left')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatButton('5 Task done')),
                ],
              ),
              const SizedBox(height: 32),
              // Settings Section
              _buildSectionTitle('Settings'),
              const SizedBox(height: 16),
              _buildMenuItem(
                icon: Icons.settings_outlined,
                title: 'App Settings',
                onTap: () {},
              ),
              const SizedBox(height: 24),
              // Account Section
              _buildSectionTitle('Account'),
              const SizedBox(height: 16),
              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'Change account name',
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _buildMenuItem(
                icon: Icons.key_outlined,
                title: 'Change account password',
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _buildMenuItem(
                icon: Icons.camera_alt_outlined,
                title: 'Change account Image',
                onTap: () {},
              ),
              const SizedBox(height: 24),
              // Uptodo Section
              _buildSectionTitle('Uptodo'),
              const SizedBox(height: 16),
              _buildMenuItem(
                icon: Icons.grid_view_rounded,
                title: 'About US',
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _buildMenuItem(
                icon: Icons.info_outline,
                title: 'FAQ',
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _buildMenuItem(
                icon: Icons.flash_on_outlined,
                title: 'Help & Feedback',
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _buildMenuItem(
                icon: Icons.thumb_up_outlined,
                title: 'Support US',
                onTap: () {},
              ),
              const SizedBox(height: 20),
              // Logout Button
              _buildLogoutButton(context),
              const SizedBox(height: 100), // Space for bottom nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF363636),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Lato',
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFAFAFAF),
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Lato',
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Lato',
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showLogoutDialog(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: const Row(
          children: [
            Icon(Icons.logout, color: Color(0xFFFF4949), size: 24),
            SizedBox(width: 16),
            Text(
              'Log out',
              style: TextStyle(
                color: Color(0xFFFF4949),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Lato',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF363636),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Lato',
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: Color(0xFFAFAFAF),
              fontSize: 14,
              fontFamily: 'Lato',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF8875FF),
                  fontSize: 14,
                  fontFamily: 'Lato',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Color(0xFFFF4949),
                  fontSize: 14,
                  fontFamily: 'Lato',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
