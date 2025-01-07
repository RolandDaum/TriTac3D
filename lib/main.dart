import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/screens/s_main.dart';
import 'package:tritac3d/utils/appDesign.dart';
import 'package:tritac3d/firebase_options.dart';
import 'package:tritac3d/utils/tttGameController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider<Appdesign>(
            create: (context) => Appdesign(),
          ),
          ChangeNotifierProvider<TTTGameController>(
            create: (context) => TTTGameController(),
          ),
        ],
        child: Directionality(
            textDirection: TextDirection.ltr,
            child: DefaultTextStyle(
                style: TextStyle(
                  fontFamily: "Inter",
                ),
                child: SMain()))),
  );
}
