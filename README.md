# Basketball Shot Tracker

Basketball Shot Tracker pairs a Python-based computer-vision service with a cross-platform Flutter application to help athletes log workouts, capture shooting metrics, and review trends over time. The mobile app can store sessions manually or stream camera footage to the detection backend, which uses a YOLO model to measure release angle, depth, and shot accuracy for each attempt.

## Key Features

- **Automated shot detection** – Streams camera frames to a YOLO-based detector that tracks the ball, hoop, and player motion to identify attempts, makes, and shooting mechanics in real time.【F:backend/detection.py†L1-L136】【F:backend/utils.py†L5-L262】
- **Manual workout logging** – Enter or edit workout sessions, capture per-shot metrics, or record aggregate totals when detailed stats are unavailable.【F:basketball_app/lib/widgets/enter_workout.dart†L7-L360】
- **Workout timeline** – Review past sessions in the home tab, drill into details, and manage entries (edit/delete).【F:basketball_app/lib/screens/home_screen.dart†L13-L84】【F:basketball_app/lib/widgets/workout_item.dart†L8-L135】【F:basketball_app/lib/screens/workout_details.dart†L1-L240】
- **Trend analysis** – Filter workouts by date range, chart key statistics, and compare improvements between two periods.【F:basketball_app/lib/widgets/workout_trend.dart†L8-L236】【F:basketball_app/lib/widgets/line_chart.dart†L1-L52】【F:basketball_app/lib/widgets/comparisons.dart†L1-L144】
- **Sharing tools** – Build templated recap messages and share recent performance with teammates or coaches via copy/share dialogs.【F:basketball_app/lib/widgets/share_message.dart†L5-L111】【F:basketball_app/lib/widgets/share_popup.dart†L10-L175】
- **Persistent preferences** – Toggle how statistics are summarized, manage shot-feedback settings, and configure rim/ball measurements; preferences persist locally on device.【F:basketball_app/lib/models/settings_provider.dart†L6-L148】【F:basketball_app/lib/screens/settings_screen.dart†L1-L120】

## Project Structure

```
backend/           # YOLO-based websocket service for frame analysis
basketball_app/    # Flutter application (Android/iOS/macOS/web/windows/linux)
```

The Flutter app uses the light/dark themes defined in `lib/theme_data.dart` and launches three primary tabs (Workouts, Stats, Settings) from `lib/main.dart`.【F:basketball_app/lib/theme_data.dart†L3-L121】【F:basketball_app/lib/main.dart†L1-L127】 Local workout data is stored in a SQLite database via `lib/data/db_helper.dart` and associated models under `lib/models/`.【F:basketball_app/lib/data/db_helper.dart†L7-L174】

## Backend Service

