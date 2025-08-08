import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetectionScreen extends StatelessWidget {
  const DetectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Leaf Disease Detection'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// === Detection Card ===
            _buildDetectionCard(),

            const SizedBox(height: 24),

            /// === Common Diseases Section ===
            const Text(
              'Common Chili Diseases',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildDiseaseCard(
              name: 'Leaf Spot',
              desc:
                  'Small brown or black spots on leaves that may grow and merge.',
              severity: 'Medium',
              severityColor: Colors.amber,
            ),
            _buildDiseaseCard(
              name: 'Powdery Mildew',
              desc: 'White powdery spots on upper leaf surfaces.',
              severity: 'Medium',
              severityColor: Colors.amber,
            ),
            _buildDiseaseCard(
              name: 'Leaf Curl',
              desc: 'Curled, distorted leaves often caused by viruses.',
              severity: 'High',
              severityColor: Colors.red,
            ),
            _buildDiseaseCard(
              name: 'Root Rot',
              desc:
                  'Causes wilting and yellowing despite adequate soil moisture.',
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
            // TODO: Aksi buka kamera
          },
        ),
      ),
    );
  }

  Widget _buildDetectionCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Header
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

            /// Toggle Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Take Photo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Upload Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[200],
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Photo Placeholder
            GestureDetector(
              onTap: () {
                // TODO: Handle image upload or camera open
              },
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.photo_camera_outlined,
                      size: 36,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    Text("Tap to take a photo of chili leaves"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// Open Camera Button
            ElevatedButton(
              onPressed: () {
                // TODO: Open camera logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Open Camera"),
            ),

            const SizedBox(height: 8),
            const Text(
              'Our AI can detect common chili plant diseases with 95% accuracy',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

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
