import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:tritac3d/components/popups/gameConnectionPopup.dart';
import 'package:tritac3d/components/popups/gameConnectionPopupHost.dart';
import 'package:tritac3d/components/popups/gameConnectionPopupJoin.dart';
import 'package:tritac3d/components/popups/gameEndPopup.dart';
import 'package:tritac3d/components/popups/gamePlayPopup.dart';
import 'package:tritac3d/components/popups/gameSettingsPopup.dart';
import 'package:tritac3d/components/popups/homeButtonsPopup.dart';
import 'package:tritac3d/components/tttButton.dart';
import 'package:tritac3d/utils/AdHelper.dart';
import 'package:tritac3d/utils/appDesign.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:tritac3d/utils/tttGameController.dart';
import 'package:tritac3d/utils/tttGameManager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
    with TickerProviderStateMixin, WidgetsBindingObserver {
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

  List<RewardedAd> rewardedAds = [];

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
        curve: Curves.easeInOutCubicEmphasized,
      ),
    );
    _gameButtonAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
          parent: _acGameButton, curve: Curves.easeInOutCubicEmphasized),
    );
    _gameSettingAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
          parent: _acGameSetting, curve: Curves.easeInOutCubicEmphasized),
    );
    _gameConnectionAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
          parent: _acGameConnection, curve: Curves.easeInOutCubicEmphasized),
    );
    _gameConnectionHostAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
          parent: _acGameConnectionHost,
          curve: Curves.easeInOutCubicEmphasized),
    );
    _gameConnectionJoinAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
          parent: _acGameConnectionJoin,
          curve: Curves.easeInOutCubicEmphasized),
    );
    _gamePlay = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
          parent: _acGamePlay, curve: Curves.easeInOutCubicEmphasized),
    );
    _gameEnd = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
          parent: _acGameEnd, curve: Curves.easeInOutCubicEmphasized),
    );

    _acTitle.forward();
    _acGameButton.forward();
  }

  @override
  void initState() {
    _animationControllerInit();
    BackButtonInterceptor.add(backInterceptor);
    _loadRewardedAd();
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
    this.tttGameManager?.dispose();
    this.tttGameManager = null;
    tttGameController.dispose();
    super.dispose();
  }

  void _loadRewardedAd() async {
    if (!AdHelpber.isAdAble) {
      return;
    }
    // Preloads 3 Ads
    for (int i = 0; i < (4 - rewardedAds.length); i++) {
      await RewardedAd.load(
          adUnitId: AdHelpber.rewardedAdUnitId,
          request: AdRequest(),
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad) async {
              ad.setImmersiveMode(true);
              setState(() {
                rewardedAds.add(ad);
              });
            },
            onAdFailedToLoad: (LoadAdError error) {
              Connectivity()
                  .onConnectivityChanged
                  .listen((List<ConnectivityResult> results) {
                results.forEach((result) {
                  if (result != ConnectivityResult.none) {
                    _loadRewardedAd();
                    return;
                  }
                });
              });
            },
          ));
    }
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
        _switchToPopUp(acPopUpTypes.gameEnd);
        break;
      case acPopUpTypes.gameEnd:
        _switchToPopUp(acPopUpTypes.gameButton);
        break;
    }

    return true;
  }

  void _switchToPopUp(acPopUpTypes popUpType) {
    if (!(popUpType == acPopUpTypes.gamePlay ||
        popUpType == acPopUpTypes.gameEnd)) {
      this.tttGameManager?.dispose();
      this.tttGameManager = null;
      tttGameController.setBackgroundMode(true);
    } else {
      tttGameController.setBackgroundMode(false);
    }
    if (popUpType == acPopUpTypes.gamePlay) {
      tttGameManager?.startGame();
    }
    if (popUpType == acPopUpTypes.gameEnd) {
      // DISABLE ANY PLAYS
    }

    int reversedCount = _acControllers.length - 1;
    _acControllers.forEach((type, controller) {
      if (type != popUpType) {
        controller.reverse().whenComplete(() async {
          reversedCount--;
          // If all animations are reversed
          if (reversedCount == 0) {
            // Checks if player wants to host a game and rewaredeAd is not null else just let them host
            if (popUpType == acPopUpTypes.gameConnectionHost &&
                rewardedAds.isNotEmpty) {
              // Shows the app
              RewardedAd adFL = rewardedAds.first;
              await adFL.show(onUserEarnedReward: (ad, reward) {});
              // Ad close listener
              adFL.fullScreenContentCallback = FullScreenContentCallback(
                // Ad closed -> let player host game
                onAdDismissedFullScreenContent: (AdWithoutView ad) {
                  adFL.dispose();
                  rewardedAds.remove(adFL);
                  ad.dispose();
                  _acControllers[popUpType]?.forward().whenComplete(() {
                    setState(() {
                      currentPopUpType = popUpType;
                    });
                  });
                },
                onAdFailedToShowFullScreenContent:
                    (AdWithoutView ad, AdError error) {
                  adFL.dispose();
                  rewardedAds.remove(adFL);
                  ad.dispose();
                  _loadRewardedAd();
                  _acControllers[popUpType]?.forward().whenComplete(() {
                    setState(() {
                      currentPopUpType = popUpType;
                    });
                  });
                },
              );
              _loadRewardedAd();
            } else {
              _acControllers[popUpType]?.forward().whenComplete(() {
                setState(() {
                  currentPopUpType = popUpType;
                });
              });
            }
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
    final appDesign = Provider.of<Appdesign>(context, listen: false);
    this.tttGameManager = gameManager;

    gameManager?.setGameController(tttGameController);
    gameManager?.setAppDesign(appDesign);

    tttGameManager?.setOnGameEnd(() {
      if (tttGameManager!.isOpenForRevenge()) {
        _switchToPopUp(acPopUpTypes.gameEnd);
      } else {
        _switchToPopUp(acPopUpTypes.gameButton);
      }
    });
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
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16),
              child: Text(
                "TriTac3D",
                style: TextStyle(
                    letterSpacing: 4,
                    fontFamily: 'Jersey10',
                    fontSize: 66,
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
        kIsWeb && currentPopUpType != acPopUpTypes.gameButton
            ? Positioned(
                top: 0,
                left: 0,
                child: TTTButton(
                  // height: 200,
                  // width: 200,
                  margin: EdgeInsets.all(20),
                  onPressed: () {
                    backInterceptor(true, RouteInfo());
                  },
                  type: TTTBType.secondary,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  child: SvgPicture.asset(
                    "assets/icons/icon_arrowback.svg",
                    colorFilter:
                        ColorFilter.mode(appDesign.fontActive, BlendMode.srcIn),
                    height: 44,
                  ),
                ),
              )
            : SizedBox(height: 0, width: 0)
      ],
    );
  }
}
