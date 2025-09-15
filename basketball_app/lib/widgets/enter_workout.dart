import 'package:basketball_app/models/workout.dart';
import 'package:basketball_app/widgets/shot_editor.dart';
import 'package:flutter/material.dart';
import 'package:basketball_app/models/shot.dart';
import 'package:intl/intl.dart';

// Screen for entering or editing workout details
class EnterWorkoutScreen extends StatefulWidget {
  const EnterWorkoutScreen({super.key, required this.onSave, this.workout});

  final void Function(Workout workout) onSave; // Callback to save the workout
  final Workout? workout; // Existing workout, if editing

  @override
  State<EnterWorkoutScreen> createState() => _EnterWorkoutScreenState();
}

class _EnterWorkoutScreenState extends State<EnterWorkoutScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  // Controllers for text input fields
  final TextEditingController _workoutDateController = TextEditingController();
  final TextEditingController _workoutTimeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _totalShotsController = TextEditingController();
  final TextEditingController _totalShotsMadeController =
      TextEditingController();

  bool _useIndividualShots =
      false; // Flag to toggle between individual shots and total stats
  final List<Shot> _shots = []; // List to store individual shots

  @override
  void initState() {
    super.initState();
    // If editing, pre-fill form fields with existing workout data
    if (widget.workout != null) {
      final Workout workout = widget.workout!;
      _workoutDateController.text =
          DateFormat('yyyy-MM-dd').format(workout.workoutDateTime);
      _workoutTimeController.text =
          DateFormat('HH:mm').format(workout.workoutDateTime);
      _durationController.text = workout.duration.inMinutes.toString();
      _notesController.text = workout.notes;

      // If workout has individual shots, populate shot list and switch view to individual shots mode
      if (workout.shots != null) {
        _useIndividualShots = true;
        _shots.addAll(workout.shots!);
      } else {
        _totalShotsController.text = workout.totalShots.toString();
        _totalShotsMadeController.text = workout.totalShotsMade.toString();
      }
    }
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _workoutDateController.dispose();
    _workoutTimeController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    _totalShotsController.dispose();
    _totalShotsMadeController.dispose();
    super.dispose();
  }

  // Validators for form fields, ensuring correct data entry
  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) return 'Date is required';
    final RegExp dateRegex =
        RegExp(r'^\d{4}-\d{2}-\d{2}$'); // Matches yyyy-MM-dd format
    if (!dateRegex.hasMatch(value)) return 'Invalid date format';
    try {
      final DateTime date = DateFormat('yyyy-MM-dd').parseStrict(value);
      if (date.isAfter(DateTime.now())) return 'Date must not be in the future';
    } catch (e) {
      return 'Invalid date';
    }
    return null;
  }

  String? _validateTime(String? value) {
    if (value == null || value.isEmpty) return 'Time is required';
    final RegExp timeRegex =
        RegExp(r'^\d{2}:\d{2}\s?$');
    if (!timeRegex.hasMatch(value)) return 'Invalid time format';
    try {
      final List<String> parts = value.split(":");
      int hour = int.parse(parts[0]);
      final int minute = int.parse(parts[1]);
      if (hour < 1 || hour > 23 || minute < 0 || minute > 59) {
        return 'Invalid time';
      }
    } catch (e) {
      return 'Invalid time';
    }
    return null;
  }

  String? _validateInteger(String? value) {
    if (value == null || value.isEmpty) return 'This field is required';
    final RegExp intRegex =
        RegExp(r'^-?\d+$'); // Matches integers (positive and negative)
    if (!intRegex.hasMatch(value)) return 'Must be an integer';
    return null;
  }

  String? _validateShotsTaken(String? value) {
    final error = _validateInteger(value);
    if (error != null) return error;
    if (int.parse(value!) < 0) return 'Must be greater than or equal to 0';
    return null;
  }

  String? _validateShotsMade(String? value) {
    final error = _validateInteger(value);
    if (error != null) return error;
    final int numberMade = int.parse(value!);
    final int numberTaken = int.tryParse(_totalShotsController.text) ?? 0;
    if (numberMade < 0) return 'Must be greater than or equal to 0';
    if (numberMade > numberTaken) return 'Cannot be greater than shots taken';
    return null;
  }

  String? _validateNotes(String? value) {
    if (value != null && value.length > 1000)
      return 'Must be less than 1000 characters';
    return null;
  }

  // Add a new empty shot to the list
  void _addShot() {
    setState(() {
      _shots.add(
        Shot(
          shotMade: false,
          releaseHeight: 0.0,
          releaseTime: 0.0,
          entryAngle: 0.0,
          shotDepth: 0.0,
          shotPosition: 0.0,
        ),
      );
    });
  }

  // Remove a specific shot from the list
  void _removeIndividualShot(int index) {
    setState(() {
      _shots.removeAt(index);
    });
  }

  // Select date for workout using a date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _workoutDateController.text.isEmpty
          ? DateTime.now()
          : DateFormat('yyyy-MM-dd').parse(_workoutDateController.text),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _workoutDateController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  // Select time for workout using a time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialEntryMode: TimePickerEntryMode.inputOnly,
    initialTime: TimeOfDay.now(),
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    },
  );
    if (pickedTime != null) {
      setState(() {
        _workoutTimeController.text = MaterialLocalizations.of(context).formatTimeOfDay(pickedTime, alwaysUse24HourFormat: true);
      });
    }
  }

  // Open the shot editor to edit a specific shot in the list
  void _editShot(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Shot'),
          content: ShotEditor(
            shot: _shots[index],
            onSave: (updatedShot) {
              setState(() {
                _shots[index] = updatedShot;
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Date picker field
              TextFormField(
                controller: _workoutDateController,
                decoration: const InputDecoration(
                  labelText: 'Workout Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: _validateDate,
              ),
              // Time picker field
              TextFormField(
                controller: _workoutTimeController,
                decoration: const InputDecoration(
                  labelText: 'Workout Time',
                  suffixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                onTap: () => _selectTime(context),
                validator: _validateTime,
              ),
              // Duration field
              TextFormField(
                controller: _durationController,
                decoration:
                    const InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                validator: _validateInteger,
              ),
              // Notes field
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: null,
                validator: _validateNotes,
              ),
              // Toggle switch for using individual shots or total stats
              SwitchListTile(
                title: const Text('Add individual shots'),
                value: _useIndividualShots,
                onChanged: (bool value) {
                  setState(() {
                    _useIndividualShots = value;
                  });
                },
              ),
              // Display fields for total shots if not using individual shots
              if (!_useIndividualShots)
                Column(
                  children: [
                    TextFormField(
                      controller: _totalShotsController,
                      decoration: const InputDecoration(
                          labelText: 'Number of Shots Taken'),
                      keyboardType: TextInputType.number,
                      validator: _validateShotsTaken,
                    ),
                    TextFormField(
                      controller: _totalShotsMadeController,
                      decoration: const InputDecoration(
                          labelText: 'Number of Shots Made'),
                      keyboardType: TextInputType.number,
                      validator: _validateShotsMade,
                    ),
                  ],
                )
              else
                // Display list of individual shots with options to add, edit, or delete shots
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: _addShot,
                      child: const Text('Add Shot'),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _shots.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('Shot ${index + 1}'),
                          onTap: () => _editShot(index),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _removeIndividualShot(index),
                          ),
                        );
                      },
                    ),
                    TextFormField(
                      enabled: false,
                      validator: (value) {
                        if (_shots.isEmpty)
                          return 'At least one shot is required';
                        return null;
                      },
                    ),
                  ],
                ),
              // Save workout button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Workout workout;
                    // Save workout with individual shots or total stats based on user selection
                    if (_useIndividualShots) {
                      workout = Workout(
                        workoutDateTime: DateFormat('yyyy-MM-dd HH:mm').parse(
                            "${_workoutDateController.text} ${_workoutTimeController.text}"),
                        duration: Duration(
                            minutes: int.parse(_durationController.text)),
                        notes: _notesController.text,
                        shots: _shots,
                      );
                    } else {
                      workout = Workout(
                        workoutDateTime: DateFormat('yyyy-MM-dd HH:mm').parse(
                            "${_workoutDateController.text} ${_workoutTimeController.text}"),
                        duration: Duration(
                            minutes: int.parse(_durationController.text)),
                        notes: _notesController.text,
                        totalShots: int.parse(_totalShotsController.text),
                        totalShotsMade:
                            int.parse(_totalShotsMadeController.text),
                      );
                    }
                    //Make sure to write the workout ID if editing an existing workout
                    if (widget.workout != null) {
                      workout.workoutId = widget.workout!.workoutId;
                    }
                    widget.onSave(workout);
                    Navigator.pop(context); // Close the screen after saving
                  }
                },
                child: const Text('Save Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
