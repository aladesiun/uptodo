import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uptodo/auth/core/auth_controller.dart';
import 'package:uptodo/auth/widgets/customTextField.dart';
import 'package:uptodo/auth/widgets/primaryButton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController =
      TextEditingController(text: 'aladesiuntope@gmail.com');
  final _passwordController = TextEditingController(text: '654321');
  final AuthController _authController = Get.find();
  bool _obsurePasword = true;

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      _authController.loginUser(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                Text(
                  "Login",
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
                const SizedBox(height: 70),
                Obx(() => PrimaryButton(
                    onPressed: _handleLogin,
                    disabled: _authController.isLoading.value,
                    title: _authController.isLoading.value
                        ? "please wait..."
                        : "Login")),
                const SizedBox(height: 34),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(color: Color(0xFF979797)),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        'Register',
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
