import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text("Details Screen"),
        // ),
       body: Center(
          child: ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
            },
          child: Text("Click to go back")),
        ),
      ),
    );
  }
}