import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tritac3d/components/tttGrid.dart';

class TTTStack extends StatefulWidget {
  const TTTStack({super.key});

  @override
  State<TTTStack> createState() => _TTTStackState();
}

class _TTTStackState extends State<TTTStack> {
  @override
  Widget build(BuildContext context) {
    List<Widget> tttGrids = [];
    for (int i = 0; i < 3; i++) {
      tttGrids.add(
        Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 135.0 * (3 - i),
              child: Transform(
                alignment: Alignment.center,
                transform:
                    Matrix4.rotationX((pi / 4) * (1 + 0.25 * i * 0) * 1.5)
                      ..rotateZ(pi / 4),
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: const TTTGrid(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } // First rotate and then afterwards offest them
    return Center(
      child: Stack(
        children: tttGrids,
      ),
    );
    // return ListView.builder(
    //     shrinkWrap: true,
    //     itemCount: 3,
    //     // physics: const NeverScrollableScrollPhysics(),
    //     scrollDirection: Axis.vertical,
    //     itemBuilder: (context, index) {
    //       // return TTTGrid();
    //       return Transform(
    //           origin: const Offset(
    //               -150, -150), // Grid Height/Widt devided by 2 times -1
    //           alignment: Alignment.center,
    //           transform: Matrix4.rotationX((pi / 4) * 1.6)
    //             ..rotateZ(pi / 4), // X Rotation factor < 2
    //           child: TTTGrid());
    //     });
  }
}
