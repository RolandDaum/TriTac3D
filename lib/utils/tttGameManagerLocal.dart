import 'dart:math';
import 'dart:ui';

import 'package:tritac3d/utils/appDesign.dart';
import 'package:tritac3d/utils/tttGameController.dart';
import 'package:tritac3d/utils/tttGameManager.dart';

class TTTGameManagerLocal implements TTTGameManager {
  TTTGameController? _tttGameController;
  Appdesign? _appDesign;
  VoidCallback? _gameEnd;

  @override
  void startGame() {
    int moveCount = 0;
    _tttGameController!.clearGame();

    _tttGameController!.setOnRegisteredMoveEvent((move) {
      if (_tttGameController!.getField(move).getState() != TTTFS.empty) {
        return;
      }
      moveCount++;

      _tttGameController?.setMove(
          move,
          _tttGameController!.getLastField()?.getInvertedState() ??
              (Random().nextBool() ? TTTFS.cricle : TTTFS.cross));

      _tttGameController!.highlightWins(TTTFS.cricle);
      _tttGameController!.highlightWins(TTTFS.cross);

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
      }
      if (moveCount >=
          pow(_tttGameController!.getGameSettings().getGFSize(), 3).toInt()) {
        _gameEnd?.call();
      }
    });
  }

  @override
  void setGameController(controller) {
    this._tttGameController = controller;
  }

  @override
  void dispose() {
    // _tttGameController!.setBackgroundMode(true);
    // _gameEnd?.call(); // DONT CALL HERE, _gameEnd is only supposed to be triggered once a game is over and a player has won
  }

  @override
  void setOnGameEnd(VoidCallback onGameEnd) {
    this._gameEnd = onGameEnd;
  }

  @override
  bool isOpenForRevenge() {
    return true;
  }

  @override
  void setAppDesign(Appdesign appdesign) {
    this._appDesign = appdesign;
  }
}
