import 'package:flutter/material.dart';

class PriorityPickerDialog extends StatefulWidget {
  const PriorityPickerDialog({super.key});

  @override
  State<PriorityPickerDialog> createState() => _PriorityPickerDialogState();
}

class _PriorityPickerDialogState extends State<PriorityPickerDialog> {
  int _selectedPriority = 1;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF363636),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            const Text(
              'Task Priority',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Lato',
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: Color(0xFF979797), thickness: 1),
            const SizedBox(height: 24),
            // Priority grid
            Column(
              children: [
                // Row 1: Priorities 1-4
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [1, 2, 3, 4].map((priority) {
                    return _buildPriorityButton(priority);
                  }).toList(),
                ),
                const SizedBox(height: 12),
                // Row 2: Priorities 5-8
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [5, 6, 7, 8].map((priority) {
                    return _buildPriorityButton(priority);
                  }).toList(),
                ),
                const SizedBox(height: 12),
                // Row 3: Priorities 9-10
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [9, 10].map((priority) {
                    return _buildPriorityButton(priority);
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Lato',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(_selectedPriority);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8875FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 16, fontFamily: 'Lato'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityButton(int priority) {
    final isSelected = priority == _selectedPriority;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPriority = priority;
        });
      },
      child: Container(
        width: 60,
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8875FF) : const Color(0xFF272727),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.flag_outlined, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(
              '$priority',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Lato',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
