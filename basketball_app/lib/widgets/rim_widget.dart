import 'dart:math';
import 'package:basketball_app/models/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Widget to display a basketball rim with an optional cross at a specified position
class BasketballRimWidget extends StatelessWidget {
  final Offset position;  // Position for the cross relative to the rim center

  const BasketballRimWidget({
    super.key,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Set the size of the CustomPaint area based on the smaller dimension of the constraints
        final size = min(constraints.maxHeight, constraints.maxWidth);
        return CustomPaint(
          size: Size(size, size),
          painter: BasketballRimPainter(position, context.watch<SettingsProvider>().rimSize.toDouble()),
        );
      },
    );
  }
}

// Painter to draw the basketball rim and cross
class BasketballRimPainter extends CustomPainter {
  final Offset position;
  
  final double diameter;

  BasketballRimPainter(this.position, this.diameter);

  @override
  void paint(Canvas canvas, Size size) {
    // Paint object for the rim (orange circle)
    Paint rimPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    // Radius and center of the rim circle, slightly smaller than the canvas
    double rimRadius = size.width / 2 - 10;
    Offset rimCenter = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(rimCenter, rimRadius, rimPaint);

    // Paint object for the cross (red lines)
    Paint crossPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw the cross only if the position offset is small enough
    if (position.dx.abs() > diameter/2+1 || position.dy.abs() > diameter/2+1) {
      return;  // If position is too far, skip drawing the cross
    }

    // Calculate cross position relative to the rim center, scaled to fit within rim radius
    Offset crossPosition = rimCenter.translate(
      position.dx * (rimRadius / (diameter/2)),
      position.dy * (rimRadius / (diameter/2)),
    );

    double crossSize = 10; // Size of the cross arms

    // Draw horizontal and vertical lines for the cross
    canvas.drawLine(
      Offset(crossPosition.dx - crossSize, crossPosition.dy),
      Offset(crossPosition.dx + crossSize, crossPosition.dy),
      crossPaint,
    );
    canvas.drawLine(
      Offset(crossPosition.dx, crossPosition.dy - crossSize),
      Offset(crossPosition.dx, crossPosition.dy + crossSize),
      crossPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;  // Always repaint to reflect updated position
  }
}
