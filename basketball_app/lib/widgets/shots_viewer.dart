import 'package:basketball_app/models/workout.dart';
import 'package:basketball_app/widgets/rim_widget.dart';
import 'package:flutter/material.dart';

// Widget to view individual shots from a workout, displaying shot details and a visualization
class ShotViewer extends StatefulWidget {
  final Workout workout;  // The workout containing the shots to view

  const ShotViewer({super.key, required this.workout});

  @override
  State<ShotViewer> createState() => _ShotViewerState();
}

class _ShotViewerState extends State<ShotViewer> {
  int _currentIndex = 0;  // Track the current shot being viewed

  // Navigate to the next shot
  void _nextShot() {
    setState(() {
      if (_currentIndex < widget.workout.shots!.length - 1) {
        _currentIndex++;
      }
    });
  }

  // Navigate to the previous shot
  void _previousShot() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show a message if there are no shots available in the workout
    if (widget.workout.shots == null) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            "No shots available",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    final shot = widget.workout.shots![_currentIndex];

    return Container(
      padding: const EdgeInsets.all(16.0),
      height: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Column to display shot information and navigation buttons
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row with back and forward buttons to navigate through shots
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _currentIndex == 0 ? null : _previousShot,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    disabledColor: Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(0.5),
                  ),
                  Text(
                    'Shot ${_currentIndex + 1}',  // Display shot number
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: _currentIndex == widget.workout.shots!.length - 1
                        ? null
                        : _nextShot,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                shot.shotMade ? 'Make' : 'Missed',  // Display whether the shot was made
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // Display shot details such as angle, release height, release time, depth, and position
              Text(
                'Angle: ${shot.entryAngle.toStringAsFixed(1)}°\n'
                'Release height: ${shot.releaseHeight.toStringAsFixed(2)}\'\n'
                'Release time: ${shot.releaseTime.toStringAsFixed(2)}s\n'
                'Shot depth: ${shot.shotDepth.toStringAsFixed(2)}"\n'
                'Shot position: ${shot.shotPosition.toStringAsFixed(2)}"\n',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Widget to visualize the shot position relative to the basketball rim
          Expanded(
            child: BasketballRimWidget(
              position: Offset(shot.shotPosition, shot.shotDepth),
            ),
          ),
        ],
      ),
    );
  }
}
