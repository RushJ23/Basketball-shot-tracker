import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatelessWidget {
  final List<dynamic> data;

  const LineChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Display a message if no data is available
    if (data.isEmpty) {
      return const Center(
        child: Text('No data to display'),
      );
    }
    
    // Sort the data by date to ensure it displays in chronological order
    data.sort((a, b) => a[1].compareTo(b[1]));

    // Map the data to FlSpots for rendering the line chart.
    List<FlSpot> spots = data.map((entry) {
      DateTime date = entry[1];
      double value = entry[0];
      // Calculate x-axis value as days since 2000
      double xValue = date.difference(DateTime(2000, 1, 1)).inDays.toDouble();
      return FlSpot(xValue, value);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          // Define the line data for the chart
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,  // Curve the line for smoother appearance
              barWidth: 2,
              color: Colors.blue, 
              dotData: const FlDotData(show: true),  // Show dots on data points
            ),
          ],
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),  // Hide right titles
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),  // Hide top titles
            ),
            // Configure the bottom axis to display dates
            bottomTitles: AxisTitles(
              axisNameWidget: const Text('Date'),
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  DateTime(2000, 1, 1)
                      .add(Duration(days: value.toInt()))
                      .toString()
                      .substring(2, 7),  // Display only year and month
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
          ),
          minY: 0,  // Set minimum Y-axis value to 0
        ),
      ),
    );
  }
}
