import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chili_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart Chili App',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 95, 2, 255),
        ),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
