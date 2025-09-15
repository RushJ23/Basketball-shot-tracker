import 'package:flutter/material.dart';
import 'package:basketball_app/models/shot.dart';

// Widget to edit properties of a basketball shot
class ShotEditor extends StatefulWidget {
  final Shot shot;  // The shot data to edit
  final ValueChanged<Shot> onSave;  // Callback to save changes

  const ShotEditor({super.key, required this.shot, required this.onSave});

  @override
  State<ShotEditor> createState() => _ShotEditorState();
}

class _ShotEditorState extends State<ShotEditor> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to manage text input fields
  late bool _made;
  late TextEditingController _releaseHeightController;
  late TextEditingController _releaseTimeController;
  late TextEditingController _entryAngleController;
  late TextEditingController _shotDepthController;
  late TextEditingController _shotPositionController;

  @override
  void initState() {
    super.initState();
    // Initialize form fields with existing shot data
    _made = widget.shot.shotMade;
    _releaseHeightController = TextEditingController(text: widget.shot.releaseHeight.toString());
    _releaseTimeController = TextEditingController(text: widget.shot.releaseTime.toString());
    _entryAngleController = TextEditingController(text: widget.shot.entryAngle.toString());
    _shotDepthController = TextEditingController(text: widget.shot.shotDepth.toString());
    _shotPositionController = TextEditingController(text: widget.shot.shotPosition.toString());
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _releaseHeightController.dispose();
    _releaseTimeController.dispose();
    _entryAngleController.dispose();
    _shotDepthController.dispose();
    _shotPositionController.dispose();
    super.dispose();
  }

  // Validator for checking if the input is a valid double
  String? _validateDouble(String? value) {
    if (value == null || value.isEmpty) {
      return 'Value is required';
    }
    try {
      double.parse(value);
    } catch (e) {
      return 'Invalid number';
    }
    return null;
  }

  // Validator for angle input, ensuring it is between 0 and 90 degrees
  String? _validateAngle(String? value) {
    var error = _validateDouble(value);
    if (error != null) {
      return error;
    }
    try {
      final double angle = double.parse(value!);
      if (angle < 0 || angle > 90) {
        return 'Angle must be between 0 and 90 degrees';
      }
    } catch (e) {
      return 'Invalid number';
    }
    return null;
  }

  // Save the updated shot data and close the editor
  void _saveShot() {
    if (_formKey.currentState!.validate()) {
      final updatedShot = Shot(
        shotId: widget.shot.shotId,
        shotMade: _made,
        releaseHeight: double.parse(_releaseHeightController.text),
        releaseTime: double.parse(_releaseTimeController.text),
        entryAngle: double.parse(_entryAngleController.text),
        shotDepth: double.parse(_shotDepthController.text),
        shotPosition: double.parse(_shotPositionController.text),
      );
      widget.onSave(updatedShot);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Checkbox for marking the shot as made or missed
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Made'),
              Checkbox(
                value: _made,
                onChanged: (checked) {
                  setState(() {
                    _made = checked!;
                  });
                },
              ),
            ],
          ),
          // Input field for release height
          TextFormField(
            controller: _releaseHeightController,
            decoration: const InputDecoration(labelText: 'Release Height (inches)'),
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
            validator: _validateDouble,
          ),
          // Input field for release time
          TextFormField(
            controller: _releaseTimeController,
            decoration: const InputDecoration(labelText: 'Release Time (s)'),
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
            validator: _validateDouble,
          ),
          // Input field for entry angle
          TextFormField(
            controller: _entryAngleController,
            decoration: const InputDecoration(labelText: 'Entry Angle (deg)'),
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
            validator: _validateAngle,
          ),
          // Input field for shot depth
          TextFormField(
            controller: _shotDepthController,
            decoration: const InputDecoration(labelText: 'Shot Depth (")'),
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
            validator: _validateDouble,
          ),
          // Input field for shot position
          TextFormField(
            controller: _shotPositionController,
            decoration: const InputDecoration(labelText: 'Shot Position (")'),
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
            validator: _validateDouble,
          ),
          // Button to save the edited shot data
          ElevatedButton(
            onPressed: _saveShot,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
