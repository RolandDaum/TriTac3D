import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/popups/gameConnectionPopup.dart';
import 'package:tritac3d/components/popups/gameConnectionPopupHost.dart';
import 'package:tritac3d/components/popups/gameConnectionPopupJoin.dart';
import 'package:tritac3d/components/popups/gameEndPopup.dart';
import 'package:tritac3d/components/popups/gamePlayPopup.dart';
import 'package:tritac3d/components/popups/gameSettingsPopup.dart';
import 'package:tritac3d/components/popups/homeButtonsPopup.dart';
import 'package:tritac3d/utils/appDesign.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:tritac3d/utils/tttGameController.dart';
import 'package:tritac3d/utils/tttGameManager.dart';

class GameOverlay extends StatefulWidget {
  /// This Widget will manage all the different App/Game overlays
  GameOverlay({super.key});

  @override
  State<GameOverlay> createState() => _GameOverlayState();
}

enum acPopUpTypes {
  gameButton,
  gameSetting,
  gameConnection,
  gameConnectionHost,
  gameConnectionJoin,
  gamePlay,
  gameEnd
}

class _GameOverlayState extends State<GameOverlay>
    with TickerProviderStateMixin {
  // Animation Stuff
  acPopUpTypes currentPopUpType = acPopUpTypes.gameButton;

  late AnimationController _acTitle;
  late AnimationController _acGameButton;
  late AnimationController _acGameSetting;
  late AnimationController _acGameConnection;
  late AnimationController _acGameConnectionHost;
  late AnimationController _acGameConnectionJoin;
  late AnimationController _acGamePlay;
  late AnimationController _acGameEnd;

  late Map<acPopUpTypes, AnimationController> _acControllers;
  late Animation<Offset> _titleAnimation;
  late Animation<Offset> _gameButtonAnimation;
  late Animation<Offset> _gameSettingAnimation;
  late Animation<Offset> _gameConnectionAnimation;
  late Animation<Offset> _gameConnectionHostAnimation;
  late Animation<Offset> _gameConnectionJoinAnimation;
  late Animation<Offset> _gamePlay;
  late Animation<Offset> _gameEnd;

  TTTGameManager? tttGameManager;
  late TTTGameController tttGameController;

  void _animationControllerInit() {
    AnimationController Function() _createAnimationController = () {
      return AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 150),
      );
    };
    // ANIMATION CONTROLLER
    _acTitle = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _acGameButton = _createAnimationController();
    _acGameSetting = _createAnimationController();
    _acGameConnection = _createAnimationController();
    _acGameConnectionHost = _createAnimationController();
    _acGameConnectionJoin = _createAnimationController();
    _acGamePlay = _createAnimationController();
    _acGameEnd = _createAnimationController();
    _acControllers = {
      acPopUpTypes.gameButton: _acGameButton,
      acPopUpTypes.gameSetting: _acGameSetting,
      acPopUpTypes.gameConnection: _acGameConnection,
      acPopUpTypes.gameConnectionHost: _acGameConnectionHost,
      acPopUpTypes.gameConnectionJoin: _acGameConnectionJoin,
      acPopUpTypes.gamePlay: _acGamePlay,
      acPopUpTypes.gameEnd: _acGameEnd
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
      CurvedAnimation(parent: _acGameButton, curve: Curves.easeInOutQuart),
    );
    _gameSettingAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _acGameSetting, curve: Curves.easeInOutQuart),
    );
    _gameConnectionAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _acGameConnection, curve: Curves.easeInOutQuart),
    );
    _gameConnectionHostAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
          parent: _acGameConnectionHost, curve: Curves.easeInOutQuart),
    );
    _gameConnectionJoinAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
          parent: _acGameConnectionJoin, curve: Curves.easeInOutQuart),
    );
    _gamePlay = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _acGamePlay, curve: Curves.easeInOutQuart),
    );
    _gameEnd = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _acGameEnd, curve: Curves.easeInOutQuart),
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
  void didChangeDependencies() {
    tttGameController = Provider.of<TTTGameController>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _acControllers.forEach((_, controller) => controller.dispose());

    BackButtonInterceptor.remove(backInterceptor);

    super.dispose();
  }

  /// Manages overlay navigation stuff
  bool backInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    switch (currentPopUpType) {
      case acPopUpTypes.gameButton:
        return false;
      case acPopUpTypes.gameSetting:
        _switchToPopUp(acPopUpTypes.gameButton);
        break;
      case acPopUpTypes.gameConnection:
        _switchToPopUp(acPopUpTypes.gameSetting);
        break;
      case acPopUpTypes.gameConnectionHost:
        _switchToPopUp(acPopUpTypes.gameConnection);
        break;
      case acPopUpTypes.gameConnectionJoin:
        _switchToPopUp(acPopUpTypes.gameConnection);
        break;
      case acPopUpTypes.gamePlay:
        // tttGameManager?.dispose();
        // this.tttGameManager = null;
        _switchToPopUp(acPopUpTypes.gameButton);
        break;
      case acPopUpTypes.gameEnd:
        // tttGameManager?.dispose();
        // this.tttGameManager = null;
        _switchToPopUp(acPopUpTypes.gameButton);
        break;
    }

    return true;
  }

  void _switchToPopUp(acPopUpTypes popUpType) {
    if (popUpType != acPopUpTypes.gamePlay &&
        popUpType != acPopUpTypes.gameEnd) {
      this.tttGameManager?.dispose();
      this.tttGameManager = null;
    }
    if (popUpType == acPopUpTypes.gamePlay) {
      tttGameManager?.startGame();
    }

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
          child: Homebuttonspopup(switchToPopUp: _switchToPopUp),
        );
      case acPopUpTypes.gameSetting:
        return SlideTransition(
          position: _gameSettingAnimation,
          child: Gamesettingspopup(
            switchToPopUp: _switchToPopUp,
            onTTTGameManagerCreation: (gameManager) =>
                _prepareTTTGameManager(gameManager),
          ),
        );
      case acPopUpTypes.gameConnection:
        return SlideTransition(
          position: _gameConnectionAnimation,
          child: Gameconnectionpopup(switchToPopUp: _switchToPopUp),
        );
      case acPopUpTypes.gameConnectionHost:
        return SlideTransition(
          position: _gameConnectionHostAnimation,
          child: Gameconnectionpopuphost(
            switchToPopUp: _switchToPopUp,
            onTTTGameManagerCreation: (gameManager) =>
                _prepareTTTGameManager(gameManager),
          ),
        );
      case acPopUpTypes.gameConnectionJoin:
        return SlideTransition(
          position: _gameConnectionJoinAnimation,
          child: Gameconnectionpopupjoin(
            switchToPopUp: _switchToPopUp,
            onTTTGameManagerCreation: (gameManager) =>
                _prepareTTTGameManager(gameManager),
          ),
        );
      case acPopUpTypes.gamePlay:
        return SlideTransition(
          position: _gamePlay,
          child: Gameplaypopup(
            switchToPopUp: _switchToPopUp,
          ),
        );
      case acPopUpTypes.gameEnd:
        return SlideTransition(
          position: _gameEnd,
          child: Gameendpopup(
            switchToPopUp: _switchToPopUp,
          ),
        );
    }
  }

  void _prepareTTTGameManager(TTTGameManager? gameManager) {
    this.tttGameManager = gameManager;

    gameManager?.setGameController(tttGameController);

    tttGameManager?.setOnGameEnd(() {
      _switchToPopUp(acPopUpTypes.gameEnd);
    });

    // tttGameManager?.startGame();
  }

  @override
  Widget build(BuildContext context) {
    final appDesign = Provider.of<Appdesign>(context),
        gameController = Provider.of<TTTGameController>(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        gameController.getBackgroundMode()
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: appDesign.primaryBackground
                      .withAlpha((255 * 0.2).toInt()),
                ),
              )
            : SizedBox.expand(),
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
