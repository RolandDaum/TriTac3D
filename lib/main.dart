import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/tttGrid.dart';
import 'package:tritac3d/components/tttStack.dart';
import 'package:tritac3d/screens/s_home.dart';
import 'package:tritac3d/utils/appDesign.dart';

void main() async {
  Appdesign appdesign = Appdesign();
  runApp(ChangeNotifierProvider<Appdesign>(
    create: (context) => appdesign,
    child: Consumer<Appdesign>(builder: (context, appDesign, child) {
      return const Directionality(
          textDirection: TextDirection.ltr, child: SHome());
    }),
  ));
}
