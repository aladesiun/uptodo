import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.sort, color: Colors.white, size: 28),
                const Text(
                  'Index',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Lato',
                  ),
                ),
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1D1D1D),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF535353),
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Empty state or tasks list
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.checklist_rounded,
                      size: 120,
                      color: const Color(0xFF363636),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'What do you want to do today?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Lato',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Tap + to add your tasks',
                      style: TextStyle(
                        color: Color(0xFF979797),
                        fontSize: 16,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
