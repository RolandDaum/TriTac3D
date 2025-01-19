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

  List<String> _codeAlphabet = [
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
  ];
  List<String> _codeList = ["", "", "", ""];
  Map<int, GlobalKey<ScrollSelectorState>> _scrollSelectorKeys = {};

  bool connected = false;

  @override
  void initState() {
    for (int i = 0; i < 4; i++) {
      _scrollSelectorKeys[i] = GlobalKey<ScrollSelectorState>();
    }

    webRTCConnectionManager.connectionEstablished = () {
      connected = true;
      widget.onTTTGameManagerCreation
          .call(TTTGameManagerRTC(webRTCConnectionManager));
      widget.switchToPopUp(acPopUpTypes.gamePlay);
    };
    webRTCConnectionManager.connectionFailed = () {
      connected = false;
    };
    super.initState();
  }

  @override
  void dispose() {
    if (!connected) {
      webRTCConnectionManager.dispose();
    }
    super.dispose();
  }

  void updateSelectedIndex() {
    _scrollSelectorKeys.forEach((index, key) {
      key.currentState?.scrollTo(_codeAlphabet.indexOf(_codeList[index]));
    });
  }

  @override
  Widget build(BuildContext context) {
    final Appdesign appDesign = Provider.of<Appdesign>(context);
    return Container(
      alignment: Alignment.center,
      margin: appDesign.popupMargin,
      padding: appDesign.popupContainerPadding,
      decoration: BoxDecoration(
          color: appDesign.onBackgroundContainer,
          borderRadius: appDesign.popupContainerRadius),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(4, (index) {
              return Row(
                children: [
                  ScrollSelector(
                    key: _scrollSelectorKeys[index],
                    items: _codeAlphabet,
                    onScroll: (value) {
                      setState(() {
                        _codeList[index] = value;
                      });
                    },
                  ),
                  if (index < 3) const _vertSeperator(),
                ],
              );
            }),
          ),
          SizedBox(
            height: 20,
          ),
          TTTButton(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            onPressed: () {
              webRTCConnectionManager.joinGame(_codeList.join());
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
                List<String> charList = clipbaordData.text!.split('');
                if (charList.length == 4 &&
                    charList.any((char) => _codeAlphabet.contains(char))) {
                  setState(() {
                    _codeList = charList;
                  });

                  updateSelectedIndex();
                  webRTCConnectionManager.joinGame(_codeList.join());
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
