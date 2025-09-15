import 'package:basketball_app/widgets/workout_trend.dart';
import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  //Container screen for the WorkoutTrendWidget to show progression over time
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WorkoutTrendWidget(),
    );
  }
}
