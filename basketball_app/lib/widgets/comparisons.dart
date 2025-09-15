import 'package:basketball_app/models/workout.dart';
import 'package:flutter/material.dart';

// Comparisons widget allows the user to compare workout statistics between two date ranges.
class Comparisons extends StatelessWidget {
  Comparisons({
    super.key,
    required this.workouts,
    required this.fromDate,
    required this.toDate,
  });

  // List of all workouts to analyze.
  final List<Workout> workouts;

  // Date range for comparison.
  final DateTime? fromDate;
  final DateTime? toDate;

  double? oldStat; 
  double? newStat;  
  List<double> oldStats = [];  // List of old stats for each index.
  List<double> newStats = [];  // List of new stats for each index.

  // List of workout statistic names for comparison.
  static const indexMap = [
    "Release height",
    "Release time",
    "Entry Angle",
    "Shot Depth",
    "Shot Position",
    "Accuracy",
  ];

  // Widget to display comparison of an individual stat with color indication of improvement or decline.
  Widget displayComparison(double oldValue, double newValue, String stat) {
    // Determine color based on the stat and the values (e.g., green for improvement, red for decline).
    Color color;
    if (stat == "Entry Angle") {
      color = (newValue - 45).abs() < (oldValue - 45).abs()
          ? Colors.green
          : (newValue - 45).abs() > (oldValue - 45).abs()
              ? Colors.red
              : Colors.grey;
    } else if (stat == "Shot Position") {
      color = newValue.abs() < oldValue.abs() ? Colors.green : newValue.abs() > oldValue.abs() ? Colors.red : Colors.grey;
    } else if (stat == "Shot Depth") {
      color = (newValue - 3).abs() < (oldValue - 3).abs() ? Colors.green : (newValue - 3).abs() > (oldValue - 3).abs() ? Colors.red : Colors.grey;
    } else if (stat == "Release time") {
      color = newValue < oldValue ? Colors.green : newValue > oldValue ? Colors.red : Colors.grey;
    } else {
      color = newValue > oldValue ? Colors.green : newValue < oldValue ? Colors.red : Colors.grey;
    }

    return ListTile(
      title: Text(stat),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Old: $oldValue', style: const TextStyle(fontSize: 16)),
          Text('New: $newValue', style: TextStyle(color: color, fontSize: 20)),
        ],
      ),
    );
  }

  // Finds the closest workout statistic to a given date for the specified index.
  double _getClosestWorkoutStat(DateTime date, int index) {
    Workout closestWorkout = workouts.reduce((a, b) {
      final aDiff = a.workoutDateTime.difference(date).abs();
      final bDiff = b.workoutDateTime.difference(date).abs();
      return aDiff < bDiff ? a : b;
    });
    return closestWorkout.meanValues[index];
  }

  // Calculates the average statistic over workouts within a date range for the specified index.
  double _calculateAverageStats(DateTime start, DateTime end, int index) {
    List<Workout> relevantWorkouts = workouts.where((workout) {
      return workout.workoutDateTime.isAfter(start) &&
          workout.workoutDateTime.isBefore(end);
    }).toList();
    
    double total = relevantWorkouts.fold(0.0, (sum, workout) => sum + workout.meanValues[index]);
    return relevantWorkouts.isEmpty
        ? _getClosestWorkoutStat(start, index)
        : total / relevantWorkouts.length;
  }

  // Fetches the stats for both old and new date ranges based on the selected dates.
  List<List<double>> _getComparisonStats() {
    final oldStats = <double>[];
    final newStats = <double>[];
    
    for (var index = 0; index < indexMap.length; index++) {
      if (toDate!.difference(fromDate!).inDays < 7) {
        // If the range is short, get the closest workout stats.
        oldStat = _getClosestWorkoutStat(fromDate!, index);
        newStat = _getClosestWorkoutStat(toDate!, index);
      } else {
        // Otherwise, calculate average stats over a date range.
        oldStat = _calculateAverageStats(
            fromDate!.subtract(const Duration(days: 3)),
            fromDate!.add(const Duration(days: 3)),
            index);
        newStat = _calculateAverageStats(
            toDate!.subtract(const Duration(days: 3)),
            toDate!.add(const Duration(days: 3)),
            index);
      }
      oldStats.add(oldStat!);
      newStats.add(newStat!);
    }
    return [oldStats, newStats];
  }

  @override
  Widget build(BuildContext context) {
    // Display message if date range or workout data is invalid.
    if (fromDate == null || toDate == null || workouts.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(
          child: Text('Please select a date range with workout data'),
        ),
      );
    }

    // Calculate the old and new stats for each metric.
    final stats = _getComparisonStats();
    oldStats = stats[0];
    newStats = stats[1];

    // Display comparison for each stat in the list.
    return Column(
      children: [
        ListTile(
          title: const Text('Comparisons'),
          subtitle: Text(
            'From ${fromDate!.toIso8601String().substring(0, 7)} to ${toDate!.toIso8601String().substring(0, 7)}',
          ),
        ),
        for (var index = 0; index < indexMap.length; index++)
          displayComparison(oldStats[index], newStats[index], indexMap[index]),
      ],
    );
  }
}
