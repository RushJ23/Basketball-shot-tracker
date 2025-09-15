import 'package:basketball_app/models/settings_provider.dart';
import 'package:basketball_app/models/workout.dart';
import 'package:basketball_app/screens/workout_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Widget to display a summary of a workout session as a list item
class WorkoutItem extends StatelessWidget {
  final Workout workout;  // Workout data to display
  final Future<void> Function() refreshWorkouts;  // Callback to refresh workouts after viewing details

  const WorkoutItem({super.key, required this.workout, required this.refreshWorkouts});

  @override
  Widget build(BuildContext context) {
    // Settings flags to determine if mean or quartile values are shown for various stats
    final showReleaseHeightMean = context.watch<SettingsProvider>().showReleaseHeightMean;
    final showReleaseTimeMean = context.watch<SettingsProvider>().showReleaseTimeMean;
    final showShotDepthMean = context.watch<SettingsProvider>().showShotDepthMean;
    final showShotPositionMean = context.watch<SettingsProvider>().showShotPositionMean;
    final showEntryAngleMean = context.watch<SettingsProvider>().showEntryAngleMean;

    return InkWell(
      // Navigate to detailed workout view on tap
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => WorkoutDetails(workout: workout, refreshWorkouts: refreshWorkouts,)));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display date and time of the workout
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat('MM/dd/yy').format(workout.workoutDateTime)),
                  Text(DateFormat('HH:mm').format(workout.workoutDateTime)),
                ],
              ),
              const SizedBox(height: 4),
              Divider(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              // Row displaying workout accuracy and total shots
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatColumn("Accuracy", "${workout.accuracy.toStringAsFixed(1)}%"),
                  _buildStatColumn("Total Shots", workout.totalShotsCount.toString()),
                ],
              ),
              const SizedBox(height: 8),
              // Row displaying release height and release time stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatColumn(
                    "Release Height",
                    showReleaseHeightMean ? "${workout.releaseHeightsMean}\"" : "${workout.releaseHeightsQ1}-${workout.releaseHeightsQ3}'",
                  ),
                  _buildStatColumn(
                    "Release Time",
                    showReleaseTimeMean ? "${workout.releaseTimesMean}s" : "${workout.releaseTimesQ1}-${workout.releaseTimesQ3}s",
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Row displaying shot depth and shot position stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatColumn(
                    "Shot Depth",
                    showShotDepthMean ? "${workout.shotDepthsMean}\"" : "${workout.shotDepthsQ1}-${workout.shotDepthsQ3}\"",
                  ),
                  _buildStatColumn(
                    "Shot Position",
                    showShotPositionMean ? "${workout.shotPositionsMean}\"" : "${workout.shotPositionsQ1}-${workout.shotPositionsQ3}\"",
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Row displaying entry angle and workout duration
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatColumn(
                    "Entry Angle",
                    showEntryAngleMean ? "${workout.entryAnglesMean}°" : "${workout.entryAnglesQ1}-${workout.entryAnglesQ3}°",
                  ),
                  _buildStatColumn("Duration", "${workout.duration.inMinutes} minutes"),
                ],
              ),
              const SizedBox(height: 8),
              Divider(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              // Display workout notes
              const Text(
                "Note",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                workout.notes,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to display a stat label and its corresponding value
  Widget _buildStatColumn(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Text(value),
      ],
    );
  }
}
