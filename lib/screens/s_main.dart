import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/gameOverlay.dart';
import 'package:tritac3d/components/tttStack.dart';
import 'package:tritac3d/utils/appDesign.dart';
import 'package:tritac3d/utils/tttGameController.dart';

class SMain extends StatefulWidget {
  const SMain({super.key});

  @override
  State<SMain> createState() => _SMainState();
}

class _SMainState extends State<SMain> {
  final GlobalKey<TTTStackState> _stackStateKey = GlobalKey<TTTStackState>();
  late double rotationValue;

  @override
  void initState() {
    // Removes old games that are older than 2 minute
    if (Random().nextInt(100) == 1) {
      FirebaseDatabase.instance.ref('games').once().then((event) {
        if (event.snapshot.exists) {
          Map<String, dynamic> data =
              (event.snapshot.value as Map).cast<String, dynamic>();
          data.forEach((game, gameData) {
            int timestamp = int.parse(gameData['tsmp'].toString());
            DateTime gameTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
            if (DateTime.now().difference(gameTime).inMinutes > 2) {
              FirebaseDatabase.instance.ref('games/$game').remove();
            }
          });
        }
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appDesign = Provider.of<Appdesign>(context),
        gameController = Provider.of<TTTGameController>(context, listen: false);
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            gameController.setLayerRotation(
                gameController.getLayerRotation() + details.delta.dx);
            _stackStateKey.currentState!
                .setRotation(gameController.getLayerRotation());
          },
          onVerticalDragUpdate: (details) {
            _stackStateKey.currentState!.dyLastLayerFocusChange +=
                details.delta.dy;
            _stackStateKey.currentState!.setVertPosition(
                _stackStateKey.currentState!.verticalPosController.value +
                    details.delta.dy);
          },
          onVerticalDragEnd: (detail) {
            _stackStateKey.currentState!.focusOnNearestLayer();
          },
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: appDesign.primaryBackground,
              image: DecorationImage(
                image: AssetImage("assets/images/image_background.png"),
                repeat: ImageRepeat.repeat,
              ),
            ),
            child: TTTStack(
              key: _stackStateKey,
            ),
          ),
        ),
        GameOverlay()
      ],
    );
  }
}
