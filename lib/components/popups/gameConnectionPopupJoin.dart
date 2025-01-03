import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/homeOverlay.dart';
import 'package:tritac3d/components/scrollSelector.dart';
import 'package:tritac3d/components/tttButton.dart';
import 'package:tritac3d/utils/appDesign.dart';

class Gameconnectionpopupjoin extends StatelessWidget {
  final Function(acPopUpTypes type) switchToPopUp;

  const Gameconnectionpopupjoin({super.key, required this.switchToPopUp});

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
          _gameCodeSelector(),
          SizedBox(
            height: 20,
          ),
          TTTButton(
            text: "CONTINUE",
          )
        ],
      ),
    );
  }
}

class _gameCodeSelector extends StatefulWidget {
  const _gameCodeSelector({super.key});

  @override
  State<_gameCodeSelector> createState() => _gameCodeSelectorState();
}

class _gameCodeSelectorState extends State<_gameCodeSelector> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ScrollSelector(
          onScroll: (num) {},
        ),
        _vertSeperator(),
        ScrollSelector(
          onScroll: (num) {},
        ),
        _vertSeperator(),
        ScrollSelector(
          onScroll: (num) {},
        ),
        _vertSeperator(),
        ScrollSelector(
          onScroll: (num) {},
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
