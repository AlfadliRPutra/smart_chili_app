import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chili_app/controllers/nav_controller.dart';
import 'package:smart_chili_app/screens/detection_screen.dart';
import 'package:smart_chili_app/screens/monitoring_screen.dart';
import 'package:smart_chili_app/widgets/bottom_navbar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final NavController navController = Get.put(NavController());

  final List<Widget> pages = const [
    Center(child: Text("🏠 Home Page")),
    DetectionScreen(),
    MonitoringScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Chili App")),
      body: Obx(() => pages[navController.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavBar(
          currentIndex: navController.currentIndex.value,
          onTap: navController.changeTab,
        ),
      ),
    );
  }
}
