import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/gameOverlay.dart';
import 'package:tritac3d/components/tttButton.dart';
import 'package:tritac3d/utils/appDesign.dart';

class Homebuttonspopup extends StatelessWidget {
  final Function(acPopUpTypes type) switchToPopUp;
  Homebuttonspopup({super.key, required this.switchToPopUp});

  @override
  Widget build(BuildContext context) {
    final Appdesign appDesign = Provider.of<Appdesign>(context);
    return TTTButton(
      text: "P L A Y",
      width: double.infinity,
      fontSize: 60,
      margin: EdgeInsets.symmetric(horizontal: 45).copyWith(bottom: 40),
      padding: EdgeInsets.symmetric(vertical: 20),
      onPressed: () {
        switchToPopUp(acPopUpTypes.gameSetting);
      },
    );
  }
}
