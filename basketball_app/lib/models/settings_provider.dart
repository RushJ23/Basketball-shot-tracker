import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SettingsProvider with ChangeNotifier {
  // Default values for settings
  bool _showReleaseHeightMean = true;
  bool _showReleaseTimeMean = true;
  bool _showShotDepthMean = true;
  bool _showShotPositionMean = true;
  bool _showEntryAngleMean = true;
  bool _useAudio = true;
  double ballSize = 9.5;
  double rimHeight = 120;
  double rimSize = 18;
  String _shareMessage = 'Check out this basketball app!';

  SettingsProvider() {
    _loadSettings();
  }

  // Getters for accessing settings
  bool get showReleaseHeightMean => _showReleaseHeightMean;
  bool get showReleaseTimeMean => _showReleaseTimeMean;
  bool get showShotDepthMean => _showShotDepthMean;
  bool get showShotPositionMean => _showShotPositionMean;
  bool get showEntryAngleMean => _showEntryAngleMean;
  bool get useAudio => _useAudio;
  double get getBallSize => ballSize;
  double get getRimHeight => rimHeight;
  double get getRimSize => rimSize;
  String get shareMessage => _shareMessage;

  // Toggle methods for settings, which also save to file and notify listeners
  void toggleReleaseHeightFormat() {
    _showReleaseHeightMean = !_showReleaseHeightMean;
    _saveSettings();
    notifyListeners();
  }

  void toggleReleaseTimeFormat() {
    _showReleaseTimeMean = !_showReleaseTimeMean;
    _saveSettings();
    notifyListeners();
  }

  void toggleShotDepthFormat() {
    _showShotDepthMean = !_showShotDepthMean;
    _saveSettings();
    notifyListeners();
  }

  void toggleShotPositionFormat() {
    _showShotPositionMean = !_showShotPositionMean;
    _saveSettings();
    notifyListeners();
  }

  void toggleEntryAngleFormat() {
    _showEntryAngleMean = !_showEntryAngleMean;
    _saveSettings();
    notifyListeners();
  }

  void toggleUseAudio() {
    _useAudio = !_useAudio;
    _saveSettings();
    notifyListeners();
  }

  // Update methods for numeric settings
  void updateBallSize(double size) {
    ballSize = size;
    _saveSettings();
    notifyListeners();
  }

  void updateRimHeight(double height) {
    rimHeight = height;
    _saveSettings();
    notifyListeners();
  }

  void updateRimSize(double size) {
    rimSize = size;
    _saveSettings();
    notifyListeners();
  }

  void updateShareMessage(String message) {
    _shareMessage = message;
    _saveSettings();
    notifyListeners();
  }

  // File path for storing settings
  Future<String> _getSettingsFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/settings.json';
  }

  // Save settings to a JSON file
  Future<void> _saveSettings() async {
    final filePath = await _getSettingsFilePath();
    final file = File(filePath);
    final settings = {
      'showReleaseHeightMean': _showReleaseHeightMean,
      'showReleaseTimeMean': _showReleaseTimeMean,
      'showShotDepthMean': _showShotDepthMean,
      'showShotPositionMean': _showShotPositionMean,
      'showEntryAngleMean': _showEntryAngleMean,
      'useAudio': _useAudio,
      'ballSize': ballSize,
      'rimHeight': rimHeight,
      'rimSize': rimSize,
      'shareMessage': _shareMessage,
    };
    await file.writeAsString(jsonEncode(settings));
  }

  // Load settings from a JSON file
  Future<void> _loadSettings() async {
    try {
      final filePath = await _getSettingsFilePath();
      final file = File(filePath);

      if (await file.exists()) {
        final settingsJson = await file.readAsString();
        final settings = jsonDecode(settingsJson);

        _showReleaseHeightMean = settings['showReleaseHeightMean'] ?? true;
        _showReleaseTimeMean = settings['showReleaseTimeMean'] ?? true;
        _showShotDepthMean = settings['showShotDepthMean'] ?? true;
        _showShotPositionMean = settings['showShotPositionMean'] ?? true;
        _showEntryAngleMean = settings['showEntryAngleMean'] ?? true;
        _useAudio = settings['useAudio'] ?? true;
        ballSize = (settings['ballSize'] ?? 9.5).toDouble();
        rimHeight = (settings['rimHeight'] ?? 120.0).toDouble();
        rimSize = (settings['rimSize'] ?? 18.0).toDouble();
        _shareMessage = settings['shareMessage'] ?? 'Check out this basketball app!';
        notifyListeners();
      }
    } catch (e) {
      // Handle errors if settings fail to load
      print("Error loading settings: $e");
    }
  }
}
