import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class Appdesign with ChangeNotifier {
  bool darkmode = true;
  late bool hasVibrator = false;

  late Color primaryBackground;
  late Color onBackgroundContainer;
  late Color fontActive;
  late Color fontInactive;
  late Color accentGreen;
  late Color accentBlue;
  late Color accentYellow;
  late Color accentPink;
  late Color border;

  double crossCircleStrokeWidth = 3;
  double gridDistance = 150;
  double layerWidth = 300;
  int backgroundModeRotationTime = 40;

  late TextStyle TTTButtonTxtStyle;

  EdgeInsets popupMargin =
      EdgeInsets.symmetric(horizontal: 40).copyWith(bottom: 20);
  EdgeInsets popupContainerPadding =
      EdgeInsets.symmetric(vertical: 20, horizontal: 20);
  BorderRadius popupContainerRadius = BorderRadius.circular(20);

  void vibrateMovement() async {
    if (!hasVibrator) {
      return;
    }
    Vibration.vibrate(duration: 50, amplitude: 95);
  }

  void vibrateNotify() async {
    if (!hasVibrator) {
      return;
    }
    await Vibration.vibrate(duration: 50, amplitude: 95);
    await Future.delayed(Duration(milliseconds: 100));
    await Vibration.vibrate(duration: 50, amplitude: 95);
  }

  Appdesign() {
    init();
  }
  Appdesign.styleMode(this.darkmode) {
    init();
  }

  Future<void> init() async {
    if (darkmode) {
      setDarkColor();
    } else {
      setLightColor();
    }
    setSystemUI();

    TTTButtonTxtStyle = TextStyle(
        fontFamily: "Inter",
        color: fontActive,
        fontWeight: FontWeight.w900,
        fontSize: 40);

    /// This mackes the app stuck on the splash screen
    // WidgetsBinding.instance.platformDispatcher.onMetricsChanged = () {
    //   double screenWidth = WidgetsBinding
    //           .instance.platformDispatcher.views.first.physicalSize.width /
    //       PlatformDispatcher.instance.views.first.devicePixelRatio;
    //   double tmpLayerWidth = ((screenWidth * sqrt(2)) / 2) - 20;
    //   if (tmpLayerWidth > 300 || tmpLayerWidth <= 0) {
    //     layerWidth = 300;
    //   } else if (layerWidth != tmpLayerWidth) {
    //     layerWidth = tmpLayerWidth;
    //     notifyListeners();
    //   }
    // };
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double screenWidth = WidgetsBinding
              .instance.platformDispatcher.views.first.physicalSize.width /
          PlatformDispatcher.instance.views.first.devicePixelRatio;
      double tmpLayerWidth = ((screenWidth * sqrt(2)) / 2) - 20;
      if (tmpLayerWidth > 300 || tmpLayerWidth <= 0) {
        layerWidth = 300;
      } else if (layerWidth != tmpLayerWidth) {
        layerWidth = tmpLayerWidth;

        notifyListeners();
      }
    });

    hasVibrator = await Vibration.hasVibrator() ?? false;
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
    border = const Color(0xFF2e2e2e);
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
    border = const Color(0xFFE0E0E0);
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

  void setStatusbarColor(Color color) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: color,
    ));
  }
}
