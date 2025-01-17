import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tritac3d/utils/WebRTCConnectionManager.dart';
import 'package:tritac3d/utils/tttGameController.dart';
import 'package:tritac3d/utils/tttGameManager.dart';
import 'package:tritac3d/utils/tttGameSettings.dart';
import 'package:vector_math/vector_math.dart';

// TODO: If player has turn and is on game end screen, hes still able to play
class TTTGameManagerRTC implements TTTGameManager {
  late WebRTCConnectionManager _webRTCConnectionManager;
  TTTGameController? _tttGameController;
  VoidCallback? _gameEnd;
  bool exchangedSettings = false;
  bool ownTurn = false;
  int _moveCount = 0;

  TTTGameManagerRTC(this._webRTCConnectionManager) {
    _webRTCConnectionManager.connectionFailed = () {
      _gameEnd?.call();
    };
  }

  void initConnectionEventListener() {
    // DATA CONNECTION EVENT LISTENER //

    _webRTCConnectionManager.setOnData((data) {
      Map<String, dynamic> mData = jsonDecode(data);
      if (mData['type'] == null) {
        return;
      }
      switch (mData['type']) {
        case 'settings':
          TTTGameSettings gs = _tttGameController!.getGameSettings();
          print((mData['settings']['gameFieldSize'] as int).toString() +
              "  --  " +
              gs.getGFSize().toString());
          print((mData['settings']['requiredWins'] as int).toString() +
              "  --  " +
              gs.getRequiredWins().toString());
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
            } else if (_webRTCConnectionManager.isHost()) {
              (defaultTargetPlatform == TargetPlatform.iOS ||
                      defaultTargetPlatform == TargetPlatform.android)
                  ? Fluttertoast.showToast(
                      msg: "You move first", gravity: ToastGravity.BOTTOM)
                  : null;
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
            gs.setGFSize(GFS);

            int REQW = gs.getRequiredWins() +
                (((mData['settings']['requiredWins'] as int) -
                            gs.getRequiredWins()) /
                        2)
                    .floor();

            gs.setRequiredWins(REQW);

            // Exchange
            _webRTCConnectionManager
                .sendData(_tttGameController!.getGameSettings().toJsonString());
          }
          break;
        case 'startSignal':
          if (!exchangedSettings) {
            return;
          }
          (defaultTargetPlatform == TargetPlatform.iOS ||
                  defaultTargetPlatform == TargetPlatform.android)
              ? Fluttertoast.showToast(
                  msg: "You move first", gravity: ToastGravity.BOTTOM)
              : null;
          ownTurn = true;
          break;
        case 'move':
          if (!exchangedSettings) {
            return;
          }
          _tttGameController?.setMove(
              Vector3(
                  (mData['move']['x'] as int).toDouble(),
                  (mData['move']['y'] as int).toDouble(),
                  (mData['move']['z'] as int).toDouble()),
              _tttGameController!.getLastField()?.getInvertedState() ??
                  (Random().nextBool() ? TTTFS.cricle : TTTFS.cross));
          _tttGameController!.highlightWins(
              _tttGameController!.getLastField()!.getInvertedState());
          _tttGameController!
              .deHighlightWins(_tttGameController!.getLastField()!.getState());

          if (_tttGameController!.getWinsO() >=
              _tttGameController!.getGameSettings().getRequiredWins()) {
            _tttGameController!.setOnRegisteredMoveEvent((_) {});
            _tttGameController!.deHighlightWins(TTTFS.cross);
            _gameEnd?.call();
          } else if (_tttGameController!.getWinsX() >=
              _tttGameController!.getGameSettings().getRequiredWins()) {
            _tttGameController!.setOnRegisteredMoveEvent((_) {});
            _tttGameController!.deHighlightWins(TTTFS.cricle);
            _gameEnd?.call();
          } else if (_moveCount >=
              pow(_tttGameController!.getGameSettings().getGFSize(), 3)
                  .toInt()) {
            _tttGameController!.setOnRegisteredMoveEvent((_) {});
            _gameEnd?.call();
          } else {
            (defaultTargetPlatform == TargetPlatform.iOS ||
                    defaultTargetPlatform == TargetPlatform.android)
                ? Fluttertoast.showToast(
                    msg: "Opponed played", gravity: ToastGravity.BOTTOM)
                : null;
            ownTurn = true;
          }

          break;
        case 'reset':
          _moveCount = 0;
          _tttGameController?.clearGame();
          break;
        default:
          throw Exception(
              'Unknown message type or missformatted data: ${mData.toString()}');
      }
    });

    _tttGameController!.setOnRegisteredMoveEvent((move) {
      print("OWN TURN ?? " + ownTurn.toString());
      if (!ownTurn) {
        return;
      }

      if (_tttGameController!.getField(move).getState() != TTTFS.empty) {
        return;
      }
      _moveCount++;
      _tttGameController?.setMove(
          move,
          _tttGameController!.getLastField()?.getInvertedState() ??
              (Random().nextBool() ? TTTFS.cricle : TTTFS.cross));

      _tttGameController!
          .highlightWins(_tttGameController!.getLastField()!.getState());
      _tttGameController!.deHighlightWins(
          _tttGameController!.getLastField()!.getInvertedState());

      if (_tttGameController!.getWinsO() >=
          _tttGameController!.getGameSettings().getRequiredWins()) {
        _tttGameController!.setOnRegisteredMoveEvent((_) {});
        _tttGameController!.deHighlightWins(TTTFS.cross);
        _gameEnd?.call();
      } else if (_tttGameController!.getWinsX() >=
          _tttGameController!.getGameSettings().getRequiredWins()) {
        _tttGameController!.setOnRegisteredMoveEvent((_) {});
        _tttGameController!.deHighlightWins(TTTFS.cricle);

        _gameEnd?.call();
      } else if (_moveCount >=
          pow(_tttGameController!.getGameSettings().getGFSize(), 3).toInt()) {
        _tttGameController!.setOnRegisteredMoveEvent((_) {});

        _gameEnd?.call();
      }

      _webRTCConnectionManager.sendData(jsonEncode({
        'type': 'move',
        'move': {'x': move.x.toInt(), 'y': move.y.toInt(), 'z': move.z.toInt()}
      }));
      ownTurn = false;
    });
  }

  @override
  void startGame() {
    _webRTCConnectionManager.sendData(jsonEncode({'type': 'reset'}));
    _moveCount = 0;
    _tttGameController!.clearGame();
    initConnectionEventListener();
    // GAME SETTINGS DATA EXCHANGE
    _webRTCConnectionManager
        .sendData(_tttGameController!.getGameSettings().toJsonString());
  }

  @override
  void setGameController(controller) {
    this._tttGameController = controller;
  }

  @override
  void dispose() async {
    await _webRTCConnectionManager.dispose();
    // _tttGameController?.setBackgroundMode(true);
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
