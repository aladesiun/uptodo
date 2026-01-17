import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uptodo/auth/widgets/primaryButton.dart';
import 'package:uptodo/home/core/task_controller.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> task;
  const TaskDetailsScreen({super.key, required this.task});
  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final TaskController _taskController = Get.find<TaskController>();

  @override
  void initState() {
    super.initState();
  }

  void _showDeleteTaskDialog() {
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
                    'Delete Task',
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
                const Text(
                  'Are You sure you want to delete this task?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Lato',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Task title : ${widget.task['title'] ?? ''}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Lato',
                  ),
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
                      child: Obx(() => PrimaryButton(
                        onPressed: () {
                          if (!_taskController.isLoading.value) {
                            _deleteTask(context);
                          }
                        },
                        title: _taskController.isLoading.value
                            ? 'Deleting...'
                            : 'Delete',
                        disabled: _taskController.isLoading.value,
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

  void _deleteTask(BuildContext dialogContext) async {
    final success = await _taskController.deleteTask(widget.task['id']);
    if (success) {
      Navigator.pop(dialogContext); // Close dialog
      Navigator.pop(context); // Navigate back to previous screen
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              color: Color(0XFF1D1D1D),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: 40,
              height: 55,
              decoration: BoxDecoration(
                color: Color(0XFF1D1D1D),
                borderRadius: BorderRadius.circular(7),
              ),
              alignment: Alignment.center,
              child: IconButton(
                icon: const Icon(Icons.repeat, size: 24, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 26),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _taskController.updateTaskStatus(
                                widget.task['id'],
                                true ? 'pending' : 'completed',
                              );
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: true
                                    ? const Color(0xFF8875FF)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: true
                                      ? const Color(0xFF8875FF)
                                      : Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: true
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.task['title'] ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Lato',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.task['description'] ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Lato',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      _buildInfoRow(
                        label: 'Task Time',
                        value: widget.task['time'] ?? '',
                        icon: Icons.timer_outlined,
                        valueColor: Colors.white,
                        valueIcon: Icons.arrow_forward_ios,
                        showValueIcon: true,
                      ),
                      const SizedBox(height: 40),
                      _buildInfoRow(
                        label: 'Task Category',
                        value: widget.task['category'] ?? 'Uncategorized',
                        icon: Icons.location_on_outlined,
                        valueColor: widget.task['categoryColor'],
                        valueIcon: widget.task['categoryIcon'],
                        showValueIcon: false,
                      ),

                      const SizedBox(height: 40),
                      _buildInfoRow(
                        label: 'Task Priority',
                        value: widget.task['priority'].toString(),
                        icon: Icons.flag_outlined,
                        valueColor: Colors.white,
                        valueIcon: Icons.arrow_forward_ios,
                        showValueIcon: true,
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: () => _showDeleteTaskDialog(),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Delete Task',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontFamily: 'Lato',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8875FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Edit Task',
                    style: TextStyle(fontSize: 16, fontFamily: 'Lato'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildInfoRow({
  required String label,
  required String value,
  required IconData icon,
  Color? valueColor,
  IconData? valueIcon,
  bool showValueIcon = false,
}) {
  return Row(
    children: [
      Icon(icon, color: Colors.white, size: 24),
      const SizedBox(width: 8),
      Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Lato'),
      ),
      const Spacer(),
      if (showValueIcon)
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Color(0xFF363636),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontSize: 16,
              fontFamily: 'Lato',
            ),
          ),
        )
      else if (valueColor != null && valueIcon != null)
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Color(0xFF363636),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                valueIcon ?? Icons.arrow_forward_ios,
                color: valueColor ?? Colors.white,
                size: 24,
              ),
              const SizedBox(width: 4),
              Text(
                value,
                style: TextStyle(
                  color: valueColor ?? Colors.white,
                  fontSize: 16,
                  fontFamily: 'Lato',
                ),
              ),
            ],
          ),
        )
      else
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Color(0xFF363636),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontSize: 16,
              fontFamily: 'Lato',
            ),
          ),
        ),
    ],
  );
}
