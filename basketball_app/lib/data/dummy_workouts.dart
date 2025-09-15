import 'package:basketball_app/models/workout.dart';
import 'package:basketball_app/models/shot.dart';

List<Workout> dummyWorkouts = [
  Workout(
    workoutDateTime: DateTime(2020, 1, 5),
    duration: const Duration(minutes: 60),
    notes: 'Good workout session',
    /*shots: [
      Shot(shotMade: true, releaseHeight: 2.1, releaseTime: 1.2, entryAngle: 45.0, shotDepth: 5.0, shotPosition: 5.0),
      Shot(shotMade: false, releaseHeight: 2.3, releaseTime: 1.1, entryAngle: 50.0, shotDepth: 6.0, shotPosition: 12.0),
      // Add more shots as needed
    ]*/
    totalShots: 10,
    totalShotsMade: 7,
  ),
  Workout(
    workoutDateTime: DateTime(2021, 8, 10),
    duration: const Duration(minutes: 45),
    notes: 'Focused on free throws',
    shots: [
      Shot(shotMade: true, releaseHeight: 2.0, releaseTime: 1.3, entryAngle: 47.0, shotDepth: 5.5, shotPosition: 11.0),
      Shot(shotMade: true, releaseHeight: 2.1, releaseTime: 1.2, entryAngle: 46.0, shotDepth: 5.8, shotPosition: 11.5),
      // Add more shots as needed
    ],
  ),
  Workout(
    workoutDateTime: DateTime(2023, 9, 5),
    duration: const Duration(minutes: 30),
    notes: 'Quick morning practice',
    shots: [
      Shot(shotMade: false, releaseHeight: 2.2, releaseTime: 1.0, entryAngle: 43.0, shotDepth: 6.1, shotPosition: 10.5),
      Shot(shotMade: true, releaseHeight: 2.3, releaseTime: 1.1, entryAngle: 44.0, shotDepth: 6.3, shotPosition: 10.7),
      // Add more shots as needed
    ],
  ),
  Workout(
    workoutDateTime: DateTime(2023, 10, 2),
    duration: const Duration(minutes: 90),
    notes: 'Intense session with a lot of 3-point shots',
    shots: [
      Shot(shotMade: true, releaseHeight: 2.4, releaseTime: 1.4, entryAngle: 49.0, shotDepth: 7.0, shotPosition: 14.0),
      Shot(shotMade: false, releaseHeight: 2.5, releaseTime: 1.5, entryAngle: 48.0, shotDepth: 7.2, shotPosition: 14.5),
      // Add more shots as needed
    ],
  ),
  Workout(
    workoutDateTime: DateTime(2023, 11, 12),
    duration: const Duration(minutes: 50),
    notes: 'Focus on mid-range shots',
    shots: [
      Shot(shotMade: true, releaseHeight: 2.6, releaseTime: 1.2, entryAngle: 42.0, shotDepth: 6.0, shotPosition: 13.0),
      Shot(shotMade: true, releaseHeight: 2.7, releaseTime: 1.1, entryAngle: 41.0, shotDepth: 6.2, shotPosition: 13.5),
      // Add more shots as needed
    ],
  ),
  Workout(
    workoutDateTime: DateTime(2023, 12, 25),
    duration: const Duration(minutes: 70),
    notes: 'Holiday workout',
    shots: [
      Shot(shotMade: false, releaseHeight: 2.8, releaseTime: 1.3, entryAngle: 50.0, shotDepth: 5.9, shotPosition: 12.0),
      Shot(shotMade: true, releaseHeight: 2.9, releaseTime: 1.2, entryAngle: 51.0, shotDepth: 6.1, shotPosition: 12.5),
      // Add more shots as needed
    ],
  ),
  Workout(
    workoutDateTime: DateTime(2024, 1, 14),
    duration: const Duration(minutes: 40),
    notes: 'New year, new goals',
    shots: [
      Shot(shotMade: true, releaseHeight: 2.0, releaseTime: 1.1, entryAngle: 45.0, shotDepth: 5.5, shotPosition: 10.0),
      Shot(shotMade: false, releaseHeight: 2.1, releaseTime: 1.3, entryAngle: 46.0, shotDepth: 5.7, shotPosition: 10.5),
      // Add more shots as needed
    ],
  ),
  Workout(
    workoutDateTime: DateTime(2024, 2, 28),
    duration: const Duration(minutes: 55),
    notes: 'Worked on layups',
    shots: [
      Shot(shotMade: true, releaseHeight: 2.2, releaseTime: 1.0, entryAngle: 44.0, shotDepth: 6.0, shotPosition: 9.5),
      Shot(shotMade: false, releaseHeight: 2.3, releaseTime: 1.2, entryAngle: 45.0, shotDepth: 6.2, shotPosition: 10.0),
      // Add more shots as needed
    ],
  ),
  Workout(
    workoutDateTime: DateTime(2024, 3, 3),
    duration: const Duration(minutes: 65),
    notes: 'Evening practice with friends',
    shots: [
      Shot(shotMade: true, releaseHeight: 2.1, releaseTime: 1.4, entryAngle: 47.0, shotDepth: 5.8, shotPosition: 11.0),
      Shot(shotMade: false, releaseHeight: 2.4, releaseTime: 1.5, entryAngle: 48.0, shotDepth: 5.9, shotPosition: 11.5),
      // Add more shots as needed
    ],
  ),
  Workout(
    workoutDateTime: DateTime(2024, 4, 10),
    duration: const Duration(minutes: 80),
    notes: 'Endurance training',
    shots: [
      Shot(shotMade: false, releaseHeight: 2.5, releaseTime: 1.6, entryAngle: 49.0, shotDepth: 6.3, shotPosition: 12.0),
      Shot(shotMade: true, releaseHeight: 2.6, releaseTime: 1.7, entryAngle: 50.0, shotDepth: 6.5, shotPosition: 12.5),
      // Add more shots as needed
    ],
  ),
  Workout(
    workoutDateTime: DateTime(2024, 5, 1),
    duration: const Duration(minutes: 35),
    notes: 'Quick warm-up',
    shots: [
      Shot(shotMade: true, releaseHeight: 2.7, releaseTime: 1.5, entryAngle: 42.0, shotDepth: 6.8, shotPosition: 13.0),
      Shot(shotMade: true, releaseHeight: 2.8, releaseTime: 1.4, entryAngle: 43.0, shotDepth: 7.0, shotPosition: 13.5),
      // Add more shots as needed
    ],
  ),
  Workout(
    workoutDateTime: DateTime(2024, 6, 20),
    duration: const Duration(minutes: 75),
    notes: 'Summer workout',
    shots: [
      Shot(shotMade: false, releaseHeight: 2.9, releaseTime: 1.2, entryAngle: 50.0, shotDepth: 6.1, shotPosition: 12.5),
      Shot(shotMade: true, releaseHeight: 3.0, releaseTime: 1.1, entryAngle: 51.0, shotDepth: 6.3, shotPosition: 13.0),
      // Add more shots as needed
    ],
  ),
  Workout(
    workoutDateTime: DateTime(2024, 7, 10),
    duration: const Duration(minutes: 50),
    notes: 'Focused on technique',
    shots: [
      Shot(shotMade: true, releaseHeight: 2.1, releaseTime: 1.0, entryAngle: 45.0, shotDepth: 5.5, shotPosition: 10.0),
      Shot(shotMade: false, releaseHeight: 2.2, releaseTime: 1.2, entryAngle: 46.0, shotDepth: 5.8, shotPosition: 10.5),
      // Add more shots as needed
    ],
  ),
  Workout(
    workoutDateTime: DateTime(2023, 8, 5),
    duration: const Duration(minutes: 60),
    notes: 'Morning session',
    shots: [
      Shot(shotMade: true, releaseHeight: 2.3, releaseTime: 1.1, entryAngle: 47.0, shotDepth: 6.0, shotPosition: 11.0),
      Shot(shotMade: false, releaseHeight: 2.4, releaseTime: 1.3, entryAngle: 48.0, shotDepth: 6.2, shotPosition: 11.5),
      // Add more shots as needed
    ],
  ),
  Workout(
    workoutDateTime: DateTime(2023, 9, 20),
    duration: const Duration(minutes: 85),
    notes: 'Evening endurance training',
    shots: [
      Shot(shotMade: true, releaseHeight: 2.5, releaseTime: 1.5, entryAngle: 49.0, shotDepth: 6.4, shotPosition: 12.0),
      Shot(shotMade: false, releaseHeight: 2.6, releaseTime: 1.6, entryAngle: 50.0, shotDepth: 6.6, shotPosition: 12.5),
      // Add more shots as needed
    ],
  ),
  Workout(
    workoutDateTime: DateTime(2023, 10, 15),
    duration: const Duration(minutes: 30),
    notes: 'Focused on free throws',
    shots: [
      Shot(shotMade: true, releaseHeight: 2.0, releaseTime: 1.2, entryAngle: 45.0, shotDepth: 5.7, shotPosition: 10.0),
      Shot(shotMade: true, releaseHeight: 2.1, releaseTime: 1.1, entryAngle: 46.0, shotDepth: 5.9, shotPosition: 10.5),
      // Add more shots as needed
    ],
  ),
  Workout(
    workoutDateTime: DateTime(2023, 11, 10),
    duration: const Duration(minutes: 70),
    notes: 'Three-point practice',
    shots: [
      Shot(shotMade: false, releaseHeight: 2.2, releaseTime: 1.0, entryAngle: 48.0, shotDepth: 6.0, shotPosition: 11.0),
      Shot(shotMade: true, releaseHeight: 2.3, releaseTime: 1.1, entryAngle: 49.0, shotDepth: 6.2, shotPosition: 11.5),
      // Add more shots as needed
    ],
  ),
  Workout(
    workoutDateTime: DateTime(2023, 12, 5),
    duration: const Duration(minutes: 40),
    notes: 'Quick practice before the game',
    shots: [
      Shot(shotMade: true, releaseHeight: 2.4, releaseTime: 1.3, entryAngle: 50.0, shotDepth: 6.4, shotPosition: 12.0),
      Shot(shotMade: false, releaseHeight: 2.5, releaseTime: 1.4, entryAngle: 51.0, shotDepth: 6.6, shotPosition: 12.5),
      // Add more shots as needed
    ],
  ),
  Workout(
    workoutDateTime: DateTime(2024, 8, 1),
    duration: const Duration(minutes: 100),
    notes: 'New year, new challenges',
    // shots: [
    //   Shot(shotMade: true, releaseHeight: 2.6, releaseTime: 1.2, entryAngle: 42.0, shotDepth: 6.0, shotPosition: 10.5),
    //   Shot(shotMade: false, releaseHeight: 2.7, releaseTime: 1.1, entryAngle: 43.0, shotDepth: 6.2, shotPosition: 11.0),
    //   // Add more shots as needed
    // ],
    totalShots: 4,
    totalShotsMade: 2,
  ),
  Workout(
    workoutDateTime: DateTime(2024, 8, 14),
    duration: const Duration(minutes: 50),
    notes: 'Valentine\'s day workout',
    shots: [
      Shot(shotMade: true, releaseHeight: 2.8, releaseTime: 1.3, entryAngle: 44.0, shotDepth: 5.5, shotPosition: 10.0),
      Shot(shotMade: true, releaseHeight: 2.9, releaseTime: 1.2, entryAngle: 45.0, shotDepth: 5.7, shotPosition: 10.5),
      // Add more shots as needed
    ],
  ),
];
