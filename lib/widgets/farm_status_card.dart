import 'package:flutter/material.dart';

class FarmStatusCard extends StatelessWidget {
  const FarmStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Farm Status",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "All systems normal",
                  style: TextStyle(color: Colors.green),
                ),
                Text(
                  "Last updated less than a minute ago",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
        ],
      ),
    );
  }
}
