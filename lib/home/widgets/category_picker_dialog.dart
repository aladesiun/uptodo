import 'package:flutter/material.dart';
import 'package:uptodo/home/create_category_page.dart';

class CategoryPickerDialog extends StatefulWidget {
  const CategoryPickerDialog({super.key});

  @override
  State<CategoryPickerDialog> createState() => _CategoryPickerDialogState();
}

class _CategoryPickerDialogState extends State<CategoryPickerDialog> {
  // Sample categories
  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Grocery',
      'color': const Color(0xFF90EE90),
      'icon': Icons.shopping_bag,
    },
    {'name': 'Work', 'color': const Color(0xFFFF7F50), 'icon': Icons.business},
    {
      'name': 'Sport',
      'color': const Color(0xFF40E0D0),
      'icon': Icons.fitness_center,
    },
    {'name': 'Design', 'color': const Color(0xFF40E0D0), 'icon': Icons.palette},
    {
      'name': 'University',
      'color': const Color(0xFF9370DB),
      'icon': Icons.school,
    },
    {
      'name': 'Social',
      'color': const Color(0xFFFF69B4),
      'icon': Icons.campaign,
    },
    {
      'name': 'Music',
      'color': const Color(0xFF9370DB),
      'icon': Icons.music_note,
    },
    {
      'name': 'Health',
      'color': const Color(0xFF90EE90),
      'icon': Icons.favorite,
    },
    {'name': 'Movie', 'color': const Color(0xFF87CEEB), 'icon': Icons.movie},
    {'name': 'Home', 'color': const Color(0xFFDEB887), 'icon': Icons.home},
  ];

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
              'Choose Category',
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
            // Category grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemCount: _categories.length + 1, // +1 for "Create New"
              itemBuilder: (context, index) {
                if (index == _categories.length) {
                  // Create New button
                  return _buildCreateNewButton(context);
                }
                return _buildCategoryButton(_categories[index]);
              },
            ),
            const SizedBox(height: 24),
            // Add Category button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showCreateCategoryDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8875FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Add Category',
                  style: TextStyle(fontSize: 16, fontFamily: 'Lato'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(category);
      },
      child: Container(
        decoration: BoxDecoration(
          color: category['color'],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category['icon'], color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              category['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Lato',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateNewButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        _showCreateCategoryDialog(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF90EE90),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            const Text(
              'Create New',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Lato',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateCategoryDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateCategoryPage()),
    );
  }
}
