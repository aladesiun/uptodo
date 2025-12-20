import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uptodo/auth/core/auth_controller.dart';
import 'package:uptodo/auth/widgets/customTextField.dart';
import 'package:uptodo/auth/widgets/primaryButton.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController =
      TextEditingController(text: 'aladesiuntope@gmail.com');
  final _fullNameController = TextEditingController(text: 'Aladesiun tope');
  final _passwordController = TextEditingController(text: '654321');
  final _confirmPasswordController = TextEditingController(text: '654321');
  final AuthController _authController = Get.find();

  bool _obsurePasword = true;
  void _handleRegister() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    _authController.registerUser(
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        fullName: _fullNameController.text);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 50),
                BuildTextField(
                  labelText: "Email Address",
                  hintText: "Email Address",
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email Address is required";
                    }
                  },
                ),
                const SizedBox(height: 30),
                BuildTextField(
                  labelText: "Full Name",
                  hintText: "Full Name",
                  controller: _fullNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Full Name is required";
                    }
                  },
                ),
                const SizedBox(height: 34),
                BuildTextField(
                  labelText: "Password",
                  hintText: "Password",
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                  },
                  isObscureText: _obsurePasword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obsurePasword ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xFF535353),
                    ),
                    onPressed: () {
                      setState(() {
                        _obsurePasword = !_obsurePasword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 34),
                BuildTextField(
                  labelText: "Confirm Password",
                  hintText: "Confirm Password",
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirm Password is required";
                    }
                  },
                  isObscureText: _obsurePasword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obsurePasword ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xFF535353),
                    ),
                    onPressed: () {
                      setState(() {
                        _obsurePasword = !_obsurePasword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 70),
                Obx(
                  () => PrimaryButton(
                      onPressed: _handleRegister,
                      title: _authController.isLoading.value
                          ? "please wait..."
                          : "Register"),
                ),
                const SizedBox(height: 34),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Color(0xFF979797)),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
