import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uptodo/auth/core/auth_controller.dart';
import 'package:uptodo/auth/widgets/customTextField.dart';
import 'package:uptodo/auth/widgets/primaryButton.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  Map<String, dynamic> _userProfile = {};
   final AuthController authController = Get.find<AuthController>();
  void _showChangeNameDialog() {
    final TextEditingController nameController = TextEditingController(
      text: _userProfile['fullname'] ?? "",
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0xFF363636),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text(
                    'Change account name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Lato',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(color: Color(0xFF979797), thickness: 1),
                const SizedBox(height: 12),
                BuildTextField(
                  labelText: "",
                  hintText: "Enter your name",
                  controller: nameController,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF8875FF),
                            fontSize: 16,
                            fontFamily: 'Lato',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child:Obx(() => PrimaryButton(
                        onPressed: () {
                         if(!authController.isLoading.value){
                            _handleUpdateName(nameController, context);
                          }
                        },
                        title: authController.isLoading.value ? 'Updating...':'Edit',
                        disabled: authController.isLoading.value,
                      )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF363636),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Change account Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Lato',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(color: Color(0xFF979797), thickness: 1),
                const SizedBox(height: 10),
                BuildTextField(
                  controller: oldPasswordController,
                  hintText: '••••••••••••',
                  labelText: 'Enter old password',
                  isObscureText: true,
                ),
                const SizedBox(height: 20),
                BuildTextField(
                  controller: newPasswordController,
                  hintText: '••••••••••••',
                  labelText: 'Enter new password',
                  isObscureText: true,
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF8875FF),
                            fontSize: 16,
                            fontFamily: 'Lato',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _handleChangePassword(oldPasswordController, newPasswordController, context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8875FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Obx(() => Text(
                          authController.isLoading.value ? 'Changing...':'Edit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Lato',
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _getUserProfile() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userProfile = _prefs.getString('user_profile');
    if (userProfile != null) {
      setState(() {
        _userProfile = {
          ...jsonDecode(userProfile),
          'avatarUrl': 'https://picsum.photos/536/354'
        };
      });
    }
  }

  Future<void> _handleUpdateName(TextEditingController nameController, BuildContext context) async {
    if(nameController.text.isEmpty){
      Get.snackbar(
        'Error',
        'Name is required',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    final success = await authController.updateProfile(fullName: nameController.text);
    if(success){
      _getUserProfile();
      if(context.mounted){
        Navigator.pop(context);
      }
    }
  }
  Future<void> _handleChangePassword(TextEditingController oldPasswordController, 
  TextEditingController newPasswordController, BuildContext context
  ) async {
     if (oldPasswordController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Old password cannot be empty',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPasswordController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'New password cannot be empty',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }


    if (newPasswordController.text.trim().length < 6) {
      Get.snackbar(
        'Error',
        'New password must be at least 6 characters',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    final success = await authController.changePassword(
      oldPassword: oldPasswordController.text.trim(),
      newPassword: newPasswordController.text.trim(),
    );

    if(success){
      if(context.mounted){
        Navigator.pop(context);
      }
    }
  }
  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

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
              const SizedBox(height: 16),
              // User Info
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(_userProfile['avatarUrl'] ?? ""),
              ),
              const SizedBox(height: 16),
              Text(
                _userProfile['fullname'] ?? "",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Lato',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildStatButton('10 Task left')),
                  const SizedBox(width: 20),
                  Expanded(child: _buildStatButton('5 task Done')),
                ],
              ),
              const SizedBox(height: 30),
              _buildSectionTitle("Settings"),
              const SizedBox(height: 10),
              _buildMenuItem(
                icon: Icons.settings_outlined,
                title: "App Settings",
                onTap: () {},
              ),
              const SizedBox(height: 24),
              // Account Section
              _buildSectionTitle('Account'),
              const SizedBox(height: 16),
              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'Change account name',
                onTap: () {
                  _showChangeNameDialog();
                },
              ),
              const SizedBox(height: 12),
              _buildMenuItem(
                icon: Icons.key_outlined,
                title: 'Change account password',
                onTap: () => _showChangePasswordDialog(),
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
              const SizedBox(height: 12),
              _buildLogoutButton(context),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildStatButton(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(
      color: const Color(0xFF363636),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontFamily: 'Lato',
      ),
      textAlign: TextAlign.center,
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
          const Icon(Icons.chevron_right, color: Colors.white, size: 34),
        ],
      ),
    ),
  );
}

Widget _buildLogoutButton(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Get.offAllNamed('/login');
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
