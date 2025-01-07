import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/gameOverlay.dart';
import 'package:tritac3d/components/scrollSelector.dart';
import 'package:tritac3d/components/tttButton.dart';
import 'package:tritac3d/utils/WebRTCConnectionManager.dart';
import 'package:tritac3d/utils/appDesign.dart';
import 'package:tritac3d/utils/tttGameManager.dart';
import 'package:tritac3d/utils/tttGameManagerRTC.dart';

class Gameconnectionpopupjoin extends StatefulWidget {
  final Function(acPopUpTypes type) switchToPopUp;
  final Function(TTTGameManager?) onTTTGameManagerCreation;

  Gameconnectionpopupjoin(
      {super.key,
      required this.switchToPopUp,
      required this.onTTTGameManagerCreation});

  @override
  _GameconnectionpopupjoinState createState() =>
      _GameconnectionpopupjoinState();
}

class _GameconnectionpopupjoinState extends State<Gameconnectionpopupjoin> {
  final WebRTCConnectionManager webRTCConnectionManager =
      WebRTCConnectionManager();
  String _gameCode = "";

  @override
  void initState() {
    webRTCConnectionManager.connectionEstablished = () {
      print("");
      print("");
      print(" - C O N N E C T E D - ");
      print("");
      print("");
      widget.onTTTGameManagerCreation
          .call(TTTGameManagerRTC(webRTCConnectionManager));
      widget.switchToPopUp(acPopUpTypes.gamePlay);
    };
    webRTCConnectionManager.connectionFailed = () {
      print("");
      print("");
      print(" - F A I L E D - ");
      print("");
      print("");
      widget.onTTTGameManagerCreation.call(null);
    };
    super.initState();
  }

  @override
  void dispose() {
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _gameCodeSelector(
            onCodeChange: (code) {
              _gameCode = code;
            },
          ),
          SizedBox(
            height: 20,
          ),
          TTTButton(
            onPressed: () {
              webRTCConnectionManager.joinGame(_gameCode);
            },
            text: "CONTINUE",
          ),
          SizedBox(
            height: 20,
          ),
          TTTButton(
            type: TTTBType.secondary,
            onPressed: () {
              Clipboard.getData('text/plain').then((clipbaordData) {
                if (!(clipbaordData != null && clipbaordData.text != null)) {
                  return;
                }
                List<String> charList = clipbaordData!.text!.split('');
                if (charList.length == 4 &&
                    charList.any((char) => [
                          "0",
                          "1",
                          "2",
                          "3",
                          "4",
                          "5",
                          "6",
                          "7",
                          "8",
                          "9"
                        ].contains(char))) {
                  setState(() {
                    _gameCode = charList.join();
                  });
                  webRTCConnectionManager.joinGame(_gameCode);
                }
              });
            },
            text: "PASTE",
          )
        ],
      ),
    );
  }
}

class _gameCodeSelector extends StatelessWidget {
  final Function(String)? onCodeChange;

  _gameCodeSelector({this.onCodeChange});

  void _onChanges(List<String> codeList, String value, int index) {
    codeList[index] = value;
    if (onCodeChange != null) {
      onCodeChange!(codeList.join());
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> _codeList = ["", "", "", ""];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ScrollSelector(
          onScroll: (num) {
            _onChanges(_codeList, num.toString(), 0);
          },
        ),
        _vertSeperator(),
        ScrollSelector(
          onScroll: (num) {
            _onChanges(_codeList, num.toString(), 1);
          },
        ),
        _vertSeperator(),
        ScrollSelector(
          onScroll: (num) {
            _onChanges(_codeList, num.toString(), 2);
          },
        ),
        _vertSeperator(),
        ScrollSelector(
          onScroll: (num) {
            _onChanges(_codeList, num.toString(), 3);
          },
        ),
      ],
    );
  }
}

class _vertSeperator extends StatelessWidget {
  final double height = 100;
  const _vertSeperator();

  @override
  Widget build(BuildContext context) {
    final Appdesign appDesign = Provider.of<Appdesign>(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0),
      padding: EdgeInsets.symmetric(vertical: 20),
      width: 1,
      height: height,
      decoration: BoxDecoration(
        color: appDesign.border,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
