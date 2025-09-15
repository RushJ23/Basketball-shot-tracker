import 'package:basketball_app/models/workout.dart';
import 'package:basketball_app/screens/camera_analysis.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key, required this.onSave});
  final void Function(Workout workout) onSave;

  //Page to show instructions on how camera operating works. 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        title: Text('Camera Screen',
            style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'To track your shooting, please set up the camera as follows:',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              '1. Place the camera on the baseline at the sideline of the court.\n'
              '2. Ensure that the rim, ball, and player are in view.\n'
              '3. Make sure that camera permissions are allowed.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraAnalysis(onSave: onSave)),
                );
              },
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}
