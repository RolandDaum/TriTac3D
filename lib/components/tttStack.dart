import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/tttGrid.dart';
import 'package:tritac3d/utils/appDesign.dart';

class TTTStack extends StatefulWidget {
  const TTTStack({super.key});

  @override
  State<TTTStack> createState() => _TTTStackState();
}

class _TTTStackState extends State<TTTStack> {
  List<Widget> buildBlurredImage(List<Widget> l) {
    List<Widget> list = [];
    list.addAll(l);
    double sigmaX = 0.1;
    double sigmaY = 0.1;
    int steps = 40;
    int oversize = 20;
    for (int i = 0; i < 50; i += 5) {
      // 100 is the starting height of blur
      // 350 is the ending height of blur
      list.add(Positioned(
        top: oversize / steps * i.toDouble(),
        bottom: oversize / steps * i.toDouble(),
        left: oversize / steps * i.toDouble(),
        right: oversize / steps * i.toDouble(),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: sigmaX,
              sigmaY: sigmaY,
            ),
            child: Container(
              color: Colors.black.withOpacity(0),
            ),
          ),
        ),
      ));
      sigmaX += .1;
      sigmaY += .1;
    }
    return list;
  }

  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    final appDesign = Provider.of<Appdesign>(context);
    List<Widget> tttGrids = [];
    for (int i = 0; i < 3; i++) {
      tttGrids.add(
        Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 175.0 * (3 - i),
              child: Transform(
                alignment: Alignment.center,
                transform:
                    Matrix4.rotationX((pi / 4) * (1 + 0.25 * i * 0) * 1.25)
                      ..rotateZ(pi / 4),
                child: Stack(alignment: Alignment.center, children: [
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: 5.0,
                          sigmaY:
                              5.0), // Blur everything underneith it (Frosted Glass effect)
                      child: const TTTGrid(),
                    ),
                  ),
                  activeIndex != i
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              activeIndex = i;
                            });
                          },
                          child: Container(
                            height: 340,
                            width: 340,
                            child: Stack(
                              alignment: Alignment.center,
                              children: buildBlurredImage([]),
                            ),
                          ),
                        )
                      : SizedBox(width: 340, height: 340),
                ]),
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
  }
}
