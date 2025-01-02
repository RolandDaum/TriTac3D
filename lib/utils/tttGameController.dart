import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tritac3d/components/tttField.dart';
import 'package:vector_math/vector_math.dart';
import 'package:vibration/vibration.dart';

class TTTGameFieldState {
  TTTFS state;
  bool highlighted = false;
  TTTGameFieldState(this.state);
  void setHighlight(bool state) {
    highlighted = state;
  }
}

class TTTGameController with ChangeNotifier {
  int nGS = 3;
  Vector3 _lastMove = Vector3(0, 0, 0);
  TTTFS _lastFieldState =
      TTTFS.empty; // Might later be used as the player who starts
  List<_WIN> _winso = [];
  List<_WIN> _winsx = [];
  double _layerRotation = 45.0;
  int _activeLayer = 0;
  bool hasVibrator = false;
  final double defaultRotation = 55.0;
  bool backgroundMode = false;

  /// Layer (top -> bottom)
  /// Colum/Row
  /// Colum/Row
  late List<List<List<TTTGameFieldState>>> gameState;

  TTTGameController() {
    init();
  }
  Future<void> init() async {
    _lastFieldState = Random().nextBool() ? TTTFS.cricle : TTTFS.cross;
    resetGame();
    setBackgroundMode();

    hasVibrator = (await Vibration.hasVibrator())!;
  }

  void startGame() {}

  /// returns true if layer has changed
  bool setActiveLayer(int layer) {
    if (layer < nGS && _activeLayer != layer) {
      _activeLayer = layer;
      if (hasVibrator) {
        Vibration.vibrate(duration: 32, amplitude: 64);
      }
      return true;
    }
    return false;
  }

  int getActiveLayer() {
    return _activeLayer;
  }

  void setLayerRotation(double angle) {
    _layerRotation = angle;
  }

  double getLayerRotation() {
    return _layerRotation;
  }

  void setGameSize(int size) {
    nGS = size;
    resetGame();
  }

  TTTFS getFieldState(Vector3 field) {
    return gameState[field.x.toInt()][field.y.toInt()][field.z.toInt()].state;
  }

  bool getHighlightedState(Vector3 field) {
    return gameState[field.x.toInt()][field.y.toInt()][field.z.toInt()]
        .highlighted;
  }

  /// Updates the gameState List on a given move location and to state
  /// All if the move location field has an empty state
  void _setMove(Vector3 lastMove, TTTFS state) {
    if (gameState[lastMove.x.toInt()][lastMove.y.toInt()][lastMove.z.toInt()]
            .state ==
        TTTFS.empty) {
      _lastMove = lastMove;
      _lastFieldState = state;
      gameState[_lastMove.x.toInt()][_lastMove.y.toInt()][_lastMove.z.toInt()]
          .state = _lastFieldState;
      checkforwin();
    }
  }

  /// call notifies the controllor of a pressed field
  void registeredMoveEvent(Vector3 eventCord) {
    if (_lastFieldState == TTTFS.cricle) {
      _setMove(eventCord, TTTFS.cross);
    } else {
      _setMove(eventCord, TTTFS.cricle);
    }
    updateGameUI();
  }

  void _updateGameStateWins() {
    for (var win in _winso) {
      _updateWinState(win, TTTFS.cricle);
    }
    for (var win in _winsx) {
      _updateWinState(win, TTTFS.cross);
    }
  }

  void _updateWinState(_WIN win, TTTFS state) {
    Vector3 point = win.point;
    Vector3 direction = win.direction;

    for (int i = 0; i < nGS; i++) {
      int x = (point.x + i * direction.x).toInt();
      int y = (point.y + i * direction.y).toInt();
      int z = (point.z + i * direction.z).toInt();
      gameState[x][y][z].setHighlight(true);
    }
  }

  /// updates the entire game UI via Provider
  void updateGameUI() {
    notifyListeners();
  }

