import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/homeOverlay.dart';
import 'package:tritac3d/utils/appDesign.dart';
import 'package:firebase_database/firebase_database.dart';

class Gameconnectionpopuphost extends StatefulWidget {
  final Function(acPopUpTypes type) switchToPopUp;

  const Gameconnectionpopuphost({super.key, required this.switchToPopUp});

  @override
  State<Gameconnectionpopuphost> createState() =>
      _GameconnectionpopuphostState();
}

class _GameconnectionpopuphostState extends State<Gameconnectionpopuphost> {
  @override
  void initState() {
    // DO not run this (createGame()) on init, cause it will the run on the beginning of the app, even though it is not needed
    super.initState();
  }

  String generateGameCode() {
    return "CJHFIK";
  }

  void createGame() {
    final DatabaseReference database = FirebaseDatabase.instance.ref();
    database.child('ABCD').push().set({
      'status': 'created',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }).then((_) {
      print('Game created successfully.');
    }).catchError((error) {
      print('Failed to create game: $error');
    });

    database.child('games').onChildChanged.listen((event) {
      print('Game updated: ${event.snapshot.value}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final Appdesign appDesign = Provider.of<Appdesign>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: appDesign.onBackgroundContainer,
          borderRadius: BorderRadius.circular(20)),
      child: TweenAnimationBuilder<int>(
        tween: IntTween(begin: 0, end: 3),
        duration: Duration(seconds: 1),
        builder: (context, value, child) {
          String dots = '.' * value;
          return Text("Game Connection Popup Host$dots");
        },
        onEnd: () {
          setState(() {});
        },
      ),
    );
  }
}
