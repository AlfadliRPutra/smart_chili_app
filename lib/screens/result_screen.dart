import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import '../controllers/yolo_controller.dart';

class ResultScreen extends StatelessWidget {
  final Uint8List imageBytes;

  const ResultScreen({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<YoloController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detection Result"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        toolbarHeight: 40,
      ),
      body: Obx(() {
        Uint8List renderedImage = _drawDetections(
          imageBytes,
          controller.detections,
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  renderedImage,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Detection Results",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (controller.detections.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text("❌ No disease detected"),
                )
              else
                Column(
                  children: controller.detections.map((det) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 1,
                      child: ListTile(
                        leading: const Icon(Icons.eco, color: Colors.green),
                        title: Text(
                          det.label,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Confidence: ${(det.confidence * 100).toStringAsFixed(1)}%",
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        );
      }),
    );
  }

  Uint8List _drawDetections(Uint8List imageBytes, List<Detection> detections) {
    final decoded = img.decodeImage(imageBytes);
    if (decoded == null) return imageBytes;

    // Warna merah sekarang menggunakan ColorRgb8
    final drawColor = img.ColorRgb8(255, 0, 0);

    for (var det in detections) {
      // Kotak
      img.drawRect(
        decoded,
        x1: det.x1.toInt(),
        y1: det.y1.toInt(),
        x2: det.x2.toInt(),
        y2: det.y2.toInt(),
        color: drawColor,
        thickness: 4,
      );

      // Label
      img.drawString(
        decoded,
        "${det.label} ${(det.confidence * 100).toStringAsFixed(1)}%",
        font: img.arial14,
        x: det.x1.toInt(),
        y: (det.y1 - 16).toInt(),
        color: drawColor,
      );
    }

    return Uint8List.fromList(img.encodeJpg(decoded));
  }
}
