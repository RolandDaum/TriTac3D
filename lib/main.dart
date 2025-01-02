import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/screens/s_main.dart';
import 'package:tritac3d/utils/appDesign.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider<Appdesign>(
      create: (context) => Appdesign(),
      child: Consumer<Appdesign>(builder: (context, appDesign, child) {
        return const Directionality(
            textDirection: TextDirection.ltr, child: SMain());
      }),
    ),
  );
}
