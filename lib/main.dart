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
  Appdesign appdesign = Appdesign();
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider<Appdesign>(
            create: (context) => appdesign,
          ),
          ChangeNotifierProvider<TTTGameController>(
            create: (context) => TTTGameController(appdesign),
          ),
        ],
        child: Directionality(
            textDirection: TextDirection.ltr,
            child: DefaultTextStyle(
                style:
                    TextStyle(fontFamily: "Inter", color: appdesign.fontActive),
                child: SMain()))),
  );
}
