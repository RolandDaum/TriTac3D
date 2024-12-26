import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/tttStack.dart';
import 'package:tritac3d/utils/appDesign.dart';

// ignore: must_be_immutable
class SHome extends StatefulWidget {
  const SHome({super.key});

  @override
  State<SHome> createState() => _SHomeState();
}

class _SHomeState extends State<SHome> {
  final GlobalKey<TTTStackState> _key = GlobalKey<TTTStackState>();
  double rotationValue = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appDesign = Provider.of<Appdesign>(context);
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          color: appDesign.primaryBackground,
        ),
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            _key.currentState!.setRotation(rotationValue += details.delta.dx);
          },
          child: TTTStack(
            key: _key,
          ),
        ),
      ],
    );
  }
}
