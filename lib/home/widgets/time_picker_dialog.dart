import 'package:flutter/material.dart';

class CustomTimePickerDialog extends StatefulWidget {
  final DateTime selectedDate;

  const CustomTimePickerDialog({super.key, required this.selectedDate});

  @override
  State<CustomTimePickerDialog> createState() => _CustomTimePickerDialogState();
}

class _CustomTimePickerDialogState extends State<CustomTimePickerDialog> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _ampmController;
  late int _selectedHour;
  late int _selectedMinute;
  late bool _isPM;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedHour = now.hour > 12
        ? now.hour - 12
        : (now.hour == 0 ? 12 : now.hour);
    _selectedMinute = now.minute;
    _isPM = now.hour >= 12;

    _hourController = FixedExtentScrollController(
      initialItem: _selectedHour - 1,
    );
    _minuteController = FixedExtentScrollController(
      initialItem: _selectedMinute,
    );
    _ampmController = FixedExtentScrollController(initialItem: _isPM ? 1 : 0);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _ampmController.dispose();
    super.dispose();
  }

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
              'Choose Time',
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
            // Time selection wheels
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hour selector
                _buildWheel(
                  controller: _hourController,
                  itemCount: 12,
                  selectedIndex: _selectedHour - 1,
                  builder: (context, index) {
                    final hour = index + 1;
                    final isSelected = index == _selectedHour - 1;
                    return _buildWheelItem(
                      '${hour.toString().padLeft(2, '0')}',
                      isSelected: isSelected,
                    );
                  },
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedHour = index + 1;
                    });
                  },
                ),
                const SizedBox(width: 8),
                // Colon separator
                const Text(
                  ':',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Lato',
                  ),
                ),
                const SizedBox(width: 8),
                // Minute selector
                _buildWheel(
                  controller: _minuteController,
                  itemCount: 60,
                  selectedIndex: _selectedMinute,
                  builder: (context, index) {
                    final isSelected = index == _selectedMinute;
                    return _buildWheelItem(
                      '${index.toString().padLeft(2, '0')}',
                      isSelected: isSelected,
                    );
                  },
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedMinute = index;
                    });
                  },
                ),
                const SizedBox(width: 8),
                // AM/PM selector
                _buildWheel(
                  controller: _ampmController,
                  itemCount: 2,
                  selectedIndex: _isPM ? 1 : 0,
                  builder: (context, index) {
                    final isSelected =
                        (_isPM && index == 1) || (!_isPM && index == 0);
                    return _buildWheelItem(
                      index == 0 ? 'AM' : 'PM',
                      isSelected: isSelected,
                    );
                  },
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _isPM = index == 1;
                    });
                  },
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
                      color: Color(0xFF8875FF),
                      fontSize: 16,
                      fontFamily: 'Lato',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final hour24 = _isPM
                        ? (_selectedHour == 12 ? 12 : _selectedHour + 12)
                        : (_selectedHour == 12 ? 0 : _selectedHour);
                    final selectedDateTime = DateTime(
                      widget.selectedDate.year,
                      widget.selectedDate.month,
                      widget.selectedDate.day,
                      hour24,
                      _selectedMinute,
                    );
                    Navigator.of(context).pop(selectedDateTime);
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

  Widget _buildWheel({
    required FixedExtentScrollController controller,
    required int itemCount,
    required int selectedIndex,
    required Widget Function(BuildContext, int) builder,
    required ValueChanged<int> onSelectedItemChanged,
  }) {
    return Container(
      width: 70,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF272727),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 35,
        physics: const FixedExtentScrollPhysics(),
        diameterRatio: 1.2,
        perspective: 0.003,
        onSelectedItemChanged: onSelectedItemChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: builder,
          childCount: itemCount,
        ),
      ),
    );
  }

  Widget _buildWheelItem(String text, {bool isSelected = false}) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF979797),
          fontSize: isSelected ? 24 : 18,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
          fontFamily: 'Lato',
        ),
      ),
    );
  }
}
