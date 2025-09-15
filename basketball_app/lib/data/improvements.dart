import 'package:flutter/material.dart';

class CameraWithHologramOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Camera feed widget (abstracted for now)
          Positioned.fill(
            child: Container(
              color: Colors.black, // Replace this with your camera widget
              child: const Center(
                child: Text(
                  'Camera Feed Goes Here',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),

          // Hologram overlay
          Positioned.fill(
            child: CustomPaint(
              painter: HologramPainter(),
            ),
          ),

          // Optional instructions overlay
          const Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Text(
              'Align the hoop with the hologram to calibrate the camera.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                backgroundColor: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HologramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.3) // Semi-transparent hologram color
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = Colors.blue.withOpacity(0.8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Define dimensions for the hologram (pole and hoop rectangle)
    final poleRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.1,
      height: size.height * 0.6,
    );

    final hoopRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.2),
      width: size.width * 0.5,
      height: size.height * 0.02,
    );

    // Draw the hologram elements
    canvas.drawRect(poleRect, paint); // Pole fill
    canvas.drawRect(poleRect, outlinePaint); // Pole outline

    canvas.drawRect(hoopRect, paint); // Hoop fill
    canvas.drawRect(hoopRect, outlinePaint); // Hoop outline
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // No need to repaint unless the hologram changes
  }
}