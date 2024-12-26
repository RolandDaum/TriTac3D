import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/tttGrid.dart';
import 'package:tritac3d/utils/appDesign.dart';

class TTTStack extends StatefulWidget {
  const TTTStack({Key? key}) : super(key: key);

  @override
  State<TTTStack> createState() => TTTStackState();
}

class TTTStackState extends State<TTTStack> with TickerProviderStateMixin {
  int activeIndex = 0;
  late AnimationController rotationController;

  @override
  void initState() {
    super.initState();

    rotationController = AnimationController(
      lowerBound: double.negativeInfinity,
      upperBound: double.infinity,
      value: 0,
      vsync: this,
    );
  }

  /// Methode zum Setzen und Animieren des Drehwinkels
  Future<void> setRotation(double targetAngle) async {
    if (targetAngle < rotationController.lowerBound ||
        targetAngle > rotationController.upperBound) {
      return;
    }
    await rotationController.animateTo(
      targetAngle,
      duration: const Duration(milliseconds: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appDesign = Provider.of<Appdesign>(context);
    List<Widget> tttGrids = [];
    int _shadowDistance = 20;
    for (int i = 0; i < 3; i++) {
      tttGrids.add(
        Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 175.0 * (3 - i),
              child: AnimatedBuilder(
                animation: rotationController,
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationX((pi / 4) * 1.25)
                      ..rotateZ(-1 * rotationController.value * (pi / 180)),
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
                                height: 300,
                                width: 300,
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: appDesign.onBackgroundContainer
                                            .withOpacity(0),
                                        blurRadius: 20,
                                        offset: Offset(
                                            sin(-rotationController.value *
                                                    (pi / 180)) *
                                                _shadowDistance,
                                            cos(-rotationController.value *
                                                    (pi / 180)) *
                                                _shadowDistance),
                                        spreadRadius: 0)
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(width: 300, height: 300),
                    ]),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
    return Center(
      child: Stack(
        children: tttGrids,
      ),
    );
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }
}
