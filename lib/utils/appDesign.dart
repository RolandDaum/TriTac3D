import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Appdesign with ChangeNotifier {
  bool darkmode = true;

  late Color primaryBackground;
  late Color onBackgroundContainer;
  late Color fontActive;
  late Color fontInactive;
  late Color accentGreen;
  late Color accentBlue;
  late Color accentYellow;
  late Color accentPink;

  double crossCircleStrokeWidth = 3;

  Appdesign() {
    init();
  }
  Appdesign.styleMode(this.darkmode) {
    init();
  }

  void init() {
    if (darkmode) {
      setDarkColor();
    } else {
      setLightColor();
    }
    setSystemUI();
  }

  void setDarkColor() {
    primaryBackground = const Color(0xFF0e1011);
    onBackgroundContainer = const Color(0xFF17191a);
    fontActive = const Color(0xFFFFFFFF);
    fontInactive = const Color(0xFF6B6D6F);
    accentGreen = const Color(0xFF27AD60);
    accentBlue = const Color(0xFF6089BD);
    accentYellow = const Color(0xFFCB9B6D);
    accentPink = const Color(0xFF8D5194);
  }

  void setLightColor() {
    primaryBackground = const Color(0xFFFFFFFF);
    onBackgroundContainer = const Color(0xFFE0E0E0);
    fontActive = const Color(0xFF000000);
    fontInactive = const Color(0xFF6B6D6F);
    accentGreen = const Color(0xFF27AD60);
    accentBlue = const Color(0xFF6089BD);
    accentYellow = const Color(0xFFCB9B6D);
    accentPink = const Color(0xFF8D5194);
  }

  void toggleDarkMode() {
    if (darkmode) {
      setDarkColor();
    } else {
      setLightColor();
    }
    setSystemUI();
    notifyListeners();
    darkmode = !darkmode;
  }

  void setSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: darkmode ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: primaryBackground,
      systemNavigationBarIconBrightness:
          darkmode ? Brightness.light : Brightness.dark,
    ));
  }
}
