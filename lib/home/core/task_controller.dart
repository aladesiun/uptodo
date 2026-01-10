import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uptodo/home/core/category_controller.dart';

class TaskController extends GetxController {
  var isLoading = false.obs;
  var tasks = <Map<String, dynamic>>[].obs;

  Future<List<Map<String, dynamic>>> fetchTasks({bool? showLoader = true}) async {
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
    if (showLoader == true) {
      isLoading.value = true;
    }
    final url = Uri.parse(
      'https://codeafrica-uptodo-backend.onrender.com/tasks',
    );

    try {
      final token = jsonDecode(tokenString);
      final response = await http.get(
        url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> tasksData = responseBody['data'] ?? [];
        CategoryController? categoryController;
        try {
          categoryController = Get.find<CategoryController>();
        } catch (e) {
          categoryController = Get.put(CategoryController());
        }

        var mappedTasks = tasksData.map((task) {
          String timeString = '';
          try {
            if (task['dueDate'] != null) {
              DateTime dueDate = DateTime.parse(task['dueDate']);
              // format as hh:mm
              String hour = dueDate.hour.toString().padLeft(2, '0');
              String minute = dueDate.minute.toString().padLeft(2, '0');
              timeString = '$hour:$minute';
            }
          } catch (e) {
            timeString = 'N/A';
          }

          String categoryName = 'N/A';
          Color categoryColor = Colors.grey;
          IconData categoryIcon = Icons.folder_outlined;

          if (categoryController != null && task['categoryId'] != null) {
            try {
              var category = categoryController.categories.firstWhere(
                (cat) => cat['id'] == task['categoryId'],
                orElse: () => {},
              );

              if (category.isNotEmpty) {
                categoryName = category['name'] ?? 'N/A';
                categoryColor = category['color'] ?? Colors.grey;
                categoryIcon = category['icon'] ?? Icons.folder_outlined;
              }
            } catch (e) {}
          }

          return {
            'id': task['_id'],
            'title': task['title'],
            'time': timeString,
            'category': categoryName,
            'categoryColor': categoryColor,
            'categoryIcon': categoryIcon,
            'priority': task['priority'] ?? 1,
            'status': task['status'] ?? 'pending',
            'description': task['description'] ?? '',
            'dueDate': task['dueDate'],
          };
        }).toList();

        tasks.value = mappedTasks;
        isLoading.value = false;
        return mappedTasks;
      } else {
        Get.snackbar(
          'Error',
          responseBody['message'] ?? 'Failed to fetch tasks',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return [];
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Something went wrong while fetching tasks');
      print(e);
      return [];
    }
  }

  List<Map<String, dynamic>> get pendingTasks {
    return tasks.where((task) => task['status'] == 'pending').toList();
  }

  List<Map<String, dynamic>> get completedTasks {
    return tasks.where((task) => task['status'] == 'completed').toList();
  }

  Future<bool> updateTaskStatus(String taskId, String status) async {
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

    final url = Uri.parse(
      'https://codeafrica-uptodo-backend.onrender.com/tasks/$taskId',
    );
    try {
      tasks.value = tasks.map((task) => task['id'] == taskId ? {...task, 'status': status} : task).toList();
      final token = jsonDecode(tokenString);
      final response = await http.put(
        url,
        body: jsonEncode({'status': status}),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchTasks(showLoader: false);
        return true;
      } else {
        Get.snackbar(
          'Error',
          responseBody['message'] ?? 'Failed to update task status',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong while updating task status');
      print(e);
      return false;
    }
  }
}
