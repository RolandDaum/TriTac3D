import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/homeOverlay.dart';
import 'package:tritac3d/components/tttButton.dart';
import 'package:tritac3d/utils/appDesign.dart';

class Gameconnectionpopup extends StatefulWidget {
  final Function(acPopUpTypes type) switchToPopUp;

  const Gameconnectionpopup({super.key, required this.switchToPopUp});

  @override
  State<Gameconnectionpopup> createState() => _GameconnectionpopupState();
}

class _GameconnectionpopupState extends State<Gameconnectionpopup> {
  @override
  Widget build(BuildContext context) {
    final Appdesign appDesign = Provider.of<Appdesign>(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40).copyWith(bottom: 40),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: appDesign.onBackgroundContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // TODO: Add icons and in generall continue right here
          TTTButton(
            onPressed: () {
              widget.switchToPopUp(acPopUpTypes.gameConnectionHost);
            },
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/icon_server.svg",
                  colorFilter:
                      ColorFilter.mode(appDesign.fontActive, BlendMode.srcIn),
                  height: 44,
                ),
                SizedBox(width: 20),
                Text("HOST",
                    style: appDesign.TTTButtonTxtStyle.copyWith(fontSize: 34))
              ],
            ),
          ),
          SizedBox(height: 20),
          TTTButton(
            onPressed: () {
              widget.switchToPopUp(acPopUpTypes.gameConnectionJoin);
            },
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/icon_abc.svg",
                  colorFilter:
                      ColorFilter.mode(appDesign.fontActive, BlendMode.srcIn),
                  height: 44,
                ),
                SizedBox(width: 20),
                Text("JOIN",
                    style: appDesign.TTTButtonTxtStyle.copyWith(fontSize: 34))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