### Requirements
- Python 3.9+
- [Ultralytics YOLO](https://docs.ultralytics.com), OpenCV, NumPy, websockets
- GPU acceleration is optional but recommended for higher frame rates

### Setup

```bash
cd backend
python -m venv .venv
source .venv/bin/activate           # Windows: .venv\Scripts\activate
pip install ultralytics opencv-python numpy websockets
```

Place the trained YOLO weights at `backend/best.pt`; replace the provided file with your custom model if needed.【F:backend/server.py†L42-L47】

### Running the server

```bash
cd backend
python server.py
```

`server.py` launches an asyncio websocket server on port 3324, decodes incoming base64 frames, forwards them to `ShotDetector`, and returns updated state and per-shot feedback to the client.【F:backend/server.py†L1-L51】 The detector cleans bounding boxes, tracks upward/downward motion, estimates 3D entry metrics, and generates user feedback for each shot.【F:backend/detection.py†L13-L120】【F:backend/utils.py†L63-L262】

### Networking tips
- Ensure the machine running the backend is reachable from the mobile device over the network.
- Update the websocket URL in `lib/screens/camera_analysis.dart` to match your host/IP (default `ws://192.168.50.23:3324`).【F:basketball_app/lib/screens/camera_analysis.dart†L193-L249】
- Consider securing the transport (e.g., `wss://`) and adding authentication before deploying beyond local networks.

## Flutter Application

### Requirements
- Flutter 3.4+ with Dart 3.x
- Device or emulator with camera access for live tracking
- Platform-specific toolchains (Android Studio, Xcode, etc.) as needed

### Getting started

```bash
cd basketball_app
flutter pub get
flutter run
```

The app locks orientation to portrait and wires the home, stats, and settings flows through a `ChangeNotifierProvider` wrapping `SettingsProvider` in `main.dart`.【F:basketball_app/lib/main.dart†L11-L125】 Themes adapt to light/dark mode as defined in `theme_data.dart`.【F:basketball_app/lib/theme_data.dart†L13-L121】

### Managing workouts
- Tap the **+** button on the Workouts tab to add sessions manually or launch camera capture via the bottom sheet options.【F:basketball_app/lib/screens/home_screen.dart†L28-L82】【F:basketball_app/lib/widgets/bottom_modal.dart†L6-L50】
- Manual entry supports detailed shot editing, aggregate totals, and validation for dates, durations, and stat consistency.【F:basketball_app/lib/widgets/enter_workout.dart†L18-L360】
- Selecting a workout opens a detailed view with statistics, shot lists, edit/delete actions, and a shot-by-shot viewer that plots ball entry relative to the rim.【F:basketball_app/lib/screens/workout_details.dart†L18-L240】【F:basketball_app/lib/widgets/shots_viewer.dart†L5-L143】

### Live camera analysis
- The Camera instructions screen explains how to position the device before starting analysis.【F:basketball_app/lib/screens/camera_screen.dart†L5-L52】
- `CameraAnalysisPreview` requests permissions, streams frames from the camera, and pushes payloads to the websocket server; responses update the in-memory shot list that is later saved as a workout.【F:basketball_app/lib/screens/camera_analysis.dart†L73-L223】
- The helper methods include a JPEG compressor should you decide to re-enable payload transmission for better bandwidth usage.【F:basketball_app/lib/screens/camera_analysis.dart†L252-L297】

### Stats, trends, and sharing
- Use the Stats tab to choose a date range and statistic; the app renders a line chart and comparison summary to highlight progress.【F:basketball_app/lib/widgets/workout_trend.dart†L16-L236】【F:basketball_app/lib/widgets/line_chart.dart†L1-L52】
- Configure share message templates with placeholders, then generate a populated message (copy/share) using the Share button in Settings.【F:basketball_app/lib/widgets/share_message.dart†L11-L111】【F:basketball_app/lib/widgets/share_popup.dart†L14-L175】 The popup gathers the last 31 days of workouts through `DBHelper` before replacing tokens with actual values.【F:basketball_app/lib/widgets/share_popup.dart†L94-L109】
- Settings also expose toggles for summarizing stats as means vs. quartiles, enabling audio feedback, and storing rim/ball measurements used by the detector.【F:basketball_app/lib/models/settings_provider.dart†L6-L118】【F:basketball_app/lib/screens/settings_screen.dart†L17-L120】 These preferences persist in a JSON file within the app documents directory.【F:basketball_app/lib/models/settings_provider.dart†L97-L148】

### Local storage
Workouts and shots are stored in `sqflite` tables (`Workout`, `Shot`) and linked by foreign key. Helper methods fetch sessions, update records, and populate dummy data when desired.【F:basketball_app/lib/data/db_helper.dart†L24-L174】 The models in `lib/models/` provide serialization helpers and derived metrics (accuracy, quantiles, etc.).【F:basketball_app/lib/models/workout.dart†L1-L123】

## Customizing Detection Feedback

`ShotDetector` combines YOLO detections with heuristics (ball/hoop cleaning, trajectory fitting, movement thresholds) to determine makes, release angles, shot depth, and lateral position before composing a feedback string.【F:backend/detection.py†L35-L120】【F:backend/utils.py†L81-L262】 Adjust these heuristics to fine-tune sensitivity for your setup (camera placement, rim dimensions, etc.). The player, rim, and ball size inputs from Settings help convert pixel measurements into court-referenced distances.【F:basketball_app/lib/models/settings_provider.dart†L73-L118】【F:basketball_app/lib/screens/settings_screen.dart†L81-L120】

## Development Tips

- Use `flutter pub run build_runner` or Flutter DevTools as needed for additional tooling; the project currently relies on manual model classes.
- Keep backend and mobile timestamps synchronized if you plan to merge session data from multiple sources.
- When deploying, consider packaging the backend as a service (systemd, Docker) and proxying the websocket through HTTPS.

## License

No license file is provided; consult the project maintainers before distributing builds or trained models.
