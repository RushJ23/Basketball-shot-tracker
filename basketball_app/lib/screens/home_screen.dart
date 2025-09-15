import 'package:basketball_app/data/db_helper.dart';
import 'package:basketball_app/models/workout.dart';
import 'package:flutter/material.dart';
import '../widgets/workout_item.dart';
import '../widgets/bottom_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
//Main screen displaying workouts
class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Workout>> workouts;
  //Refreshes workouts when one is updated or deleted
  Future<void> _refreshWorkouts() async {
    setState(() {
      workouts = DBHelper().getAllWorkoutsWithShots();
    });
  }

  @override
  void initState() {
    super.initState();
    workouts = DBHelper().getAllWorkoutsWithShots();
  }
  //Opens when plus clicked to show options to add a new workout
  void _openBottomModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomModal(
          onSave: (workout) async{
            await DBHelper().insertWorkout(workout);
            setState(() {
              workouts = DBHelper().getAllWorkoutsWithShots();
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Shows workouts when the workouts are loaded
        FutureBuilder<List<Workout>>(
          future: workouts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No workouts found.'));
            } else { 
              return ListView.builder(
                padding: const EdgeInsets.only(
                    bottom: 80), // Adjust padding to avoid overlap
                itemCount: snapshot.data!.length, 
                itemBuilder: (context, index) {
                  return WorkoutItem(workout: snapshot.data![index], refreshWorkouts: _refreshWorkouts);
                },
              );
            }
          },
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Center(
            child: FloatingActionButton(
              onPressed: () => _openBottomModal(context),
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}
