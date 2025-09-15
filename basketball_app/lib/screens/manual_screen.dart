import 'package:basketball_app/models/workout.dart';
import 'package:basketball_app/widgets/enter_workout.dart';
import 'package:flutter/material.dart';

class ManualScreen extends StatelessWidget {
  const ManualScreen({super.key, required this.onSave, this.workout});

  final Workout? workout;

  //Container for the EnterWorkoutScreen to manually enter workout data
  final void Function(Workout workout) onSave;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        title: Text('Manual Workout Entry', style: Theme.of(context).textTheme.titleLarge,),
      ),
      body: Center(
        child: EnterWorkoutScreen(onSave: onSave, workout: workout,),
      ),
    );
  }
}