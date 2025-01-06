import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/homeOverlay.dart';
import 'package:tritac3d/components/tttButton.dart';
import 'package:tritac3d/utils/WebRTCConnectionManager.dart';
import 'package:tritac3d/utils/appDesign.dart';
import 'package:firebase_database/firebase_database.dart';

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
  late String _code;
  final WebRTCConnectionManager webRTCConnectionManager =
      WebRTCConnectionManager();

  @override
  void initState() {
    _code = _generateGameCode();
    createGame();
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
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref(_code);
    dbRef.remove().then((_) {
      print('Game entry removed.');
    });
    super.dispose();
  }

  String _generateGameCode() {
    String code = "";
    for (int i = 0; i < 4; i++) {
      code += Random().nextInt(10).toString();
    }
    return code;
  }

  void createGame() async {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref(_code);

    try {
      final dynamic offer =
          json.decode(await webRTCConnectionManager.offerConnection());

      await dbRef.set({
        'offer': offer,
        // 'timestamp': DateTime.now().millisecondsSinceEpoch,
      }).then((_) {
        print('Offer wrote successfully.');
      });

      dbRef.onValue.listen((event) {
        if (event.snapshot.exists) {
          final data = Map<String, dynamic>.from(
              event.snapshot.value as Map<Object?, Object?>);
          if (data.containsKey('answer')) {
            final answer = data['answer'];
            print('Answer received');
            webRTCConnectionManager
                .acceptAnswer(
                    RTCSessionDescription(answer['sdp'], answer['type']))
                .then((_) {
              // dbRef.remove().then((_) {
              //   print('Game entry removed.');
              // });
              print("SETTINGS EXCHANGE AND START GAME");
              // EXCHANGE GAME SETTINGS -> Start game
              // REMOVE GAME ENTRY FROM DATABASE
            });
          }
        } else {
          print('No data found at this reference.');
        }
      });
    } catch (e) {
      print('Error creating game: $e');
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
          children: [
            TTTButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _code));
                },
                text: _code,
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
