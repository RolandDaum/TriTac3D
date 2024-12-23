import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/tttField.dart';
import 'package:tritac3d/components/tttGrid.dart';
import 'package:tritac3d/components/tttStack.dart';
import 'package:tritac3d/utils/appDesign.dart';

// ignore: must_be_immutable
class SHome extends StatefulWidget {
  const SHome({super.key});

  @override
  State<SHome> createState() => _SHomeState();
}

class _SHomeState extends State<SHome> {
  @override
  Widget build(BuildContext context) {
    final appDesign = Provider.of<Appdesign>(context);
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          color: appDesign.primaryBackground,
          // child: FlutterLogo(size: 100),
        ),
        const TTTStack()
      ],
    );
    // return Container(
    //     height: double.infinity,
    //     width: double.infinity,
    //     color: appDesign.primaryBackground,
    //     child: Transform(
    //         origin: const Offset(
    //             -150, -150), // Grid Height/Widt devided by 2 times -1
    //         alignment: Alignment.center,
    //         transform: Matrix4.rotationX((pi / 4) * 1.6)
    //           ..rotateZ(pi / 4), // X Rotation factor < 2
    //         child: GridView.builder(
    //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //               crossAxisCount: 3,
    //               crossAxisSpacing: 8.0,
    //               mainAxisSpacing: 8.0,
    //             ),
    //             itemCount: 9,
    //             itemBuilder: (context, index) {
    //               return Container(
    //                 decoration: BoxDecoration(
    //                   color: appDesign.onBackgroundContainer,
    //                   borderRadius: BorderRadius.circular(10),
    //                 ),
    //                 child: Center(
    //                   child: TextButton(
    //                     onPressed: () {
    //                       appDesign.toggleDarkMode();
    //                     },
    //                     child: Text('Item ${index + 1}',
    //                         style: TextStyle(color: appDesign.fontActive)),
    //                   ),
    //                 ),
    //               );
    //             })));
  }
}
