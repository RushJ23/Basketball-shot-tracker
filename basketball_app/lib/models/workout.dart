import 'package:basketball_app/models/shot.dart';

class Workout {
  int? workoutId;
  final DateTime workoutDateTime;
  final Duration duration;
  final String notes;
  List<Shot>? shots;
  final int? totalShots;
  final int? totalShotsMade;

  // Constructor with validation for totalShots and totalShotsMade if shots are null
  Workout({
    this.workoutId,
    required this.workoutDateTime,
    required this.duration,
    required this.notes,
    this.shots,
    this.totalShots,
    this.totalShotsMade,
  }) {
    if (shots == null) {
      if (totalShots == null || totalShotsMade == null) {
        throw ArgumentError(
            'totalShots and totalShotsMade must be set if shots is null');
      }
    } else if (shots!.isEmpty) {
      if (totalShots == null || totalShotsMade == null) {
        throw ArgumentError(
            'totalShots and totalShotsMade must be set if shots is null');
      }
      shots = null;
    }
  }

  // Factory constructor to create Workout from a map (e.g., from a database)
  factory Workout.fromMap(Map<String, dynamic> map, List<Shot>? shots) {
    return Workout(
      workoutId: map['workoutId'],
      workoutDateTime: DateTime.parse(map['workoutDateTime']),
      duration: Duration(minutes: map['duration']),
      notes: map['notes'],
      shots: shots,
      totalShots: map['totalShots'],
      totalShotsMade: map['totalShotsMade'],
    );
  }

  // Total count of shots in the workout
  int get totalShotsCount => shots?.length ?? totalShots!;

  // Total count of made shots in the workout
  int get totalShotsMadeCount => shots?.where((shot) => shot.shotMade).length ?? totalShotsMade!;

  // Calculate accuracy as a percentage
  double get accuracy => totalShotsCount > 0 ? (totalShotsMadeCount / totalShotsCount) * 100 : 0;

  // Helper methods for calculating mean and quantiles
  double _mean(List<double> values) => values.isNotEmpty ? values.reduce((a, b) => a + b) / values.length : 0.0;

  double _quantile(List<num> values, double quantile) {
    if (values.isEmpty) return 0.0;

    values.sort();
    int n = values.length;
    double pos = quantile * (n + 1);
    if (pos < 1) return values.first.toDouble();
    if (pos >= n) return values.last.toDouble();

    int lowerIndex = pos.floor() - 1;
    int upperIndex = pos.ceil() - 1;

    return values[lowerIndex] +
        (values[upperIndex] - values[lowerIndex]) * (pos - lowerIndex - 1);
  }

  // Extract shot values for calculations
  List<double> _extractShotValues(Function(Shot) extractor) {
    return shots?.map(extractor).toList().cast<double>() ?? [];
  }

  // Convert Workout object to map for database storage
  Map<String, dynamic> toMap() {
    return {
      'workoutId': workoutId,
      'workoutDateTime': workoutDateTime.toIso8601String(),
      'duration': duration.inMinutes,
      'notes': notes,
      'totalShots': totalShots,
      'totalShotsMade': totalShotsMade,
    };
  }

  // Getters for mean and quartile values for each shot attribute
  String get releaseHeightsMean => shots != null
      ? _mean(_extractShotValues((shot) => shot.releaseHeight)).toStringAsFixed(2)
      : '-';
  String get releaseHeightsQ1 => shots != null
      ? _quantile(_extractShotValues((shot) => shot.releaseHeight), 0.25).toStringAsFixed(2)
      : '-';
  String get releaseHeightsQ3 => shots != null
      ? _quantile(_extractShotValues((shot) => shot.releaseHeight), 0.75).toStringAsFixed(2)
      : '-';

  String get releaseTimesMean => shots != null
      ? _mean(_extractShotValues((shot) => shot.releaseTime)).toStringAsFixed(2)
      : '-';
  String get releaseTimesQ1 => shots != null
      ? _quantile(_extractShotValues((shot) => shot.releaseTime), 0.25).toStringAsFixed(2)
      : '-';
  String get releaseTimesQ3 => shots != null
      ? _quantile(_extractShotValues((shot) => shot.releaseTime), 0.75).toStringAsFixed(2)
      : '-';

  String get entryAnglesMean => shots != null
      ? _mean(_extractShotValues((shot) => shot.entryAngle)).toStringAsFixed(2)
      : '-';
  String get entryAnglesQ1 => shots != null
      ? _quantile(_extractShotValues((shot) => shot.entryAngle), 0.25).toStringAsFixed(2)
      : '-';
  String get entryAnglesQ3 => shots != null
      ? _quantile(_extractShotValues((shot) => shot.entryAngle), 0.75).toStringAsFixed(2)
      : '-';

  String get shotDepthsMean => shots != null
      ? _mean(_extractShotValues((shot) => shot.shotDepth)).toStringAsFixed(2)
      : '-';
  String get shotDepthsQ1 => shots != null
      ? _quantile(_extractShotValues((shot) => shot.shotDepth), 0.25).toStringAsFixed(2)
      : '-';
  String get shotDepthsQ3 => shots != null
      ? _quantile(_extractShotValues((shot) => shot.shotDepth), 0.75).toStringAsFixed(2)
      : '-';

  String get shotPositionsMean => shots != null
      ? _mean(_extractShotValues((shot) => shot.shotPosition)).toStringAsFixed(2)
      : '-';
  String get shotPositionsQ1 => shots != null
      ? _quantile(_extractShotValues((shot) => shot.shotPosition), 0.25).toStringAsFixed(2)
      : '-';
  String get shotPositionsQ3 => shots != null
      ? _quantile(_extractShotValues((shot) => shot.shotPosition), 0.75).toStringAsFixed(2)
      : '-';
  
  // Get mean values of all key attributes for graphing and analysis
  List<double> get meanValues {
    if (shots == null) {
      return [-1];
    }
    return [
      double.parse(releaseHeightsMean),
      double.parse(releaseTimesMean),
      double.parse(entryAnglesMean),
      double.parse(shotDepthsMean),
      double.parse(shotPositionsMean),
      accuracy
    ];
  }

  // Print detailed workout information for debugging
  void printWorkout() {
    print('Workout ID: $workoutId');
    print('Workout Date Time: $workoutDateTime');
    print('Duration: $duration');
    print('Notes: $notes');
    print('Total Shots: $totalShots');
    print('Total Shots Made: $totalShotsMade');
    if (shots == null) {
      print('Shots: null');
    } else {
      print('Shots:');
      for (var shot in shots!) {
        shot.printShot();
      }
    }
  }
}
