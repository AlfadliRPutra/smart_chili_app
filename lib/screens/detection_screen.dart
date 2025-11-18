import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'camera_screen.dart';
import 'result_screen.dart'; // ✅ layar baru untuk hasil
import '../controllers/yolo_controller.dart';

class DetectionScreen extends StatelessWidget {
  const DetectionScreen({super.key});

  Future<void> _pickImage(YoloController controller) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      await controller.predict(bytes); // jalankan YOLO

      // ✅ pindah ke ResultScreen
      Get.to(() => ResultScreen(imageBytes: bytes));
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(YoloController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Detection'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        toolbarHeight: 40,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// === Detection Card ===
            _buildDetectionCard(controller),

            const SizedBox(height: 24),

            /// === Common Diseases Section ===
            const Text(
              'Common Chili Diseases',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildDiseaseCard(
              name: 'Bercak',
              desc:
                  'Muncul bercak cokelat atau hitam pada daun yang bisa menyatu.',
              severity: 'Medium',
              severityColor: Colors.amber,
            ),
            _buildDiseaseCard(
              name: 'Keriting',
              desc: 'Daun melengkung/keriting, biasanya akibat serangan virus.',
              severity: 'High',
              severityColor: Colors.red,
            ),
            _buildDiseaseCard(
              name: 'Kuning',
              desc:
                  'Daun menguning, bisa disebabkan jamur, bakteri, atau kekurangan nutrisi.',
              severity: 'Medium',
              severityColor: Colors.amber,
            ),
            _buildDiseaseCard(
              name: 'Whitefly',
              desc:
                  'Daun ditutupi serangga putih kecil (kutu kebul) yang menghisap cairan daun.',
              severity: 'High',
              severityColor: Colors.red,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),

      /// === Bottom Camera Button ===
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5B7743),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: const Icon(Icons.camera_alt),
          label: const Text("Open Camera for Quick Scan"),
          onPressed: () {
            Get.to(() => const CameraScreen());
          },
        ),
      ),
    );
  }

  /// === Detection Card ===
  Widget _buildDetectionCard(YoloController controller) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: const [
                Icon(Icons.eco_outlined, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Chili Leaf Disease Detection',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Take a photo or upload an image of chili leaves for disease detection',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => const CameraScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                    ),
                    child: const Text('Take Photo'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pickImage(controller),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[200],
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Upload Image'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// === Disease Card ===
  Widget _buildDiseaseCard({
    required String name,
    required String desc,
    required String severity,
    required Color severityColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(FontAwesomeIcons.leaf, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(desc, style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Text("Severity: ", style: TextStyle(fontSize: 13)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: severityColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          severity,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: severityColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
