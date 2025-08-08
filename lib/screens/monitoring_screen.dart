import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MonitoringScreen extends StatelessWidget {
  const MonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text("Monitoring"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // TODO: Handle refresh
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Last updated: less than a minute ago',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),

            /// Tab bar (fake static)
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F6),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Row(
                children: [
                  _buildTab(text: 'Temp', selected: false),
                  _buildTab(text: 'Humidity', selected: false),
                  _buildTab(text: 'Soil', selected: true),
                  _buildTab(text: 'Light', selected: false),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Chart Card
            _buildChartCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({required String text, required bool selected}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: selected ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildChartCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '24-Hour History',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),

            /// Chart (dummy data)
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          return Text(
                            value.toInt() % 6 == 0 ? '${value.toInt()}:00' : '',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                        interval: 3,
                      ),
                    ),
                    rightTitles: AxisTitles(),
                    topTitles: AxisTitles(),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 30),
                        FlSpot(3, 35),
                        FlSpot(6, 40),
                        FlSpot(9, 45),
                        FlSpot(12, 50),
                        FlSpot(15, 52),
                        FlSpot(18, 50),
                        FlSpot(21, 47),
                        FlSpot(24, 44),
                      ],
                      isCurved: true,
                      color: const Color(0xFF89C17A),
                      barWidth: 2,
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF89C17A).withOpacity(0.2),
                      ),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _MonitoringStat(title: "Current soil moisture", value: "42%"),
                _MonitoringStat(title: "Average (24h)", value: "49%"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MonitoringStat extends StatelessWidget {
  final String title;
  final String value;

  const _MonitoringStat({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
