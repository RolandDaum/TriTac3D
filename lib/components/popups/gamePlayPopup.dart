import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/gameOverlay.dart';
import 'package:tritac3d/utils/appDesign.dart';
import 'package:tritac3d/utils/tttGameController.dart';

class Gameplaypopup extends StatefulWidget {
  final Function(acPopUpTypes type) switchToPopUp;

  const Gameplaypopup({super.key, required this.switchToPopUp});

  @override
  State<Gameplaypopup> createState() => _GameplaypopupState();
}

class _GameplaypopupState extends State<Gameplaypopup> {
  @override
  Widget build(BuildContext context) {
    final appDesign = Provider.of<Appdesign>(context),
        gameController = Provider.of<TTTGameController>(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40).copyWith(bottom: 40),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: appDesign.onBackgroundContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text("X: " + gameController.getWinsX().toString()),
          Text("O: " + gameController.getWinsO().toString())
        ],
      ),
    );
  }
}
