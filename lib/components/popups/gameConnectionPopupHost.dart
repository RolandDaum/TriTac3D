import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/homeOverlay.dart';
import 'package:tritac3d/components/tttButton.dart';
import 'package:tritac3d/utils/WebRTCConnectionManager.dart';
import 'package:tritac3d/utils/appDesign.dart';

class Gameconnectionpopuphost extends StatefulWidget {
  final Function(acPopUpTypes type) switchToPopUp;

  const Gameconnectionpopuphost({super.key, required this.switchToPopUp});

  @override
  State<Gameconnectionpopuphost> createState() =>
      _GameconnectionpopuphostState();
}

class _GameconnectionpopuphostState extends State<Gameconnectionpopuphost>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final WebRTCConnectionManager webRTCConnectionManager =
      WebRTCConnectionManager();
  String _gameCode = "";
  bool connected = false;

  @override
  void initState() {
    webRTCConnectionManager.connectionEstablished = () {
      print("");
      print("");
      print(" - C O N N E C T E D - ");
      print("");
      print("");
    };
    webRTCConnectionManager.createGame()
        // .then((gameCode) {
        //   setState(() {
        //     this._gameCode = gameCode;
        //   });
        // })
        ;
    webRTCConnectionManager.setOnNewGameCode((gameCode) {
      setState(() {
        this._gameCode = gameCode;
      });
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: false);
    super.initState();
  }

  @override
  void dispose() {
    webRTCConnectionManager.dispose();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Appdesign appDesign = Provider.of<Appdesign>(context);
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 40).copyWith(bottom: 40),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
            color: appDesign.onBackgroundContainer,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            TTTButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _gameCode));
                },
                text: _gameCode,
                type: TTTBType.secondary),
            SizedBox(height: 20),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                int dotCount = (_controller.value * 4).floor();
                String dots = ' .' * dotCount;
                String placeHolder = '  ' * (3 - dotCount);
                return Text(
                  "Waiting for opponent$dots$placeHolder",
                  style: TextStyle(
                    color: appDesign.fontActive,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ));
  }
}
