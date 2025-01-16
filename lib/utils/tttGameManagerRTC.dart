import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:tritac3d/utils/WebRTCConnectionManager.dart';
import 'package:tritac3d/utils/tttGameController.dart';
import 'package:tritac3d/utils/tttGameManager.dart';
import 'package:tritac3d/utils/tttGameSettings.dart';

class TTTGameManagerRTC implements TTTGameManager {
  late WebRTCConnectionManager _webRTCConnectionManager;
  TTTGameController? _tttGameController;
  VoidCallback? _gameEnd;
  bool exchangedSettings = false;
  bool ownTurn = false;

  TTTGameManagerRTC(this._webRTCConnectionManager) {
    _webRTCConnectionManager.connectionFailed = () {
      _gameEnd?.call();
    };
  }

  @override
  void startGame() {
    _tttGameController!.setBackgroundMode(false);

    // GAME SETTINGS DATA EXCHANGE
    _webRTCConnectionManager
        .sendData(_tttGameController!.getGameSettings().toJsonString());

    _webRTCConnectionManager.setOnData((data) {
      Map<String, dynamic> mData = jsonDecode(data);
      if (mData['type'] == null) {
        return;
      }
      switch (mData['type']) {
        case 'settings':
          TTTGameSettings gs = _tttGameController!.getGameSettings();

          // Check for identical settings
          if ((mData['settings']['gameFieldSize'] as int) == gs.getGFSize() &&
              (mData['settings']['requiredWins'] as int) ==
                  gs.getRequiredWins()) {
            exchangedSettings = true;

            //
            if (_webRTCConnectionManager.isHost() && Random().nextBool()) {
              ownTurn = false;
              _webRTCConnectionManager
                  .sendData(jsonEncode({'type': 'startSignal'}));
            } else {
              moveNotification('You move first');
              ownTurn = true;
            }
          }

          // Settings not identical -> merge and reexchange
          if (!exchangedSettings) {
            // Merge settings
            int GFS = gs.getGFSize() +
                (((mData['settings']['gameFieldSize'] as int) -
                            gs.getGFSize()) /
                        2)
                    .floor();

            int REQW = gs.getRequiredWins() +
                (((mData['settings']['requiredWins'] as int) -
                            gs.getRequiredWins()) /
                        2)
                    .floor();

            gs.setGFSize(GFS);
            gs.setRequiredWins(REQW);

            // Exchange
            _webRTCConnectionManager
                .sendData(_tttGameController!.getGameSettings().toJsonString());
          }
          break;
        case 'startSignal':
          moveNotification('You move first');
          ownTurn = true;
          break;
        case 'move':
          moveNotification('Opponed played field x y z');
          break;
        default:
          break;
      }
    });

    // On move
    _tttGameController!.setOnRegisteredMoveEvent((move) {
      if (!ownTurn) {
        return;
      }

      // TODO: Send move
    });
  }

  void moveNotification(String message) {
    Fluttertoast.showToast(msg: message, gravity: ToastGravity.BOTTOM);
  }

  @override
  void setGameController(controller) {
    this._tttGameController = controller;
  }

  @override
  void dispose() async {
    await _webRTCConnectionManager.dispose();
    _tttGameController?.setBackgroundMode(true);
  }

  @override
  void setOnGameEnd(VoidCallback onGameEnd) {
    this._gameEnd = onGameEnd;
  }

  @override
  bool isOpenForRevenge() {
    if (_webRTCConnectionManager.isConnected()) {
      return true;
    } else {
      return false;
    }
  }
}
