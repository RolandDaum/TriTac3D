import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/tttButton.dart';
import 'package:tritac3d/utils/appDesign.dart';

class Gameconnectionpopup extends StatefulWidget {
  const Gameconnectionpopup({super.key});

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
            text: "host",
          ),
          SizedBox(height: 20),
          TTTButton(text: "join")
        ],
      ),
    );
  }
}
