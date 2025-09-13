// lib/screens/camera_screen.dart
import 'package:flutter/material.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Camera Detection")),
      body: const Center(
        child: Text(
          "Camera preview & YOLO detection akan tampil di sini",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
