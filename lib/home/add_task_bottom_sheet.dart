import 'package:flutter/material.dart';
import 'package:uptodo/home/widgets/date_picker_dialog.dart';
import 'package:uptodo/home/widgets/priority_picker_dialog.dart';
import 'package:uptodo/home/widgets/category_picker_dialog.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _taskTitleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showDatePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CustomDatePickerDialog(),
    );
  }

  void _showPriorityPicker(BuildContext context) {
    showDialog(
      context: context,
      fullscreenDialog: true,
      builder: (context) => const PriorityPickerDialog(),
    );
  }

  void _showCategoryPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CategoryPickerDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Color(0xFF272727),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Add Task',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w700,
                fontFamily: 'Lato',
              ),
            ),
            const SizedBox(height: 24),
            // Task Title Input
            TextField(
              controller: _taskTitleController,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Lato',
              ),
              decoration: InputDecoration(
                hintText: 'Do math homework',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 16,
                  fontFamily: 'Lato',
                ),
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(
                    color: Color(0xFF979797),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(
                    color: Color(0xFF979797),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(
                    color: Color(0xFF979797),
                    width: 1,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Description Input
            TextField(
              controller: _descriptionController,
              minLines: 1,
              maxLines: null,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Lato',
              ),
              decoration: InputDecoration(
                hintText: 'Description',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 14,
                  fontFamily: 'Lato',
                ),
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 8,
                ),
              ),
            ),
            // Action Icons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Clock Icon
                    IconButton(
                      onPressed: () {
                        _showDatePicker(context);
                      },
                      icon: const Icon(
                        Icons.access_time_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    // Location Icon
                    IconButton(
                      onPressed: () {
                        _showCategoryPicker(context);
                      },
                      icon: const Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    // Flag Icon
                    IconButton(
                      onPressed: () {
                        _showPriorityPicker(context);
                      },
                      icon: const Icon(
                        Icons.flag_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                // Send Icon
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Color(0xFF8875FF),
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
