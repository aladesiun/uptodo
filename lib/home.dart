import 'package:flutter/material.dart';
import 'package:uptodo/details.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            child: Text(
              "Click to go to Profile screen",
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
        ),
      ),
    );
  }
}
