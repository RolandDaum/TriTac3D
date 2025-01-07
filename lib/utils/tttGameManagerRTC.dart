import 'dart:ui';

import 'package:tritac3d/utils/WebRTCConnectionManager.dart';
import 'package:tritac3d/utils/tttGameController.dart';
import 'package:tritac3d/utils/tttGameManager.dart';

class TTTGameManagerRTC implements TTTGameManager {
  late WebRTCConnectionManager _webRTCConnectionManager;
  TTTGameController? _tttGameController;
  VoidCallback? _gameEnd;

  TTTGameManagerRTC(this._webRTCConnectionManager) {
    _webRTCConnectionManager.connectionFailed = () {
      dispose();
    };
  }

  @override
  void startGame() {
    print("STARTING GAME");
    print("game controller null?: " + (_tttGameController == null).toString());
    _tttGameController?.setBackgroundMode(false);
  }

  @override
  void setGameController(controller) {
    this._tttGameController = controller;
  }

  @override
  void dispose() {
    _webRTCConnectionManager.dispose();
    _tttGameController?.setBackgroundMode(true);
    _gameEnd?.call();
  }

  @override
  void setOnGameEnd(VoidCallback onGameEnd) {
    this._gameEnd = onGameEnd;
  }
}
