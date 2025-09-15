import 'package:basketball_app/data/db_helper.dart';
import 'package:basketball_app/screens/manual_screen.dart';
import 'package:basketball_app/widgets/shots_viewer.dart';
import 'package:flutter/material.dart';
import 'package:basketball_app/models/workout.dart';
//Screen to show details of a specific workout
class WorkoutDetails extends StatefulWidget {
  Workout workout;
  final Future<void> Function() refreshWorkouts;

  WorkoutDetails(
      {super.key, required this.workout, required this.refreshWorkouts});

  @override
  State<WorkoutDetails> createState() => _WorkoutDetailsState();
}

class _WorkoutDetailsState extends State<WorkoutDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        title: Text('Workout Details',
            style: Theme.of(context).textTheme.titleLarge),
        //Buttons to edit or delete a workout
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Theme.of(context).iconTheme.color),
            style: IconButton.styleFrom(iconSize: 36),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return ManualScreen(
                    onSave: (workout) async {
                      await DBHelper().updateWorkout(workout);
                      widget.refreshWorkouts();
                      setState(() {
                        widget.workout = workout;
                      });
                    },
                    workout: widget.workout,
                  );
                },
              ));
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Theme.of(context).iconTheme.color),
            style: IconButton.styleFrom(iconSize: 36),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete Workout'),
                    content: const Text(
                        'Are you sure you want to delete this workout?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          DBHelper().deleteWorkout(widget.workout.workoutId!);
                          widget.refreshWorkouts();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
      body: Padding(
        //Details about the specific workout (date, duration, notes, statistics)
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.workout.workoutDateTime}'.split(' ')[0],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${widget.workout.duration.inMinutes ~/ 60}:${(widget.workout.duration.inMinutes % 60).toString().padLeft(2, '0')}:${(widget.workout.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Notes:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .secondaryContainer
                      .withOpacity(0.9),
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
                constraints: const BoxConstraints(
                  minHeight: 200,
                  maxHeight: 200,
                  minWidth: double.infinity,
                ),
                child: SingleChildScrollView(
                    child: Text(widget.workout.notes,
                        style: const TextStyle(fontSize: 16))),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Workout Statistics',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                'Accuracy',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(width: 8),
                              Tooltip(
                                message:
                                    'The percentage of shots made out of total shots taken',
                                triggerMode: TooltipTriggerMode.tap,
                                enableTapToDismiss: true,
                                child: Icon(Icons.info_outline, size: 16),
                              ),
                            ],
                          ),
                          Text(
                            '${widget.workout.totalShotsMadeCount}/${widget.workout.totalShotsCount}  ${widget.workout.accuracy.toStringAsFixed(1)}%',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Row(
                            children: [
                              Text('Release Height',
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(width: 8),
                              Tooltip(
                                message:
                                    'The average height at which the ball is released during the shot',
                                triggerMode: TooltipTriggerMode.tap,
                                enableTapToDismiss: true,
                                child: Icon(Icons.info_outline, size: 16),
                              ),
                            ],
                          ),
                          Text('${widget.workout.releaseHeightsMean} \'',
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text('Release Time',
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(width: 8),
                              Tooltip(
                                message:
                                    'The average time it takes to release the ball after starting the shooting motion',
                                triggerMode: TooltipTriggerMode.tap,
                                enableTapToDismiss: true,
                                child: Icon(Icons.info_outline, size: 16),
                              ),
                            ],
                          ),
                          Text('${widget.workout.releaseTimesMean} s',
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Row(
                            children: [
                              Text('Entry Angle', style: TextStyle(fontSize: 16)),
                              SizedBox(width: 8),
                              Tooltip(
                                message:
                                    'The average angle at which the ball enters the basket, ideally 45°',
                                triggerMode: TooltipTriggerMode.tap,
                                enableTapToDismiss: true,
                                child: Icon(Icons.info_outline, size: 16),
                              ),
                            ],
                          ),
                          Text('${widget.workout.entryAnglesMean}°',
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text('Shot Depth', style: TextStyle(fontSize: 16)),
                              SizedBox(width: 8),
                              Tooltip(
                                message:
                                    'The distance between the center of the rim and the ball when it enters the basket, ideally around 3"',
                                triggerMode: TooltipTriggerMode.tap,
                                enableTapToDismiss: true,
                                child: Icon(Icons.info_outline, size: 16),
                              ),
                            ],
                          ),
                          Text('${widget.workout.shotDepthsMean} "',
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Row(
                            children: [
                              Text('Shot Position',
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(width: 8),
                              Tooltip(
                                message:
                                    'The horizontal distance between the center of the rim and the ball when it enters the basket, ideally in the center',
                                triggerMode: TooltipTriggerMode.tap,
                                enableTapToDismiss: true,
                                child: Icon(Icons.info_outline, size: 16),
                              ),
                            ],
                          ),
                          Text('${widget.workout.shotPositionsMean} "',
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 400,
                //View of the shots taken during the workout
                child: ShotViewer(workout: widget.workout),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
