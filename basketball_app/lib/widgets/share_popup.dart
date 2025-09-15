import 'package:basketball_app/data/db_helper.dart';
import 'package:basketball_app/models/settings_provider.dart';
import 'package:basketball_app/models/shot.dart';
import 'package:basketball_app/models/workout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:provider/provider.dart';

// Widget to display a share popup with a dynamically generated message
class SharePopup extends StatelessWidget {
  const SharePopup({super.key});

  // Calculate workout statistics from the given list of workouts
  Map<String, dynamic> calculateWorkoutStats(List<Workout> workouts) {
    int totalShots = 0;
    int totalMade = 0;
    int totalWorkouts = workouts.length;
    
    // Lists to gather stats for calculating means and quartiles
    List<double> releaseHeights = [];
    List<double> releaseTimes = [];
    List<double> shotDepths = [];
    List<double> shotPositions = [];
    List<double> entryAngles = [];

    // Aggregate stats from each workout
    for (Workout workout in workouts) {
      if (workout.shots != null) {
        totalShots += workout.shots!.length;
        totalMade += workout.shots!.where((shot) => shot.shotMade).length;

        for (Shot shot in workout.shots!) {
          releaseHeights.add(shot.releaseHeight);
          releaseTimes.add(shot.releaseTime);
          shotDepths.add(shot.shotDepth);
          shotPositions.add(shot.shotPosition);
          entryAngles.add(shot.entryAngle);
        }
      } else {
        totalShots += workout.totalShots ?? 0;
        totalMade += workout.totalShotsMade ?? 0;
      }
    }

    // Helper function to calculate mean of a list
    String mean(List<double> values) {
      if (values.isEmpty) {
        return '0.00';
      }
      return (values.reduce((a, b) => a + b) / values.length).toStringAsFixed(2);
    }

    // Helper function to calculate Q1-Q3 range as quartiles
    String calculateQuartiles(List<double> values) {
      values.sort();
      int n = values.length;
      if (n == 0) {
        return '0 - 0';
      }
      double q1 = values[(n / 4).floor()];
      double q3 = values[(3 * n / 4).floor()];
      return "$q1 - $q3";
    }

    // Calculate accuracy percentage
    String accuracy = (totalShots == 0 ? 0 : (totalMade / totalShots) * 100).toStringAsFixed(2);
    // Calculate quartiles for each stat
    String quartileReleaseHeight = calculateQuartiles(releaseHeights);
    String quartileReleaseTime = calculateQuartiles(releaseTimes);
    String quartileShotDepth = calculateQuartiles(shotDepths);
    String quartileShotPosition = calculateQuartiles(shotPositions);
    String quartileEntryAngle = calculateQuartiles(entryAngles);

    return {
      'Accuracy': accuracy,
      'Shots': totalShots,
      'Made': totalMade,
      'Mean_release_height': mean(releaseHeights),
      'Mean_release_time': mean(releaseTimes),
      'Mean_shot_depth': mean(shotDepths),
      'Mean_shot_position': mean(shotPositions),
      'Mean_entry_angle': mean(entryAngles),
      'Quartile_release_height': quartileReleaseHeight,
      'Quartile_release_time': quartileReleaseTime,
      'Quartile_shot_depth': quartileShotDepth,
      'Quartile_shot_position': quartileShotPosition,
      'Quartile_entry_angle': quartileEntryAngle,
      'Total_workouts': totalWorkouts,
    };
  }

  // Generate the share text by replacing placeholders with actual stats
  Future<String> generateDummyText(context, shareMessage) async {
    List<Workout> workouts = await DBHelper().getWorkoutsInDateRange(
      DateTime.now().subtract(const Duration(days: 31)), 
      DateTime.now()
    ); 
    if (workouts.isEmpty) {
      return 'No workouts found in the last 31 days.';
    }
    Map<String, dynamic> workoutStats = calculateWorkoutStats(workouts);
    
    workoutStats.forEach((key, value) {
      shareMessage = shareMessage.replaceAll('{$key}', value.toString());
    });

    return shareMessage;
  }

  // Function to display the share popup with the generated message
  void _showPopup(BuildContext context, String shareMessage) async {
    String dynamicText = await generateDummyText(context, shareMessage);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Share'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(dynamicText),  // Display generated text
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.copy),
                    label: const Text("Copy"),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: dynamicText));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Text copied to clipboard')),
                      );
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.share),
                    label: const Text("Share"),
                    onPressed: () {
                      Share.share(dynamicText);
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      onPressed: () {
        _showPopup(context, context.read<SettingsProvider>().shareMessage);
      },
      child: const Text('Share'),
    );
  }
}
