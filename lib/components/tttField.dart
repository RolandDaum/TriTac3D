import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/utils/appDesign.dart';
import 'package:tritac3d/utils/tttGameController.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:flutter/foundation.dart';

class TTTField extends StatefulWidget {
  final TTTGameController gameController;
  final vm.Vector3 cordID;

  const TTTField(
      {super.key, required this.cordID, required this.gameController});

  @override
  State<TTTField> createState() => _TTTFieldSState();
}

class _TTTFieldSState extends State<TTTField> {
  BorderRadiusGeometry borderRadius = const BorderRadius.all(Radius.zero);

  void updateBorderRadius() {
    int nGS = widget.gameController.getGameSettings().getGFSize();
    final isTopLeft = widget.cordID.x == 0 && widget.cordID.y == 0;
    final isBottomLeft = widget.cordID.x == 0 && widget.cordID.y == nGS - 1;
    final isTopRight = widget.cordID.x == nGS - 1 && widget.cordID.y == 0;
    final isBottomRight =
        widget.cordID.x == nGS - 1 && widget.cordID.y == nGS - 1;

    setState(() {
      borderRadius = BorderRadius.only(
        topLeft: isTopLeft ? const Radius.circular(20) : Radius.zero,
        bottomLeft: isBottomLeft ? const Radius.circular(20) : Radius.zero,
        topRight: isTopRight ? const Radius.circular(20) : Radius.zero,
        bottomRight: isBottomRight ? const Radius.circular(20) : Radius.zero,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final appDesign = Provider.of<Appdesign>(context);
    updateBorderRadius();

    CustomPainter? getFieldPainer(TTTFS state) {
      switch (state) {
        case TTTFS.cricle:
          return TttfieldCircle(appDesign);
        case TTTFS.cross:
          return TttfieldCross(appDesign);
        default:
          return null;
      }
    }

    double fieldLength = appDesign.layerWidth /
        widget.gameController.getGameSettings().getGFSize();
    return GestureDetector(
      onTap: () {
        widget.gameController.registeredMoveEvent(widget.cordID);
      },
      child: Container(
        height: fieldLength,
        width: fieldLength,
        decoration: BoxDecoration(
            // color: appDesign.onBackgroundContainer.withOpacity(.25),
            color: Colors.transparent,
            borderRadius: borderRadius,
            border: Border.all(
                color: widget.gameController.getHighlightedState(widget.cordID)
                    ? appDesign.fontActive
                    : appDesign.fontInactive,
                width: 1)),
        child: kDebugMode
            ? Stack(
                children: [
                  CustomPaint(
                    size: Size(fieldLength - 10, fieldLength - 10),
                    painter: getFieldPainer(widget.gameController
                        .getField(widget.cordID)
                        .getState()),
                  ),
                  Text(widget.cordID.toString())
                ],
              )
            : CustomPaint(
                size: Size(fieldLength - 10, fieldLength - 10),
                painter: getFieldPainer(
                    widget.gameController.getField(widget.cordID).getState()),
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
