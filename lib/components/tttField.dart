import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/utils/appDesign.dart';

class TTTField extends StatefulWidget {
  const TTTField({super.key});

  @override
  State<TTTField> createState() => _TTTFieldState();
}

class _TTTFieldState extends State<TTTField> {
  bool state = false;
  @override
  Widget build(BuildContext context) {
    final appDesign = Provider.of<Appdesign>(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          state = !state;
        });
      },
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
            color: appDesign.onBackgroundContainer.withOpacity(1),
            border: Border.all(color: appDesign.fontInactive, width: 1)),
        child: Center(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
                sigmaX: 0, sigmaY: 0), // Blurs only the cross or circle
            child: CustomPaint(
              size: const Size(100, 100),
              painter: state
                  ? (Random().nextBool() ? TttfieldCircle(appDesign) : null)
                  : (Random().nextBool() ? TttfieldCross(appDesign) : null),
            ),
          ),
        ),
      ),
    );
  }
}

class TttfieldCross extends CustomPainter {
  Appdesign appdesign;
  TttfieldCross(this.appdesign);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = appdesign.accentGreen
      ..strokeWidth = appdesign.crossCircleStrokeWidth
      ..style = PaintingStyle.stroke;

    // Diagonalen des Kreuzes
    canvas.drawLine(
      Offset(size.width / 4, size.height / 4), // Startpunkt
      Offset(3 * size.width / 4, 3 * size.height / 4), // Endpunkt
      paint,
    );
    canvas.drawLine(
      Offset(3 * size.width / 4, size.height / 4), // Startpunkt
      Offset(size.width / 4, 3 * size.height / 4), // Endpunkt
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TttfieldCircle extends CustomPainter {
  Appdesign appdesign;
  TttfieldCircle(this.appdesign);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = appdesign.accentBlue
      ..strokeWidth = appdesign.crossCircleStrokeWidth
      ..style = PaintingStyle.stroke;

    // Kreis
    final circleRadius = size.width / 3; // Radius des Kreises
    final circleCenter = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(circleCenter, circleRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
