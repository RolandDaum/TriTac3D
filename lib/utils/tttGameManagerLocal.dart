import 'dart:math';
import 'dart:ui';

import 'package:tritac3d/components/tttField.dart';
import 'package:tritac3d/utils/tttGameController.dart';
import 'package:tritac3d/utils/tttGameManager.dart';

class TTTGameManagerLocal implements TTTGameManager {
  TTTGameController? _tttGameController;
  VoidCallback? _gameEnd;

  TTTGameManagerLocal();

  @override
  void startGame() {
    _tttGameController!.setBackgroundMode(false);
    _tttGameController!.setOnRegisteredMoveEvent((move) {
      _tttGameController?.setMove(
          move,
          _tttGameController!.getLastField()?.getInvertedState() ??
              (Random().nextBool() ? TTTFS.cricle : TTTFS.cross));
      if (_tttGameController!.getWinsO() >=
          _tttGameController!.getGameSettings().getRequiredWins()) {
        // END GAME WITH O AS THE WINNER
        dispose();
      } else if (_tttGameController!.getWinsX() >=
          _tttGameController!.getGameSettings().getRequiredWins()) {
        // END GAME WITH X AS THE WINNER
        dispose();
      }
    });
  }

  @override
  void setGameController(controller) {
    this._tttGameController = controller;
  }

  @override
  void dispose() {
    _tttGameController!.setBackgroundMode(true);
    _gameEnd?.call();
  }

  @override
  void setOnGameEnd(VoidCallback onGameEnd) {
    this._gameEnd = onGameEnd;
  }
}
