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
    var body = {'email': email, 'password': password, 'fullname': fullName};
    final url = Uri.parse(
      'https://codeafrica-uptodo-backend.onrender.com/users/register',
    );
    try {
      final response = await http.post(
        url,
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
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
    var body = {'email': email, 'password': password};
    final url = Uri.parse(
      'https://codeafrica-uptodo-backend.onrender.com/users/login',
    );
    try {
      final response = await http.post(
        url,
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
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

  Future<bool> updateProfile({required String fullName}) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final String? tokenString = _prefs.getString("auth_token");

    if (tokenString == null) {
      Get.snackbar(
        'Error',
        'Authentication token not found',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    isLoading.value = true;
    var body = {'fullname': fullName};
    final url = Uri.parse(
      "https://codeafrica-uptodo-backend.onrender.com/users/updateProfile",
    );

    try {
      final token = jsonDecode(tokenString);
      final response = await http.put(
        url,
        body: json.encode(body),
        headers: {
          'Authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
      );
      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _prefs.setString('user_profile', jsonEncode(responseBody['data']));
        isLoading.value = false;
        return true;
      } else {
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final String? tokenString = _prefs.getString('auth_token');

    if (tokenString == null) {
      Get.snackbar(
        'Error',
        'Authentication token not found',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    isLoading.value = true;
    var body = {'oldPassword': oldPassword, 'newPassword': newPassword};
    final url = Uri.parse(
      'https://codeafrica-uptodo-backend.onrender.com/users/changePassword',
    );
    try {
      final token = jsonDecode(tokenString);
      final response = await http.put(
        url,
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
         Get.snackbar(
          'Success',
          responseBody['message'] ?? 'Password changed successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return true;
      }else {
        Get.snackbar(
          'Error',
          responseBody['message'] ?? 'Failed to change password',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }
}
