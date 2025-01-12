import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/tttField.dart';
import 'package:tritac3d/utils/appDesign.dart';
import 'package:tritac3d/utils/tttGameController.dart';
import 'package:vector_math/vector_math.dart';

class TTTGrid extends StatefulWidget {
  final double gridID;
  final TTTGameController gameController;
  const TTTGrid(
      {super.key, required this.gridID, required this.gameController});

  @override
  State<TTTGrid> createState() => _TTTGridState();
}

class _TTTGridState extends State<TTTGrid> {
  List<Widget> _buildTTTGrid() {
    final gameController = Provider.of<TTTGameController>(context);
    int nGS = gameController.getGameSettings().getGFSize();

    return List.generate(pow(nGS, 2).toInt(), (index) {
      return TTTField(
        gameController: gameController,
        cordID: Vector3((index % nGS).toDouble(),
            (index / nGS).floor().toDouble(), widget.gridID),
      );
    }, growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final appDesign = Provider.of<Appdesign>(context);
    int nGS = widget.gameController.getGameSettings().getGFSize();

    return Container(
      height: appDesign.layerWidth,
      width: appDesign.layerWidth,
      clipBehavior: Clip.none, // Changed
      decoration: BoxDecoration(
          border: Border.all(color: appDesign.fontInactive, width: 1),
          borderRadius: BorderRadius.circular(20)),
      child: GridView(
        shrinkWrap: false,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: nGS, mainAxisSpacing: 0, crossAxisSpacing: 0),
        children: _buildTTTGrid(),
      ),
    );
  }
}
