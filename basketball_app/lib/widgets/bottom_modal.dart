import 'package:basketball_app/models/workout.dart';
import 'package:basketball_app/screens/camera_screen.dart';
import 'package:basketball_app/screens/manual_screen.dart';
import 'package:flutter/material.dart';

// BottomModal widget provides a bottom sheet with options for adding a workout, either manually or using the camera.
class BottomModal extends StatelessWidget {
  const BottomModal({super.key, required this.onSave}); 

  // Callback function triggered when a workout is saved.
  final void Function(Workout workout) onSave;

  // Function to handle navigation to the appropriate screen based on user selection.
  void _navigateToScreen(BuildContext context, String screen) {
    Navigator.pop(context); // Close the bottom sheet before navigation.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        if (screen == 'manual') {
          return ManualScreen(onSave: onSave);
        } else {
          return CameraScreen(onSave: onSave);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),  
      child: Column(
        mainAxisSize: MainAxisSize.min,  // Adjusts the modal to fit the content.
        children: [
          // Option to add workout manually.
          ListTile(
            leading: const Icon(Icons.edit),  
            title: const Text('Manual'),
            onTap: () => _navigateToScreen(context, 'manual'),  
          ),
          // Option to add workout using the camera.
          ListTile(
            leading: const Icon(Icons.camera_alt),  
            title: const Text('From Camera'),
            onTap: () => _navigateToScreen(context, 'camera'), 
          ),
        ],
      ),
    );
  }
}
