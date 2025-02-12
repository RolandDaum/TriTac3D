import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/tttGrid.dart';
import 'package:tritac3d/utils/appDesign.dart';
import 'package:tritac3d/utils/tttGameController.dart';

class TTTStack extends StatefulWidget {
  const TTTStack({super.key});

  @override
  State<TTTStack> createState() => TTTStackState();
}

class TTTStackState extends State<TTTStack> with TickerProviderStateMixin {
  late AnimationController rotationController;
  late AnimationController verticalPosController;
  double dyLastLayerFocusChange = 0;

  @override
  void initState() {
    final gameController =
            Provider.of<TTTGameController>(context, listen: false),
        appDesign = Provider.of<Appdesign>(context, listen: false);

    /// ROTATION CONTROLLER
    rotationController = AnimationController(
      lowerBound: double.negativeInfinity,
      upperBound: double.infinity,
      value: gameController.getLayerRotation(),
      duration: Duration(seconds: 7),
      vsync: this,
    );

    // CHANGES DEPENTEING ON BACKGROUND MODE STATE
    void Function() enableBackgroundAnimation = () {
      rotationController.repeat(
        min: gameController.getLayerRotation(),
        max: gameController.getLayerRotation() + 360,
        period: Duration(seconds: appDesign.backgroundModeRotationTime),
      );
    };
    if (gameController.getBackgroundMode()) {
      enableBackgroundAnimation();
    } else {
      rotationController.stop();
    }
    gameController.setOnBackgroundModeChange((state) {
      if (state) {
        enableBackgroundAnimation();
      } else {
        rotationController.stop();
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final gameController =
            Provider.of<TTTGameController>(context, listen: false),
        appDesign = Provider.of<Appdesign>(context, listen: false);

    int nGS = gameController.getGameSettings().getGFSize();

    /// VERTICAL SCROLL CONTROLLER
    verticalPosController = AnimationController(
        lowerBound: (MediaQuery.of(context).size.height / 2) -
            (nGS) * appDesign.gridDistance,
        upperBound: (MediaQuery.of(context).size.height / 2),
        value: 0,
        vsync: this);

    verticalPosController.value = (MediaQuery.of(context).size.height / 2) -
        (nGS - gameController.getActiveLayer()) * appDesign.gridDistance;

    focusOnLayer(gameController.getActiveLayer());
    // verticalPosController = AnimationController(value: 0, vsync: this);
  }

  @override
  void dispose() {
    rotationController.dispose();
    verticalPosController.dispose();
    super.dispose();
  }

  /// Methode zum Setzen und Animieren des Drehwinkels
  Future<void> setRotation(double targetAngle) async {
    if (targetAngle < rotationController.lowerBound ||
        targetAngle > rotationController.upperBound) {
      return;
    }
    await rotationController.animateTo(
      targetAngle,
      duration: Duration.zero,
    );
  }

  Future<void> setVertPosition(double vertical) async {
    final gameController =
            Provider.of<TTTGameController>(context, listen: false),
        appDesign = Provider.of<Appdesign>(context, listen: false);

    verticalPosController.value = vertical;

    if (gameController.setActiveLayer(_getNearestLayerID())) {
      dyLastLayerFocusChange = 0;
      appDesign.vibrateMovement();
    }
  }

  int _getNearestLayerID() {
    final gameController =
            Provider.of<TTTGameController>(context, listen: false),
        appDesign = Provider.of<Appdesign>(context, listen: false);
    int nGS = gameController.getGameSettings().getGFSize();

    if (dyLastLayerFocusChange.abs() >= (appDesign.gridDistance)) {
      if (dyLastLayerFocusChange < 0) {
        return gameController.getActiveLayer() - 1 >= 0
            ? gameController.getActiveLayer() - 1
            : 0;
      } else {
        return gameController.getActiveLayer() + 1 < nGS
            ? gameController.getActiveLayer() + 1
            : nGS - 1;
      }
    } else {
      return gameController.getActiveLayer();
    }
  }

  Future<void> focusOnNearestLayer() async {
    final gameController =
        Provider.of<TTTGameController>(context, listen: false);

    await focusOnLayerAnimated(gameController.getActiveLayer());
  }

  Future<void> focusOnLayer(int layerID) async {
    final appDesign = Provider.of<Appdesign>(context, listen: false),
        gameController = Provider.of<TTTGameController>(context, listen: false);

    verticalPosController.value = (MediaQuery.of(context).size.height / 2) -
        (gameController.getGameSettings().getGFSize() - layerID) *
            appDesign.gridDistance;
  }

  Future<void> focusOnLayerAnimated(int layerID) async {
    final appDesign = Provider.of<Appdesign>(context, listen: false),
        gameController = Provider.of<TTTGameController>(context, listen: false);

    verticalPosController.animateTo(
        (MediaQuery.of(context).size.height / 2) -
            (gameController.getGameSettings().getGFSize() - layerID) *
                appDesign.gridDistance,
        duration: const Duration(
          milliseconds: 250,
          // 250 * ((gameController.getActiveLayer() - layerID).abs()) + 1),
        ),
        curve: Curves.bounceInOut);
  }

  List<Widget> _buildTTTGridStack() {
    final appDesign = Provider.of<Appdesign>(context),
        gameController = Provider.of<TTTGameController>(context);
    int nGS = gameController.getGameSettings().getGFSize();

    return List.generate(nGS, (i) {
      return AnimatedBuilder(
        animation:
            Listenable.merge([rotationController, verticalPosController]),
        builder: (context, child) {
          return Positioned(
            top: appDesign.gridDistance * (nGS - i - 1) +
                verticalPosController.value +
                (i <= gameController.getActiveLayer()
                    ? appDesign.gridDistance / 2
                    : 0),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateX((pi / 4) * 1.25)
                ..rotateZ(-1 * rotationController.value * (pi / 180)),
              child: Stack(alignment: Alignment.center, children: [
                ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 5.0,
                        sigmaY:
                            5.0), // Blur everything underneith it (Frosted Glass effect)
                    child: Container(
                      height: appDesign.layerWidth,
                      width: appDesign.layerWidth,
                      decoration: BoxDecoration(
                          color: appDesign.onBackgroundContainer.withAlpha(86)),
                    ),
                  ),
                ),
                TTTGrid(
                  gameController: gameController,
                  gridID: i.toDouble(),
                ),
                gameController.getActiveLayer() != i
                    ? GestureDetector(
                        onTap: () async {
                          gameController.setActiveLayer(i);
                          await focusOnLayerAnimated(i);
                          appDesign.vibrateMovement();
                        },
                        child: Container(
                          height: appDesign.layerWidth,
                          width: appDesign.layerWidth,
                          decoration: BoxDecoration(
                              color: appDesign.onBackgroundContainer
                                  .withAlpha(128),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                        ),
                      )
                    : SizedBox(
                        width: appDesign.layerWidth,
                        height: appDesign.layerWidth),
              ]),
            ),
          );
        },
      );
    }, growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: _buildTTTGridStack(),
    );
  }
}
