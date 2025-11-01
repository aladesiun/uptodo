import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:uptodo/details.dart';
import 'package:uptodo/home.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context)=> const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/details': (context) => DetailsScreen(),
      },

    );
  }
}
