import 'package:flutter/material.dart';
import 'package:uptodo/home/widgets/time_picker_dialog.dart';

class CustomDatePickerDialog extends StatefulWidget {
  const CustomDatePickerDialog({super.key});

  @override
  State<CustomDatePickerDialog> createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  late DateTime _selectedDate;
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _displayedMonth = DateTime.now();
  }

  void _showTimePicker(BuildContext context, DateTime selectedDate) {
    showDialog(
      context: context,
      builder: (context) => CustomTimePickerDialog(selectedDate: selectedDate),
    );
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  List<DateTime> _getDaysInMonth() {
    final firstDay = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final lastDay = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      0,
    );
    final daysInMonth = lastDay.day;

    // Get the weekday of the first day (0 = Sunday, 6 = Saturday)
    final firstWeekday = firstDay.weekday % 7;

    List<DateTime> days = [];

    // Add days from previous month
    final prevMonthLastDay = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
      0,
    );
    for (int i = firstWeekday - 1; i >= 0; i--) {
      days.add(
        DateTime(
          _displayedMonth.year,
          _displayedMonth.month - 1,
          prevMonthLastDay.day - i,
        ),
      );
    }

    // Add days from current month
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(DateTime(_displayedMonth.year, _displayedMonth.month, i));
    }

    // Add days from next month to fill the grid
    final remainingDays = 42 - days.length; // 6 rows * 7 days
    for (int i = 1; i <= remainingDays; i++) {
      days.add(DateTime(_displayedMonth.year, _displayedMonth.month + 1, i));
    }

    return days;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isCurrentMonth(DateTime date) {
    return date.month == _displayedMonth.month &&
        date.year == _displayedMonth.year;
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDaysInMonth();
    final monthNames = [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER',
    ];

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
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _previousMonth,
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                Column(
                  children: [
                    Text(
                      monthNames[_displayedMonth.month - 1],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Lato',
                      ),
                    ),
                    Text(
                      '${_displayedMonth.year}',
                      style: const TextStyle(
                        color: Color(0xFF979797),
                        fontSize: 14,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _nextMonth,
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(color: Color(0xFF979797), thickness: 1),
            const SizedBox(height: 16),
            // Days of week
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT']
                  .map(
                    (day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                            color: (day == 'SUN' || day == 'SAT')
                                ? const Color(0xFFFF6B6B)
                                : Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Lato',
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            // Calendar grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: 42,
              itemBuilder: (context, index) {
                final date = days[index];
                final isCurrentMonth = _isCurrentMonth(date);
                final isSelected = _isSameDay(date, _selectedDate);

                return GestureDetector(
                  onTap: () => _selectDate(date),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF8875FF)
                          : (isCurrentMonth
                                ? const Color(0xFF272727)
                                : Colors.transparent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (isCurrentMonth
                                    ? Colors.white
                                    : const Color(0xFF979797)),
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          fontFamily: 'Lato',
                        ),
                      ),
                    ),
                  ),
                );
              },
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
                    Navigator.of(context).pop();
                    _showTimePicker(context, _selectedDate);
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
                    'Choose Time',
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
}
