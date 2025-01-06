import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/homeOverlay.dart';
import 'package:tritac3d/components/scrollSelector.dart';
import 'package:tritac3d/components/tttButton.dart';
import 'package:tritac3d/utils/WebRTCConnectionManager.dart';
import 'package:tritac3d/utils/appDesign.dart';

class Gameconnectionpopupjoin extends StatefulWidget {
  final Function(acPopUpTypes type) switchToPopUp;

  Gameconnectionpopupjoin({super.key, required this.switchToPopUp});

  @override
  _GameconnectionpopupjoinState createState() =>
      _GameconnectionpopupjoinState();
}

class _GameconnectionpopupjoinState extends State<Gameconnectionpopupjoin> {
  final WebRTCConnectionManager webRTCConnectionManager =
      WebRTCConnectionManager();
  String _code = "";

  @override
  void initState() {
    _findGame();
    super.initState();
  }

  @override
  void dispose() {
    webRTCConnectionManager.dispose();
    super.dispose();
  }

  void _findGame() {
    print(_code);
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref(_code);
    try {
      dbRef.once().then((DatabaseEvent event) {
        if (event.snapshot.exists) {
          final data = Map<String, dynamic>.from(
              event.snapshot.value as Map<Object?, Object?>);
          if (data.containsKey('offer')) {
            final offer = data['offer'];
            print('Offer found');
            webRTCConnectionManager
                .answerConnection(
                    RTCSessionDescription(offer['sdp'], offer['type']))
                .then((answerString) {
              dynamic answer = json.decode(answerString);
              dbRef.update({
                'answer': answer,
                // 'timestamp': DateTime.now().millisecondsSinceEpoch,
              }).then((_) {
                print('Answer wrote successfully.');
              });
            });
          }
        } else {
          print("No data available.");
        }
      });
    } catch (e) {
      print('Error joining game: $e');
    }
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
              print(code);
              _code = code;
            },
          ),
          SizedBox(
            height: 20,
          ),
          TTTButton(
            onPressed: () {
              _findGame();
            },
            text: "CONTINUE",
          )
        ],
      ),
    );
  }
}

class _gameCodeSelector extends StatelessWidget {
  final Function(String)? onCodeChange;

  _gameCodeSelector({super.key, this.onCodeChange});

  void _onChanges(List<String> codeList, String value, int index) {
    print("CODE SELECTOR CHANGES " + codeList.join());
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
  final double height;
  _vertSeperator({super.key, this.height = 100});

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
