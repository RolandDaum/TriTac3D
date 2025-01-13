import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/gameOverlay.dart';
import 'package:tritac3d/components/tttField.dart';
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                !gameController.getBackgroundMode()
                    ? gameController.getWinsX().toString()
                    : "0",
                style: TextStyle(fontSize: 64, fontWeight: FontWeight.w900),
              ),
              Row(
                children: [
                  CustomPaint(
                    size: Size(20, 20),
                    painter: TttfieldCross(appDesign),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "CROSS",
                    style:
                        TextStyle(color: appDesign.fontInactive, fontSize: 16),
                  )
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Text(
              ":",
              style: TextStyle(fontSize: 64, fontWeight: FontWeight.w900),
            ),
          ),
          Column(
            children: [
              Text(
                !gameController.getBackgroundMode()
                    ? gameController.getWinsO().toString()
                    : "0",
                style: TextStyle(fontSize: 64, fontWeight: FontWeight.w900),
              ),
              Row(
                children: [
                  CustomPaint(
                    size: Size(20, 20),
                    painter: TttfieldCircle(appDesign),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "CIRCLE",
                    style:
                        TextStyle(color: appDesign.fontInactive, fontSize: 16),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
