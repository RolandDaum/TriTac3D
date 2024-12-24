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
    await rotationController.animateTo(
      targetAngle,
      duration: const Duration(
          milliseconds:
              0), // Add constant rotation angle velocity aka how fast it has to run in order to stay a  consistant rotation velocytie (timer per degree)
    );
  }

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
              child: AnimatedBuilder(
                animation: rotationController,
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationX((pi / 4) * 1.25)
                      ..rotateZ(rotationController.value * (pi / 180)),
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
                                  color: Colors.red.withOpacity(.25),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            appDesign.accentBlue.withOpacity(1),
                                        blurRadius: 0,
                                        offset: Offset(
                                            // Convert angle into Steigung -> But still buggie and idk what when ...
                                            ((tan(rotationController.value *
                                                        (pi / 180))) %
                                                    1) *
                                                40,
                                            ((tan((rotationController.value -
                                                            90) *
                                                        (pi / 180))) %
                                                    1) *
                                                40),
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
