import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  // Obtain shared preferences.

  Future<void> registerUser({
    required String email,
    required String password,
    required String confirmPassword,
    required String fullName,
  }) async {
    isLoading.value = true;
    if (password != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match');
      isLoading.value = false;
      return;
    }
    var body = {
      'email': email,
      'password': password,
      'fullname': fullName,
    };
    final url = Uri.parse(
        'https://codeafrica-uptodo-backend.onrender.com/users/register');
    try {
      final response = await http.post(
        url,
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'User registered successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed('/login');
      } else {
        Get.snackbar(
          'Error',
          responseBody['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Something went wrong');
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    isLoading.value = true;
    var body = {
      'email': email,
      'password': password,
    };
    final url =
        Uri.parse('https://codeafrica-uptodo-backend.onrender.com/users/login');
    try {
      final response = await http.post(
        url,
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      var responseBody = jsonDecode(response.body);
      print(responseBody);
      if (response.statusCode == 200 || response.statusCode == 201) {
        _prefs.setString('auth_token', jsonEncode(responseBody['token']));
        _prefs.setString('user_profile', jsonEncode(responseBody['data']));
        Get.offAllNamed('/');
      } else {
        Get.snackbar(
          'Error',
          responseBody['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Something went wrong');

      print(e);
    }
  }
}
