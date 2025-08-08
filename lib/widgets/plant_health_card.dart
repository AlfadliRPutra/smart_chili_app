import 'package:flutter/material.dart';

class PlantHealthCard extends StatelessWidget {
  const PlantHealthCard({super.key});

  Widget buildIndicator(int activeDots) {
    return Row(
      children: List.generate(5, (index) {
        final isActive = index < activeDots;
        return Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.green : Colors.grey[300],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.eco, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    "Chili Plant Health",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Healthy",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Indicators
          const Text("Leaf condition"),
          const SizedBox(height: 4),
          buildIndicator(4),

          const SizedBox(height: 8),
          const Text("Growth rate"),
          const SizedBox(height: 4),
          buildIndicator(3),

          const SizedBox(height: 8),
          const Text("Disease resistance"),
          const SizedBox(height: 4),
          buildIndicator(5),

          const SizedBox(height: 16),

          // Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[100],
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              // TODO: action here
            },
            child: const Text("Analyze Leaf Health"),
          ),
        ],
      ),
    );
  }
}
