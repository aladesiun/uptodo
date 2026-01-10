import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uptodo/home/core/category_controller.dart';
import 'package:uptodo/home/core/task_controller.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool _todayExpanded = true;
  bool _completedExpanded = true;
  Map<String, dynamic> _userProfile = {};
  late final TaskController _taskController;
  late final CategoryController _categoryController;

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
  void _fetchTasks() async {
    await _categoryController.fetchCategories();
    await _taskController.fetchTasks();
  }
  @override
  void initState() {
    super.initState();
    _getUserProfile();

    _categoryController = Get.put(CategoryController());
    _taskController = Get.put(TaskController());

    _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 24),
                    onPressed: () {
                      // TODO: Open drawer or menu
                    },
                  ),
                  const Text(
                    "Index",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Lato',
                    ),
                  ),
                  // CircleAvatar(
                  //   radius: 20,
                  //   backgroundImage: NetworkImage(_userProfile['avatarUrl'] ?? ""),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Task List or Empty State
            Expanded(
              child: Obx((){
                if(_taskController.isLoading.value){
                  return const Center(child: CircularProgressIndicator());
                }
                final pendingTasks = _taskController.pendingTasks;
                final completedTasks = _taskController.completedTasks;

                if(pendingTasks.isEmpty && completedTasks.isEmpty){
                  return _buildEmptyState();
                }
                return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        // Today Section
                        _buildSectionHeader('Pending', _todayExpanded, () {
                          setState(() {
                            _todayExpanded = !_todayExpanded;
                          });
                        }),
                        if (_todayExpanded) ...[
                          const SizedBox(height: 12),
                          ...pendingTasks.map((task) => _buildTaskCard(task)),
                        ],
                        const SizedBox(height: 24),
                        // Completed Section
                        _buildSectionHeader(
                          'Completed',
                          _completedExpanded,
                          () {
                            setState(() {
                              _completedExpanded = !_completedExpanded;
                            });
                          },
                        ),
                        if (_completedExpanded) ...[
                          const SizedBox(height: 12),
                          ...completedTasks.map(
                            (task) => _buildTaskCard(task),
                          ),
                        ],
                      ],
                    );
              })
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/empty-checklist.png", height: 200),
        const SizedBox(height: 24),
        const Text(
          "What do you want to do today?",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Lato',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          "Tap + to add your tasks",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'Lato',
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    String title,
    bool isExpanded,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Lato',
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
            color: Colors.white,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    final bool isCompleted = task['status'] == 'completed';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF272727),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: (){
              _taskController.updateTaskStatus(task['id'], isCompleted ? 'pending' : 'completed');
            },
            child:  Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? const Color(0xFF8875FF) : Colors.transparent,
              border: Border.all(color: isCompleted ? const Color(0xFF8875FF) : Colors.white, width: 2),
            ),
            child: isCompleted ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
          ),
          ),
         
          const SizedBox(width: 12),
          // Task details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Lato',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Today At ${task['time']}',
                  style: const TextStyle(
                    color: Color(0xFF979797),
                    fontSize: 14,
                    fontFamily: 'Lato',
                  ),
                ),
              ],
            ),
          ),
          // Category tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: task['categoryColor'],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(task['categoryIcon'], color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  task['category'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Lato',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Priority flag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF8875FF), width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.flag_outlined,
                  color: Color(0xFF8875FF),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${task['priority']}',
                  style: const TextStyle(
                    color: Color(0xFF8875FF),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Lato',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
