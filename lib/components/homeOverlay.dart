import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/popups/gameConnectionPopup.dart';
import 'package:tritac3d/components/popups/gameConnectionPopupHost.dart';
import 'package:tritac3d/components/popups/gameConnectionPopupJoin.dart';
import 'package:tritac3d/components/popups/gameSettingsPopup.dart';
import 'package:tritac3d/components/popups/homeButtonsPopup.dart';
import 'package:tritac3d/utils/appDesign.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class Homeoverlay extends StatefulWidget {
  const Homeoverlay({super.key});

  @override
  State<Homeoverlay> createState() => _HomeoverlayState();
}

enum acPopUpTypes {
  gameButton,
  gameSetting,
  gameConnection,
  gameConnectionHost,
  gameConnectionJoin
}

class _HomeoverlayState extends State<Homeoverlay>
    with TickerProviderStateMixin {
  // Animation Stuff
  acPopUpTypes currentPopUpType = acPopUpTypes.gameButton;
  late AnimationController _acTitle;
  late AnimationController _acGameButton;
  late AnimationController _acGameSetting;
  late AnimationController _acGameConnection;
  late AnimationController _acGameConnectionHost;
  late AnimationController _acGameConnectionJoin;
  late Map<acPopUpTypes, AnimationController> _acControllers;
  late Animation<Offset> _titleAnimation;
  late Animation<Offset> _gameButtonAnimation;
  late Animation<Offset> _gameSettingAnimation;
  late Animation<Offset> _gameConnectionAnimation;
  late Animation<Offset> _gameConnectionHostAnimation;
  late Animation<Offset> _gameConnectionJoinAnimation;
  AnimationController _createAnimationController() {
    return AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
  }

  void _animationControllerInit() {
    // ANIMATION CONTROLLER
    _acTitle = _createAnimationController();
    _acGameButton = _createAnimationController();
    _acGameSetting = _createAnimationController();
    _acGameConnection = _createAnimationController();
    _acGameConnectionHost = _createAnimationController();
    _acGameConnectionJoin = _createAnimationController();
    _acControllers = {
      acPopUpTypes.gameButton: _acGameButton,
      acPopUpTypes.gameSetting: _acGameSetting,
      acPopUpTypes.gameConnection: _acGameConnection,
      acPopUpTypes.gameConnectionHost: _acGameConnectionHost,
      acPopUpTypes.gameConnectionJoin: _acGameConnectionJoin
    };
    // ANIMATIONS
    _titleAnimation =
        Tween<Offset>(begin: Offset(0, -1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _acTitle,
        curve: Curves.easeInOut,
      ),
    );
    _gameButtonAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _acGameButton, curve: Curves.easeInOut),
    );
    _gameSettingAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _acGameSetting, curve: Curves.easeInOut),
    );
    _gameConnectionAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _acGameConnection, curve: Curves.easeInOut),
    );
    _gameConnectionHostAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _acGameConnectionHost, curve: Curves.easeInOut),
    );
    _gameConnectionJoinAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _acGameConnectionJoin, curve: Curves.easeInOut),
    );

    _acTitle.forward();
    _acGameButton.forward();
  }

  @override
  void initState() {
    _animationControllerInit();
    BackButtonInterceptor.add(backInterceptor);

    super.initState();
  }

  @override
  void dispose() {
    _acTitle.dispose();
    _acGameButton.dispose();
    _acGameSetting.dispose();
    _acGameConnection.dispose();
    _acGameConnectionHost.dispose();
    _acGameConnectionJoin.dispose();

    BackButtonInterceptor.remove(backInterceptor);

    super.dispose();
  }

  bool backInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    switchToPopUp(acPopUpTypes.gameButton);

    if (currentPopUpType == acPopUpTypes.gameConnectionHost ||
        currentPopUpType == acPopUpTypes.gameConnectionJoin) {
      switchToPopUp(acPopUpTypes.gameConnection);
    } else if (currentPopUpType == acPopUpTypes.gameConnection) {
      switchToPopUp(acPopUpTypes.gameSetting);
    } else if (currentPopUpType == acPopUpTypes.gameSetting) {
      switchToPopUp(acPopUpTypes.gameButton);
    }

    return true;
  }

  void switchToPopUp(acPopUpTypes popUpType) {
    int reversedCount = _acControllers.length - 1;
    _acControllers.forEach((type, controller) {
      if (type != popUpType) {
        controller.reverse().whenComplete(() {
          reversedCount--;
          if (reversedCount == 0) {
            _acControllers[popUpType]?.forward().whenComplete(() {
              setState(() {
                currentPopUpType = popUpType;
              });
            });
          }
        });
      }
    });
  }

  Widget _buildPopup(acPopUpTypes popUpType) {
    switch (popUpType) {
      case acPopUpTypes.gameButton:
        return SlideTransition(
          position: _gameButtonAnimation,
          child: Homebuttonspopup(switchToPopUp: switchToPopUp),
        );
      case acPopUpTypes.gameSetting:
        return SlideTransition(
          position: _gameSettingAnimation,
          child: Gamesettingspopup(switchToPopUp: switchToPopUp),
        );
      case acPopUpTypes.gameConnection:
        return SlideTransition(
          position: _gameConnectionAnimation,
          child: Gameconnectionpopup(switchToPopUp: switchToPopUp),
        );
      case acPopUpTypes.gameConnectionHost:
        return SlideTransition(
          position: _gameConnectionHostAnimation,
          child: Gameconnectionpopuphost(switchToPopUp: switchToPopUp),
        );
      case acPopUpTypes.gameConnectionJoin:
        return SlideTransition(
          position: _gameConnectionJoinAnimation,
          child: Gameconnectionpopupjoin(switchToPopUp: switchToPopUp),
        );
    }
  }

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
                    fontSize: 68,
                    color: appDesign.fontActive),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildPopup(currentPopUpType),
        ),
      ],
    );
  }
}
