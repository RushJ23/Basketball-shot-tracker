import 'package:basketball_app/models/settings_provider.dart';
import 'package:basketball_app/models/shot.dart';
import 'package:basketball_app/models/workout.dart';
import 'package:basketball_app/widgets/enter_workout.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';

// CameraAnalysis widget to display the camera feed and analysis.

class CameraAnalysis extends StatelessWidget {
  CameraAnalysis({super.key, required this.onSave});
  final void Function(Workout workout) onSave;

  final DateTime startTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    List<Shot> shots = [];
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        title:
            Text('Camera Feed', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            onPressed: () {
              // if (shots.isEmpty) {
              //   Navigator.pop(context);
              //   return;
              // }
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EnterWorkoutScreen(
                            onSave: onSave,
                            workout: Workout(
                              workoutDateTime: DateTime.now(),
                              duration: DateTime.now().difference(startTime),
                              notes: "",
                              shots: [Shot(shotMade: true, entryAngle: 16.7, shotDepth: -7.9, shotPosition: 9.2, releaseHeight: 75.3, releaseTime: 0.7), 
                              Shot(shotMade: true, entryAngle: 43.6, shotDepth: -9.7, shotPosition: -6.4, releaseHeight: 70.3, releaseTime: 0.8)],
                            ),
                          )));
            },
            icon: const Icon(Icons.check),
            color: Colors.white,
          )
        ],
      ),
      body: CameraAnalysisPreview(shots: shots),
    );
  }
}

//Widget to handle camera feed and backend server connection. 
class CameraAnalysisPreview extends StatefulWidget {
  const CameraAnalysisPreview({super.key, required this.shots});
  final List<Shot> shots;

  @override
  State<CameraAnalysisPreview> createState() => _CameraAnalysisPreviewState();
}

class _CameraAnalysisPreviewState extends State<CameraAnalysisPreview> {
  //All stats required for processing as well as connection details. 
  CameraController? controller;
  late WebSocketChannel channel;
  List<dynamic> ballPos = [];
  List<dynamic> hoopPos = [];
  bool up = false;
  bool down = false;
  int upFrame = 0;
  int downFrame = 0;
  int makes = 0;
  int attempts = 0;
  dynamic shotTaken = false;
  int frameCount = 0;
  bool isProcessing = false;
  int player = 0;
  List<dynamic> r_time = [
    DateTime(2000, 1, 1).toIso8601String(),
    DateTime(2000, 1, 1).toIso8601String()
  ];

  @override
  void initState() {
    super.initState();
    super.initState();
    initializeCamera();
    initializeWebSocket();
  }

  //Initializes the camera feed checking for permissions.
  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras[0]; // Use front-facing camera

    var permissionStatus = await Permission.camera.request();

    if (permissionStatus.isDenied | permissionStatus.isPermanentlyDenied) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Permission Denied'),
              content: const Text(
                  'You must grant camera permissions to use this feature.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                )
              ],
            );
          });
          return;
    }
    controller = CameraController(
      frontCamera,
      ResolutionPreset.low,
      enableAudio: false,
    );
    await controller!.initialize();
    setState(() {});

    controller!.startImageStream((CameraImage image) {
      if (!isProcessing) {
        isProcessing = true;
        sendImage(image);
      }
    });
  }

  //Sends the image to the backend server for processing. Only sends the image if the previous image has been processed to prevent overloading the server and errors with ordering of responses.
  void sendImage(CameraImage image) async {
    try {
      // final jpegBytes = compressImage(image);
      // final compressedImageBase64 = base64Encode(jpegBytes);
      // final payload = {
      //   'image': compressedImageBase64,
      //   'ball_pos': ballPos,
      //   'hoop_pos': hoopPos,
      //   'up': up,
      //   'down': down,
      //   'up_frame': upFrame,
      //   'down_frame': downFrame,
      //   'makes': makes,
      //   'attempts': attempts,
      //   "frame_count": frameCount,
      //   "AO": [0, context.read<SettingsProvider>().rimHeight, 300],
      //   "s1": context.read<SettingsProvider>().rimSize,
      //   "s2": context.read<SettingsProvider>().ballSize,
      //   "player": player,
      //   "r_time": r_time,
      // };
      // channel.sink.add(jsonEncode(payload));
      isProcessing = false;
    } catch (e) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'An error occurred while processing the image. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                )
              ],
            );
          });
      isProcessing = false;
    }
  }

  //Initializes the websocket connection to the backend server. Update shots and stats based on the response from the server.
  void initializeWebSocket() {
    channel = IOWebSocketChannel.connect(
        'ws://192.168.50.23:3324'); // Replace with your server address
    channel.stream.listen(
      (dynamic data) {
        final response = jsonDecode(data);
        ballPos = response['ball_pos'];
        hoopPos = response['hoop_pos'];
        up = response['up'];
        down = response['down'];
        upFrame = response['up_frame'];
        downFrame = response['down_frame'];
        makes = response['makes'];
        attempts = response['attempts'];
        shotTaken = response['shot_taken'];
        frameCount = response['frame_count'];
        player = response['player'];
        r_time = response['r_time'];

        isProcessing = false;
        if (shotTaken != false) {
          widget.shots.add(Shot(
            shotMade: shotTaken[0],
            releaseHeight: shotTaken[4],
            releaseTime: shotTaken[5],
            shotDepth: shotTaken[2],
            shotPosition: shotTaken[3],
            entryAngle: shotTaken[1],
          ));
        }
      },
      onError: (error) {
        debugPrint('WebSocket error: $error');
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text(
                    'An error occurred while processing the image. Please try again.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  )
                ],
              );
            });
      },
      onDone: () {
        debugPrint('WebSocket connection closed');
      },
    );
  }

  //Compresses the image from YUV420 format to Jpg to be sent to the server.
  Uint8List compressImage(CameraImage cameraImage, {int quality = 50}) {
    final int width = cameraImage.width;
    final int height = cameraImage.height;

    // Create an empty image buffer
    final img.Image image = img.Image(width: width, height: height);

    // Extract the planes
    final Uint8List yPlane = cameraImage.planes[0].bytes;
    final Uint8List uPlane = cameraImage.planes[1].bytes;
    final Uint8List vPlane = cameraImage.planes[2].bytes;

    final int yRowStride = cameraImage.planes[0].bytesPerRow;
    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int yIndex = y * yRowStride + x;

        final int uvIndex = (y ~/ 2) * uvRowStride + (x ~/ 2) * uvPixelStride;

        final int yValue = yPlane[yIndex];
        final int uValue = uPlane[uvIndex];
        final int vValue = vPlane[uvIndex];

        // Convert YUV to RGB
        final int r = (yValue + 1.402 * (vValue - 128)).clamp(0, 255).toInt();
        final int g =
            (yValue - 0.344136 * (uValue - 128) - 0.714136 * (vValue - 128))
                .clamp(0, 255)
                .toInt();
        final int b = (yValue + 1.772 * (uValue - 128)).clamp(0, 255).toInt();

        // Set the pixel
        image.setPixelRgb(x, y, r, g, b);
      }
    }

    // Correct rotation if necessary
    final img.Image rotatedImage = img.copyRotate(image, angle: 90);

    // Compress to JPEG
    return Uint8List.fromList(img.encodeJpg(rotatedImage, quality: quality));
  }

  @override
  void dispose() {
    controller?.dispose();

    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!(controller?.value.isInitialized ?? false)) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: CameraPreview(controller!),
    );
  }
}
