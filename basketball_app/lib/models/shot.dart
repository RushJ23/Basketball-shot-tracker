class Shot {
  int? shotId;
  final bool shotMade;
  final double releaseHeight;
  final double releaseTime;
  final double entryAngle;
  final double shotDepth;
  final double shotPosition;

  // Constructor for the Shot class
  Shot({
    this.shotId,
    required this.shotMade,
    required this.releaseHeight,
    required this.releaseTime,
    required this.entryAngle,
    required this.shotDepth,
    required this.shotPosition,
  });
  
  // Factory method to create a Shot object from a map (e.g., from a database)
  factory Shot.fromMap(Map<String, dynamic> map) {
    return Shot(
      shotId: map['shotId'],
      shotMade: map['shotMade'] == 1,
      releaseHeight: map['releaseHeight'],
      releaseTime: map['releaseTime'],
      entryAngle: map['entryAngle'],
      shotDepth: map['shotDepth'],
      shotPosition: map['shotPosition'],
    );
  }

  // Converts a Shot object to a map for database storage
  Map<String, dynamic> toMap(int workoutId) {
    return {
      'workoutId': workoutId,
      'shotId': shotId,
      'shotMade': shotMade ? 1 : 0,
      'releaseHeight': releaseHeight,
      'releaseTime': releaseTime,
      'entryAngle': entryAngle,
      'shotDepth': shotDepth,
      'shotPosition': shotPosition,
    };
  }

  // Prints detailed information about the shot for debugging
  void printShot() {
    print('Shot ID: $shotId');
    print('Shot Made: $shotMade');
    print('Release Height: $releaseHeight');
    print('Release Time: $releaseTime');
    print('Entry Angle: $entryAngle');
    print('Shot Depth: $shotDepth');
    print('Shot Position: $shotPosition');
  }
}
