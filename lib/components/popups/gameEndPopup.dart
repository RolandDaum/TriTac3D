import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/gameOverlay.dart';
import 'package:tritac3d/components/tttButton.dart';
import 'package:tritac3d/components/tttField.dart';
import 'package:tritac3d/utils/appDesign.dart';
import 'package:tritac3d/utils/tttGameController.dart';

class Gameendpopup extends StatelessWidget {
  final Function(acPopUpTypes type) switchToPopUp;
  Gameendpopup({super.key, required this.switchToPopUp});

  @override
  Widget build(BuildContext context) {
    final appDesign = Provider.of<Appdesign>(context),
        gameController = Provider.of<TTTGameController>(context);

    return Container(
      margin: appDesign.popupMargin,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: appDesign.popupContainerPadding,
            decoration: BoxDecoration(
              color: appDesign.onBackgroundContainer,
              borderRadius: appDesign.popupContainerRadius,
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
                      style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w900,
                          color: appDesign.fontActive),
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
                          style: TextStyle(
                              color: appDesign.fontInactive, fontSize: 16),
                        )
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Text(
                    ":",
                    style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        color: appDesign.fontActive),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      !gameController.getBackgroundMode()
                          ? gameController.getWinsO().toString()
                          : "0",
                      style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w900,
                          color: appDesign.fontActive),
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
                          style: TextStyle(
                              color: appDesign.fontInactive, fontSize: 16),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TTTButton(
                    onPressed: () => switchToPopUp(acPopUpTypes.gamePlay),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    text: "Revenge",
                    fontSize: 24),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TTTButton(
                  onPressed: () => switchToPopUp(acPopUpTypes.gameButton),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  text: "Quit",
                  type: TTTBType.secondary,
                  fontSize: 24,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
