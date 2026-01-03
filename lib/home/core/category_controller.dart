import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CategoryController extends GetxController {
  var isLoading = false.obs;
  var categories = <Map<String, dynamic>>[].obs;

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final String? tokenString = _prefs.getString('auth_token');

    if (tokenString == null) {
      Get.snackbar(
        'Error',
        'Authentication token not found',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return [];
    }
    isLoading.value = true;
    final url = Uri.parse(
      'https://codeafrica-uptodo-backend.onrender.com/categories',
    );

    try {
      final token = jsonDecode(tokenString);
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });
      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {

        List<dynamic> categoriesData = responseBody['data'] ?? [];

        List<Map<String, dynamic>> mappedCategories = categoriesData.map((category){

          String hexCode = category['colorHexCode'];
          Color categoryColor;

          try {
            String colorString = hexCode.replaceFirst('#', '0xFF');
            categoryColor = Color(int.tryParse(colorString) ?? 0xFF000000);
          } catch (e) {
             categoryColor = Colors.white;
          }

          // Color(0xffFFFFFF) -> #FFFFFF
          return {
            'id': category['_id'],
            'name': category['name'],
            'color': categoryColor,
            'icon': Icons.folder_outlined,
          };
        }).toList(); 

        categories.value = mappedCategories;
        isLoading.value = false;
        return mappedCategories;
      }else {
        isLoading.value = false;
        Get.snackbar('Error', responseBody['message'] ?? 'Failed to fetch categories');
        return [];
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Something went wrong');
      return [];
    }
  }
}
