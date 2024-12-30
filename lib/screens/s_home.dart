import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/tttStack.dart';
import '../utils/appDesign.dart';
import '../utils/tttGameController.dart';

class SHome extends StatefulWidget {
  const SHome({super.key});

  @override
  State<SHome> createState() => _SHomeState();
}

class _SHomeState extends State<SHome> {
  final TTTGameController gameController = TTTGameController();
  final GlobalKey<TTTStackState> _stackStateKey = GlobalKey<TTTStackState>();
  late double rotationValue;
  @override
  void initState() {
    super.initState();

    rotationValue = gameController.getLayerRotation();
  }

  @override
  Widget build(BuildContext context) {
    final appDesign = Provider.of<Appdesign>(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            gameController.setLayerRotation(rotationValue += details.delta.dx);
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
            color: appDesign.primaryBackground,
          ),
        ),
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            gameController.setLayerRotation(rotationValue += details.delta.dx);
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
          child: ChangeNotifierProvider<TTTGameController>(
            create: (context) => gameController,
            child: Consumer<TTTGameController>(
                builder: (context, appDesign, child) {
              return TTTStack(
                key: _stackStateKey,
              );
            }),
          ),
        ),
      ],
    );
  }
}
