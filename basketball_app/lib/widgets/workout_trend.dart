import 'package:basketball_app/data/db_helper.dart';
import 'package:basketball_app/widgets/comparisons.dart';
import 'package:basketball_app/widgets/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:basketball_app/models/workout.dart';

// Widget to display workout trends with a graph and comparisons for selected statistics over a date range
class WorkoutTrendWidget extends StatefulWidget {
  const WorkoutTrendWidget({super.key});

  @override
  State<WorkoutTrendWidget> createState() => _WorkoutTrendWidgetState();
}

class _WorkoutTrendWidgetState extends State<WorkoutTrendWidget> {
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _selectedStatistic;
  final List<String> _statistics = [
    "Accuracy",
    "Release height",
    "Release time",
    "Entry Angle",
    "Shot Depth",
    "Shot Position"
  ];
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  var graphVals = [];
  List<Workout> comparisons = [];
  DateTime? comparisonToDate;
  DateTime? comparisonFromDate;

  // Select the start date for the trend analysis
  void _selectFromDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: _toDate ?? DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _fromDate) {
      setState(() {
        _fromDate = pickedDate;
      });
    }
  }

  // Select the end date for the trend analysis
  void _selectToDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _toDate ?? DateTime.now(),
      firstDate: _fromDate ?? DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _toDate) {
      setState(() {
        _toDate = pickedDate;
      });
    }
  }

  // Show the graph for the selected date range and statistic
  void _showGraph() async {
    if (_fromDate != null && _toDate != null && _selectedStatistic != null) {
      // Fetch workouts within the selected date range
      List<Workout> filteredWorkouts =
          await DBHelper().getWorkoutsInDateRange(_fromDate!, _toDate!);
      setState(() {
        comparisons = filteredWorkouts;
        comparisonFromDate = _fromDate;
        comparisonToDate = _toDate;
      });

      // Map selected statistic to corresponding data for the graph
      var valsToGraph = [];
      if (_selectedStatistic == 'Release height') {
        valsToGraph = filteredWorkouts.map((e) {
          var val = e.releaseHeightsMean;
          if (val == '-') {
            return 0;
          }
          return [double.parse(val), e.workoutDateTime];
        }).toList();
      } else if (_selectedStatistic == 'Entry Angle') {
        valsToGraph = filteredWorkouts.map((e) {
          var val = e.entryAnglesMean;
          if (val == '-') {
            return 0;
          }
          return [double.parse(val), e.workoutDateTime];
        }).toList();
      } else if (_selectedStatistic == 'Shot Depth') {
        valsToGraph = filteredWorkouts.map((e) {
          var val = e.shotDepthsMean;
          if (val == '-') {
            return 0;
          }
          return [double.parse(val), e.workoutDateTime];
        }).toList();
      } else if (_selectedStatistic == 'Shot Position') {
        valsToGraph = filteredWorkouts.map((e) {
          var val = e.shotPositionsMean;
          if (val == '-') {
            return 0;
          }
          return [double.parse(val), e.workoutDateTime];
        }).toList();
      } else if (_selectedStatistic == 'Release time') {
        valsToGraph = filteredWorkouts.map((e) {
          var val = e.releaseTimesMean;
          if (val == '-') {
            return 0;
          }
          return [double.parse(val), e.workoutDateTime];
        }).toList();
      } else if (_selectedStatistic == 'Accuracy') {
        valsToGraph = filteredWorkouts.map((e) {
          var val = e.accuracy;
          if (val == '-') {
            return 0;
          }
          return [val, e.workoutDateTime];
        }).toList();
      }

      valsToGraph.removeWhere((element) => element == 0);

      if (valsToGraph.isEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('No data found for the selected date range'),
            );
          },
        );
        return;
      } else {
        setState(() {
          graphVals = valsToGraph;
        });
      }
    }
  }

  // Clear selected date range, statistic, and graph data
  void _clear() {
    setState(() {
      _fromDate = null;
      _toDate = null;
      _selectedStatistic = null;
      graphVals = [];
      comparisons = [];
      comparisonFromDate = null;
      comparisonToDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Date selection row
        Row(
          children: [
            const Text('From:'),
            TextButton(
              onPressed: _selectFromDate,
              child: Text(_fromDate == null
                  ? 'Select Date'
                  : _dateFormat.format(_fromDate!)),
            ),
            const Text('To:'),
            TextButton(
              onPressed: _selectToDate,
              child: Text(_toDate == null
                  ? 'Select Date'
                  : _dateFormat.format(_toDate!)),
            ),
          ],
        ),
        // Statistic selection dropdown
        DropdownButton<String>(
          hint: const Text('Select Statistic'),
          value: _selectedStatistic,
          onChanged: (String? newValue) {
            setState(() {
              _selectedStatistic = newValue;
            });
          },
          items: _statistics.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        // Action buttons for displaying graph or clearing selections
        Row(
          children: [
            ElevatedButton(
              onPressed: _showGraph,
              child: const Text('GO'),
            ),
            ElevatedButton(
              onPressed: _clear,
              child: const Text('Clear'),
            ),
          ],
        ),
        // Display the line chart
        Container(
          height: 200,
          color: Colors.grey[300],
          child: Center(
            child: LineChartWidget(data: graphVals),
          ),
        ),
        const SizedBox(height: 15),
        // Display comparison data
        Container(
          color: Colors.grey[300],
          child: Center(
            child: Comparisons(
              workouts: comparisons.where((workout) {
                return workout.meanValues[0] != -1;
              }).toList(),
              fromDate: comparisonFromDate,
              toDate: comparisonToDate,
            ),
          ),
        ),
      ],
    );
  }
}
