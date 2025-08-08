import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chili_app/controllers/nav_controller.dart';
import 'package:smart_chili_app/screens/detection_screen.dart';
import 'package:smart_chili_app/screens/monitoring_screen.dart';
import 'package:smart_chili_app/widgets/bottom_navbar.dart';
import 'package:smart_chili_app/widgets/farm_status_card.dart';
import 'package:smart_chili_app/widgets/sensor_tile.dart';
import 'package:smart_chili_app/widgets/plant_health_card.dart';
import 'package:smart_chili_app/widgets/quick_action_button.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final NavController navController = Get.put(NavController());

  final List<Widget> pages = [
    const _DashboardView(), // Ganti halaman pertama dengan custom dashboard view
    const DetectionScreen(),
    const MonitoringScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        body: pages[navController.currentIndex.value],
        bottomNavigationBar: BottomNavBar(
          currentIndex: navController.currentIndex.value,
          onTap: navController.changeTab,
        ),
      );
    });
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Welcome back!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Track your chili plants and monitor conditions",
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),

          const FarmStatusCard(),
          const SizedBox(height: 24),

          const Text(
            "Sensor Readings",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              SensorTile(
                icon: Icons.thermostat,
                label: "Temperature",
                value: "28.3",
                unit: "°C",
                description: "Air temperature",
              ),
              SensorTile(
                icon: Icons.water_drop,
                label: "Humidity",
                value: "64",
                unit: "%",
                description: "Air humidity",
              ),
              SensorTile(
                icon: Icons.light_mode,
                label: "Light Intensity",
                value: "851",
                unit: "lux",
                description: "Light exposure",
              ),
              SensorTile(
                icon: Icons.device_thermostat,
                label: "Soil Moisture",
                value: "41",
                unit: "%",
                description: "Soil humidity",
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Text(
            "Plant Health",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const PlantHealthCard(),

          const SizedBox(height: 24),
          const Text(
            "Quick Actions",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: QuickActionButton(
                  icon: Icons.camera_alt,
                  title: "Scan Leaf",
                  subtitle: "Detect diseases",
                  onTap: () {
                    // Aksi ketika Scan Leaf ditekan
                  },
                ),
              ),
              const SizedBox(width: 12), // jarak antar tombol
              Expanded(
                child: QuickActionButton(
                  icon: Icons.insert_chart,
                  title: "Farm Report",
                  subtitle: "View analysis",
                  onTap: () {
                    // Aksi ketika Farm Report ditekan
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
