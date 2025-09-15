// Import necessary packages and models for the app, such as settings provider, themes, camera, and flutter dependencies.
import 'package:basketball_app/models/settings_provider.dart';
import 'package:basketball_app/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/settings_screen.dart';

// Main function - initializes the app and sets up required settings like orientation.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock the device orientation to portrait mode.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Use Provider to manage app settings state globally.
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      child: WorkoutApp(),
    ),
  );
}

// Main widget for the app, receives the list of cameras as a parameter.
class WorkoutApp extends StatelessWidget {
  const WorkoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set up MaterialApp with themes, title, and initial screen.
    return MaterialApp(
      title: 'Workout App',
      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: ThemeMode.system,
      home: const MainScreen(),
    );
  }
}

// Main screen widget with a bottom navigation bar to switch between sections.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;  // Tracks the selected tab

  // Titles for the app bar based on the selected screen.
  final List<String> _appBarTitles = <String>[
    'Workouts',
    'Stats',
    'Settings',
  ];

  // Icons for the app bar, matching each section.
  final List<IconData> _appBarIcons = <IconData>[
    Icons.fitness_center,
    Icons.assessment_outlined,
    Icons.settings,
  ];

  // Method to update the selected tab.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Widget options for each tab, passing cameras to HomeScreen for capturing.
    final List<Widget> _widgetOptions = <Widget>[
      const HomeScreen(),
      const StatsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        // Display the title and icon for the current tab.
        title: Text(
          _appBarTitles[_selectedIndex],
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              _appBarIcons[_selectedIndex],
              color: Theme.of(context).iconTheme.color,
              size: 48,
            ),
          ),
        ],
      ),
      // Display the currently selected screen content.
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,  // Handle tab changes
      ),
    );
  }
}
