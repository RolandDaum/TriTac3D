import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/gameConnectionPopup.dart';
import 'package:tritac3d/components/gameSettingsPopup.dart';
import 'package:tritac3d/components/tttButton.dart';
import 'package:tritac3d/utils/appDesign.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class Homeoverlay extends StatefulWidget {
  const Homeoverlay({super.key});

  @override
  State<Homeoverlay> createState() => _HomeoverlayState();
}

class _HomeoverlayState extends State<Homeoverlay>
    with TickerProviderStateMixin {
  late AnimationController _acTitle;
  late AnimationController _acGameButton;
  late AnimationController _acGameSetting;
  late AnimationController _acGameConnection;
  late Animation<Offset> _titleAnimation;
  late Animation<Offset> _gameButtonAnimation;
  late Animation<Offset> _gameSettingAnimation;
  late Animation<Offset> _gameConnectionAnimation;

  @override
  void initState() {
    super.initState();

    // ANIMATION CONTROLLER
    _acTitle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _acGameButton = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _acGameSetting = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _acGameConnection = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    // ANIMATIONS
    _titleAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _acTitle,
        curve: Curves.easeInOut,
      ),
    );
    _gameButtonAnimation = Tween<Offset>(
      begin: Offset(0, 1), // Startposition außerhalb des Bildschirms (unten)
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _acGameButton,
        curve: Curves.easeInOut,
      ),
    );
    _gameSettingAnimation = Tween<Offset>(
      begin: Offset(0, 1), // Startposition außerhalb des Bildschirms (unten)
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _acGameSetting,
        curve: Curves.easeInOut,
      ),
    );
    _gameConnectionAnimation = Tween<Offset>(
      begin: Offset(0, 1), // Startposition außerhalb des Bildschirms (unten)
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _acGameConnection,
        curve: Curves.easeInOut,
      ),
    );

    _acTitle.forward();
    _acGameButton.forward();

    BackButtonInterceptor.add(backInterceptor);
  }

  @override
  void dispose() {
    _acTitle.dispose();
    _acGameButton.dispose();
    _acGameSetting.dispose();
    BackButtonInterceptor.remove(backInterceptor);

    super.dispose();
  }

  bool backInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    _acGameSetting.reverse().whenComplete(() {
      if (!_acGameSetting.isAnimating) {
        _acGameButton.forward();
      }
    });
    _acGameConnection.reverse().whenComplete(() {
      if (!_acGameSetting.isAnimating) {
        _acGameButton.forward();
      }
    });

    return true;
  }
  // TODO: Add custome Overlay screen part show methods

  @override
  Widget build(BuildContext context) {
    final appDesign = Provider.of<Appdesign>(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: appDesign.primaryBackground.withAlpha((255 * 0.2).toInt()),
          ),
        ),
        Positioned(
          top: 0,
          child: SlideTransition(
            position: _titleAnimation,
            child: Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top + 24),
              child: Text(
                "TriTac3D",
                style: TextStyle(
                    letterSpacing: 4,
                    fontFamily: 'Jersey10',
                    fontSize: 56,
                    color: appDesign.fontActive),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SlideTransition(
            position: _gameButtonAnimation,
            child: Column(
              children: [
                TTTButton(
                  text: "P L A Y",
                  width: double.infinity,
                  fontSize: 60,
                  margin: EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  onPressed: () {
                    _acGameButton.reverse().whenComplete(() {
                      _acGameSetting.forward();
                    });
                  },
                ),
                TTTButton(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  type: TTTBType.secondary,
                  onPressed: () {
                    _acGameButton.reverse().whenComplete(() {
                      _acGameConnection.forward();
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/icon_internetsearch.svg",
                        colorFilter: ColorFilter.mode(
                            appDesign.fontActive, BlendMode.srcIn),
                        height: 44,
                      ),
                      SizedBox(width: 20),
                      Text("SEARCH",
                          style: appDesign.TTTButtonTxtStyle.copyWith(
                              fontSize: 34))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _gameSettingAnimation,
              child: Gamesettingspopup(),
            )),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _gameConnectionAnimation,
              child: Gameconnectionpopup(),
            ))
      ],
    );
  }
}
