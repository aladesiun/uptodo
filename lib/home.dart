import 'package:flutter/material.dart';
import 'package:uptodo/details.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home Screenr"),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: (){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailsScreen()),
              );
            },
          child: Text("Click to go to Detailscreen")),
        ),
      ),
    );
  }
}