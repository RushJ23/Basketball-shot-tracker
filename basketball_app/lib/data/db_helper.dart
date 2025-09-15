import 'package:basketball_app/data/dummy_workouts.dart';
import 'package:basketball_app/models/shot.dart';
import 'package:basketball_app/models/workout.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._();
  static Database? _database;

  DBHelper._();

  factory DBHelper() {
    return _instance;
  }

  // Initialize the database if it's not already opened
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Database initialization, creating tables for Workout and Shot
  static Future<Database> _initDB() async {
    // Uncomment the line below to delete the database for testing
    // await deleteDatabase(join(await getDatabasesPath(), 'workouts.db'));
    return openDatabase(
      join(await getDatabasesPath(), 'workouts.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Workout (
            workoutId INTEGER PRIMARY KEY AUTOINCREMENT,
            workoutDateTime TEXT NOT NULL,
            duration INTEGER NOT NULL,
            notes TEXT,
            totalShots INTEGER,
            totalShotsMade INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE Shot (
            shotId INTEGER PRIMARY KEY AUTOINCREMENT,
            shotMade INTEGER NOT NULL,
            releaseHeight REAL NOT NULL,
            releaseTime REAL NOT NULL,
            entryAngle REAL NOT NULL,
            shotDepth REAL NOT NULL,
            shotPosition REAL NOT NULL,
            workoutId INTEGER NOT NULL,
            FOREIGN KEY (workoutId) REFERENCES Workout(workoutId) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  // Retrieve all workouts with associated shots
  Future<List<Workout>> getAllWorkoutsWithShots() async {
    final db = await database;
    final List<Map<String, dynamic>> workoutMaps = await db.query('Workout', orderBy: 'workoutDateTime DESC');

    List<Workout> workouts = [];
    for (var workoutMap in workoutMaps) {
      final List<Map<String, dynamic>> shotMaps = await db.query(
        'Shot',
        where: 'workoutId = ?',
        whereArgs: [workoutMap['workoutId']],
      );

      List<Shot> shots = shotMaps.map((shotMap) => Shot.fromMap(shotMap)).toList();
      Workout workout = Workout.fromMap(workoutMap, shots);
      workouts.add(workout);
    }

    return workouts;
  }

  // Insert a new workout and its associated shots into the database
  Future<void> insertWorkout(Workout workout) async {
    final db = await database;
    final workoutId = await db.insert(
      'Workout',
      workout.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (workout.shots != null) {
      for (var shot in workout.shots!) {
        await db.insert(
          'Shot',
          shot.toMap(workoutId),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
  }

  // Populate the database with dummy workouts for testing
  Future<void> populateWorkouts() async {
    for (Workout workout in dummyWorkouts) {
      await insertWorkout(workout);
    }
  }

  // Delete a workout and its associated shots by workoutId
  Future<void> deleteWorkout(int workoutId) async {
    final db = await database;
    await db.delete(
      'Workout',
      where: 'workoutId = ?',
      whereArgs: [workoutId],
    );
    await db.delete(
      'Shot',
      where: 'workoutId = ?',
      whereArgs: [workoutId],
    );
  }

  // Update a workout and replace its associated shots
  Future<void> updateWorkout(Workout workout) async {
    final db = await database;
    await db.update(
      'Workout',
      workout.toMap(),
      where: 'workoutId = ?',
      whereArgs: [workout.workoutId],
    );

    // Delete and re-insert associated shots to update them
    await db.delete(
      'Shot',
      where: 'workoutId = ?',
      whereArgs: [workout.workoutId],
    );
    if (workout.shots != null) {
      for (var shot in workout.shots!) {
        await db.insert(
          'Shot',
          shot.toMap(workout.workoutId!),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
  }

  // Retrieve workouts within a specific date range, including shots
  Future<List<Workout>> getWorkoutsInDateRange(DateTime fromDate, DateTime toDate) async {
    final db = await database;
    final List<Map<String, dynamic>> workoutMaps = await db.query(
      'Workout',
      where: 'workoutDateTime BETWEEN ? AND ?',
      whereArgs: [fromDate.toIso8601String(), toDate.toIso8601String()],
      orderBy: 'workoutDateTime DESC',
    );

    List<Workout> workouts = [];
    for (var workoutMap in workoutMaps) {
      final List<Map<String, dynamic>> shotMaps = await db.query(
        'Shot',
        where: 'workoutId = ?',
        whereArgs: [workoutMap['workoutId']],
      );

      List<Shot> shots = shotMaps.map((shotMap) => Shot.fromMap(shotMap)).toList();
      Workout workout = Workout.fromMap(workoutMap, shots);
      workouts.add(workout);
    }

    return workouts;
  }
}