  /// Clears the entire gameState
  void resetGame() {
    backgroundMode = false;
    gameState = List.generate(
        nGS,
        (_) => List.generate(nGS,
            (_) => List.generate(nGS, (_) => TTTGameFieldState(TTTFS.empty))));
    setActiveLayer(((nGS - 1) / 2).round());
    setLayerRotation(defaultRotation);
    updateGameUI();
  }

  /// Resets and fills the gameState with random TTTFS states based on the given chance
  void setRandomGame(double chance) {
    resetGame();
    for (int x = 0; x < nGS; x++) {
      for (int y = 0; y < nGS; y++) {
        for (int z = 0; z < nGS; z++) {
          if (Random().nextDouble() < chance) {
            gameState[x][y][z].state =
                Random().nextBool() ? TTTFS.cricle : TTTFS.cross;
          }
        }
      }
    }
    checkforwin();
    updateGameUI();
  }

  void setBackgroundMode() {
    setRandomGame(0.5);
    setActiveLayer(nGS - 2);
    setLayerRotation(defaultRotation);
    backgroundMode = true;
    updateGameUI();
  }

  /// Fins all possible wins in the cubic game field and safes them in calss win object
  /// It only finds the wins based on the last move but there are some which dont fall under this group, though idk. which ones
  // LOGIC 1:
  // Given is n as the cubic side length. n^3 is the total number of fields in the game.
  // The number of all 2D layers with a size of n^2, not only in the 'normal' orientation, is n^2+6
  // On all of these layers there can be a possible n streak of cross/cricle with wich you can win
  // (n^3 are all the normal layers; +6 is const for a cube and represents all the diagonal layers you can lay through it)
  //
  // LOGIC 2:
  //  The last move must be the one who won the game
  //  The n Streak of cross/circle must start/end/cross the last set field in any way if the player won
  //  Backtrace everey possible win combination path from the last set field -> Spreak out winning lines in all posssible directions
  // I USE LOGIC 2!!!
  void checkforwin() {
    // L1: Create all the different Layers in a given formatt and check them for a win.
    // L2: Check every direction
    /// VECTOR ///
    // AXIS //
    // 0 x  <-> 0 -x        (1 0 0)
    // 0 y  <-> 0 -y        (0 1 0)
    // 0 z  <-> 0 -z        (0 0 1)
    // PLANE DIAGONAL //
    // x y  <-> -x -y       (1 1 0)
    // x -y <-> -x y        (1 -1 0)
    // x z  <-> -x -z       (1 0 1)
    // x -z <-> -x z        (1 0 -1)
    // y z  <-> -y -z       (0 1 1)
    // y -z <-> -y z        (0 1 -1)
    // SPACE DIGAGONAL // -- only if point lays inside the cubes core
    // x y z   <-> -x -y -z   (1 1 1)
    // x y -z  <-> -x -y z    (1 1 -1)
    // -x y x  <-> x -y -z    (-1 1 1)
    // -x y -z <-> x -y z     (-1 1 -1)
    int x = _lastMove.x.toInt();
    int y = _lastMove.y.toInt();
    int z = _lastMove.z.toInt();

    List<_WIN> wins = [];
    // TODO: Check if the point is even on the line -> Works either way, cause were checking only the last played symbol -> but there might be some unncessery checks -> not to heavy on small cubes
    // (1 0 0)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[i][y][z].state) {
        break;
      } else if (i == nGS - 1) {
        wins.add(
            _WIN(Vector3(0, y.toDouble(), z.toDouble()), Vector3(1, 0, 0)));
      }
    }
    // (0 1 0)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[x][i][z].state) {
        break;
      } else if (i == nGS - 1) {
        wins.add(
            _WIN(Vector3(x.toDouble(), 0, z.toDouble()), Vector3(0, 1, 0)));
      }
    }
    // (0 0 1)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[x][y][i].state) {
        break;
      } else if (i == nGS - 1) {
        wins.add(
            _WIN(Vector3(x.toDouble(), y.toDouble(), 0), Vector3(0, 0, 1)));
      }
    }

    // (1 1 0)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[i][i][z].state) {
        break;
      } else if (i == nGS - 1) {
        wins.add(_WIN(Vector3(0, 0, z.toDouble()), Vector3(1, 1, 0)));
      }
    }
    // (1 -1 0)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[i][nGS - i - 1][z].state) {
        break;
      } else if (i == nGS - 1) {
        wins.add(_WIN(Vector3(0, nGS - 1, z.toDouble()), Vector3(1, -1, 0)));
      }
    }
    // (1 0 1)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[i][y][i].state) {
        break;
      } else if (i == nGS - 1) {
        wins.add(_WIN(Vector3(0, y.toDouble(), 0), Vector3(1, 0, 1)));
      }
    }
    // (1 0 -1)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[i][y][nGS - i - 1].state) {
        break;
      } else if (i == nGS - 1) {
        wins.add(_WIN(Vector3(0, y.toDouble(), nGS - 1), Vector3(1, 0, -1)));
      }
    }
    // (0 1 1)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[x][i][i].state) {
        break;
      } else if (i == nGS - 1) {
        wins.add(_WIN(Vector3(x.toDouble(), 0, 0), Vector3(0, 1, 1)));
      }
    }
    // (0 1 -1)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[x][i][nGS - i - 1].state) {
        break;
      } else if (i == nGS - 1) {
        wins.add(_WIN(Vector3(x.toDouble(), 0, nGS - 1), Vector3(0, 1, -1)));
      }
    }

    // (1 1 1)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[i][i][i].state) {
        break;
      } else if (i == nGS - 1) {
        wins.add(_WIN(Vector3(0, 0, 0), Vector3(1, 1, 1)));
      }
    }

    // (1 1 -1)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[i][i][nGS - i - 1].state) {
        break;
      } else if (i == nGS - 1) {
        wins.add(_WIN(Vector3(0, 0, nGS - 1), Vector3(1, 1, -1)));
      }
    }
    // (-1 1 1)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[nGS - i - 1][i][i].state) {
        break;
      } else if (i == nGS - 1) {
        wins.add(_WIN(Vector3(nGS - 1, 0, 0), Vector3(-1, 1, 1)));
      }
    }
    // (-1 1 -1)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[nGS - i - 1][i][nGS - i - 1].state) {
        break;
      } else if (i == nGS - 1) {
        wins.add(_WIN(Vector3(nGS - 1, 0, nGS - 1), Vector3(-1, 1, -1)));
      }
    }

    if (wins.isEmpty) {
      return;
    }
    // Merges the existing and new wins togther while removing duplicates
    if (_lastFieldState == TTTFS.cricle) {
      _winso = <_WIN>{..._winso, ...wins}.toList();
      _updateGameStateWins();
    } else if (_lastFieldState == TTTFS.cross) {
      _winsx = <_WIN>{..._winsx, ...wins}.toList();
      _updateGameStateWins();
    }
  }

  @override
  String toString() {
    String game = "";
    for (int x = 0; x < nGS; x++) {
      for (int y = 0; y < nGS; y++) {
        for (int z = 0; z < nGS; z++) {
          TTTFS state = gameState[x][y][z].state;
          switch (state) {
            case TTTFS.cricle:
              game += "O";
              break;
            case TTTFS.cross:
              game += "X";
              break;
            default:
              game += " ";
              break;
          }
          game += " | ";
        }
        game += '\n';
      }
      x != nGS - 1 ? game += "---------\n" : {};
    }

    if (_winsx.isNotEmpty) {
      game += "\n${_winsx.length} wins for ${TTTFS.cross.name}";
      for (int i = 0; i < _winsx.length; i++) {
        game += "\n${_winsx[i]}";
      }
    }
    if (_winso.isNotEmpty) {
      game += "\n${_winso.length} wins for ${TTTFS.cricle.name}";
      for (int i = 0; i < _winso.length; i++) {
        game += "\n${_winso[i]}";
      }
    }

    return game;
  }
}

class _WIN {
  Vector3 point;
  Vector3 direction;

  _WIN(this.point, this.direction);

  @override
  String toString() {
    return '$point - $direction';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _WIN && identical(hashCode, other.hashCode);

  @override
  int get hashCode => point.hashCode ^ direction.hashCode;
}
