import 'package:flutter/material.dart';

class SensorTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final String description;

  const SensorTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Icon(icon, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "$value $unit",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(description, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}
