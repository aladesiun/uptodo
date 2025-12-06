import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:uptodo/auth/login.dart';
import 'package:uptodo/auth/register.dart';
import 'package:uptodo/details.dart';
import 'package:uptodo/home.dart';
import 'package:uptodo/main_layout.dart';
import 'package:uptodo/onboarding.dart';
import 'package:uptodo/profile.dart';

void main() {
  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Lato',
        textTheme: TextTheme(
          displayLarge: TextStyle(fontFamily: 'Lato', fontSize: 15),
          titleLarge: TextStyle(fontFamily: 'Lato'),
        ),
      ),

      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      initialRoute: '/onboarding',
      routes: {
        '/': (context) => MainLayout(initialIndex: 0),
        '/details': (context) => DetailsScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/profile': (context) => MainLayout(initialIndex: 1),
      },
    );
  }
}
