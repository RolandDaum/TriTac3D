import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tritac3d/utils/appDesign.dart';
import 'package:tritac3d/utils/tttGameSettings.dart';
import 'package:vector_math/vector_math.dart';
import 'package:vibration/vibration.dart';

class TTTGameFieldState {
  TTTFS _state;
  bool _highlighted = false;
  Vector3 _id;

  TTTGameFieldState(this._state, this._id);

  void setHighlight(bool state) {
    _highlighted = state;
  }

  bool getHighlightState() {
    return this._highlighted;
  }

  bool setState(TTTFS state) {
    if (this._state == TTTFS.empty) {
      this._state = state;
      return true;
    }
    return false;
  }

  void reset() {
    this._state = TTTFS.empty;
    this._highlighted = false;
  }

  TTTFS getState() {
    return this._state;
  }

  TTTFS getInvertedState() {
    switch (this._state) {
      case TTTFS.cricle:
        return TTTFS.cross;
      case TTTFS.cross:
        return TTTFS.cricle;
      default:
        return TTTFS.empty;
    }
  }

  Vector3 getId() {
    return this._id;
  }
}

enum TTTFS { empty, cross, cricle }

class TTTGameController with ChangeNotifier {
  TTTGameSettings _gameSettings = TTTGameSettings();
  Vector3? _lastMoveID;
  List<_WIN> _winso = [];
  List<_WIN> _winsx = [];
  double _layerRotation = 45.0;
  int _activeLayer = 0;
  bool hasVibrator = false;
  bool _backgroundMode = false;
  Function(bool)? _onBackgroundModeChange;
  Function(Vector3)? _onRegisteredmoveEvent;
  late Appdesign _appDesign;

  /// Layer (top -> bottom)
  late List<List<List<TTTGameFieldState>>> gameState;

  TTTGameController(this._appDesign) {
    init();
  }

  void init() async {
    updateGameSize();
    _gameSettings.setOnGFSizeChange((size) => updateGameSize());

    resetGame();
    setBackgroundMode(true);

    hasVibrator = (await Vibration.hasVibrator())!;
  }

  /// updates the entire game UI via Provider
  void updateGameUI() {
    notifyListeners();
  }

  /// Clears the entire gameState and refocus layer if necessary
  void clearGame() {
    gameState.forEach(
      (layer) {
        layer.forEach((row) {
          row.forEach((field) {
            field.reset();
          });
        });
      },
    );
    _lastMoveID = null;
    _winso = [];
    _winsx = [];
    updateGameUI();
  }

  /// Resets the entiry gameState and everything else
  void resetGame() {
    clearGame();
    setLayerRotation(_gameSettings.getDefaultRotation());
    updateGameUI();
  }

  void updateGameSize() {
    int nGS = _gameSettings.getGFSize();
    gameState = List.generate(
        nGS,
        (x) => List.generate(
            nGS,
            (y) => List.generate(
                nGS,
                (z) => TTTGameFieldState(TTTFS.empty,
                    Vector3(x.toDouble(), y.toDouble(), z.toDouble())))));
    if (_activeLayer > (nGS - 1)) {
      setActiveLayer(((nGS - 1) / 2).round());
    }
    updateGameUI();
    setForcedBackgroundMode(getBackgroundMode());
  }

  /// Updates the gameState List on a given move location and to state
  /// All if the move location field has an empty state
  void setMove(Vector3 move, TTTFS state) {
    bool updated = gameState[move.x.toInt()][move.y.toInt()][move.z.toInt()]
        .setState(state);

    if (updated) {
      _lastMoveID = move;
      checkforwin();

      updateGameUI();
    }
  }

  /// call notifies the controllor of a pressed field
  void registeredMoveEvent(Vector3 eventCord) {
    this._onRegisteredmoveEvent?.call(eventCord);
  }

  void highlightWins(TTTFS type) {
    switch (type) {
      case TTTFS.cricle:
        _winso.forEach((win) {
          _setWinHighlightedState(win);
        });
        break;
      case TTTFS.cross:
        _winsx.forEach((win) {
          _setWinHighlightedState(win);
        });
        break;
      default:
        return;
    }
  }

  void deHighlightWins(TTTFS type) {
    switch (type) {
      case TTTFS.cricle:
        _winso.forEach((win) {
          _setWinHighlightedState(win, highlighted: false);
        });
        break;
      case TTTFS.cross:
        _winsx.forEach((win) {
          _setWinHighlightedState(win, highlighted: false);
        });
        break;
      default:
        return;
    }
  }

  void _setWinHighlightedState(_WIN win, {bool highlighted = true}) {
    Vector3 point = win.point;
    Vector3 direction = win.direction;

    for (int i = 0; i < _gameSettings.getGFSize(); i++) {
      int x = (point.x + i * direction.x).toInt();
      int y = (point.y + i * direction.y).toInt();
      int z = (point.z + i * direction.z).toInt();
      gameState[x][y][z].setHighlight(highlighted);
    }
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
    int x = getField(_lastMoveID!).getId().x.toInt();
    int y = getField(_lastMoveID!).getId().y.toInt();
    int z = getField(_lastMoveID!).getId().z.toInt();
    double xd = getField(_lastMoveID!).getId().x;
    double yd = getField(_lastMoveID!).getId().y;
    double zd = getField(_lastMoveID!).getId().z;
    TTTFS lastFieldState = getLastField()!.getState();

    List<_WIN> wins = [];
    int nGS = _gameSettings.getGFSize();

    //  ---  CASES  ---  //
    // Straight lines
    // 1 0 0   |   X
    // 0 1 0   |   Y
    // 0 0 1   |   Z
    // --- //
    // Diagonal Lines
    //  0  1  1    |    Y  Z
    //  0 -1  1    |   -Y  Z
    //  1  0  1    |    X  Z
    // -1  0  1    |   -X  Z
    //  1  1  0    |    X  Y
    //  1 -1  0    |    X -Y
    // --- //
    // 3D Diagonal Lines
    //  1  1  1   |    X  Y  Z
    // -1 -1  1   |   -X -Y  Z
    //  1 -1  1   |    X -Y  Z
    // -1  1  1   |   -X  Y  Z

    ///  ---  CASES - WRITTEN  ---  ///
    // Straight lines
    ///
    bool IOO = true;
    bool OIO = true;
    bool OOI = true;
    // Diagonal Lines
    bool OII = true;
    bool OiI = true;
    bool IOI = true;
    bool iOI = true;
    bool IIO = true;
    bool IiO = true;
    // 3D Diagonal Lines
    bool III = true;
    bool iiI = true;
    bool IiI = true;
    bool iII = true;
    for (int i = 0; i < nGS; i++) {
      int ii = nGS - i - 1; // i counted from the opposit direction
      // Straight lines
      // 1 0 0   |   X
      lastFieldState != gameState[i][y][z].getState() ? IOO = false : null;
      // 0 1 0   |   Y
      lastFieldState != gameState[x][i][z].getState() ? OIO = false : null;
      // 0 0 1   |   Z
      lastFieldState != gameState[x][y][i].getState() ? OOI = false : null;

      // --- //

      // Diagonal Lines
      //  0  1  1    |    Y  Z
      lastFieldState != gameState[x][i][i].getState() ? OII = false : null;
      //  0 -1  1    |   -Y  Z
      lastFieldState != gameState[x][ii][i].getState() ? OiI = false : null;
      //  1  0  1    |    X  Z
      lastFieldState != gameState[i][y][i].getState() ? IOI = false : null;
      // -1  0  1    |   -X  Z
      lastFieldState != gameState[ii][y][i].getState() ? iOI = false : null;
      //  1  1  0    |    X  Y
      lastFieldState != gameState[i][i][z].getState() ? IIO = false : null;
      //  1 -1  0    |    X -Y
      lastFieldState != gameState[i][ii][z].getState() ? IiO = false : null;

      // --- //

      // 3D Diagonal Lines
      //  1  1  1   |    X  Y  Z
      lastFieldState != gameState[i][i][i].getState() ? III = false : null;
      // -1 -1  1   |   -X -Y  Z
      lastFieldState != gameState[ii][ii][i].getState() ? iiI = false : null;
      //  1 -1  1   |    X -Y  Z
      lastFieldState != gameState[i][ii][i].getState() ? IiI = false : null;
      // -1  1  1   |   -X  Y  Z
      lastFieldState != gameState[ii][i][i].getState() ? iII = false : null;

      // --- //

      // END CHECK
      if (i == (nGS - 1)) {
        IOO ? wins.add(_WIN(Vector3(0, yd, zd), Vector3(1, 0, 0))) : null;
        OIO ? wins.add(_WIN(Vector3(xd, 0, zd), Vector3(0, 1, 0))) : null;
        OOI ? wins.add(_WIN(Vector3(xd, yd, 0), Vector3(0, 0, 1))) : null;

        OII ? wins.add(_WIN(Vector3(xd, 0, 0), Vector3(0, 1, 1))) : null;
        OiI ? wins.add(_WIN(Vector3(xd, nGS - 1, 0), Vector3(0, -1, 1))) : null;
        IOI ? wins.add(_WIN(Vector3(0, yd, 0), Vector3(1, 0, 1))) : null;
        iOI ? wins.add(_WIN(Vector3(nGS - 1, yd, 0), Vector3(-1, 0, 1))) : null;
        IIO ? wins.add(_WIN(Vector3(0, 0, zd), Vector3(1, 1, 0))) : null;
        IiO ? wins.add(_WIN(Vector3(0, nGS - 1, zd), Vector3(1, -1, 0))) : null;

        III ? wins.add(_WIN(Vector3(0, 0, 0), Vector3(1, 1, 1))) : null;
        iiI
            ? wins.add(_WIN(Vector3(nGS - 1, nGS - 1, 0), Vector3(-1, -1, 1)))
            : null;
        IiI ? wins.add(_WIN(Vector3(0, nGS - 1, 0), Vector3(1, -1, 1))) : null;
        iII ? wins.add(_WIN(Vector3(nGS - 1, 0, 0), Vector3(-1, 1, 1))) : null;
      }
    }

    if (wins.isEmpty) {
      return;
    }

    // Merges the existing and new wins togther while removing duplicates
    if (lastFieldState == TTTFS.cricle) {
      // wins.forEach((win) {
      //   if (!_winso.contains(win)) {
      //     _winso.add(win);
      //   } else {}
      // });
      _winso = <_WIN>{..._winso, ...wins}.toList();
      // _updateGameStateWins();
    } else if (lastFieldState == TTTFS.cross) {
      // wins.forEach((win) {
      //   if (!_winsx.contains(win)) {
      //     _winsx.add(win);
      //     print("NEW: " + win.toString());
      //   } else {
      //     print("OLD: " + win.toString());
      //   }
      // });
      _winsx = <_WIN>{..._winsx, ...wins}.toList();
      // _updateGameStateWins();
    }
  }

  /// Resets and fills the gameState with random TTTFS states based on the given chance
  void setRandomGame(double chance) {
    int nGS = _gameSettings.getGFSize();
    clearGame();
    for (int x = 0; x < nGS; x++) {
      for (int y = 0; y < nGS; y++) {
        for (int z = 0; z < nGS; z++) {
          if (Random().nextDouble() < chance) {
            gameState[x][y][z]
                .setState(Random().nextBool() ? TTTFS.cricle : TTTFS.cross);
            this._lastMoveID =
                Vector3(x.toDouble(), y.toDouble(), z.toDouble());
            checkforwin();
          }
        }
      }
    }
    updateGameUI();
  }

  /// - GET n' SET - ///
  /// returns true if layer has changed
  bool setActiveLayer(int layer) {
    if (layer < _gameSettings.getGFSize() && _activeLayer != layer) {
      _activeLayer = layer;

      // _appDesign.vibrateMovement();
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

  TTTGameFieldState getField(Vector3 field) {
    return gameState[field.x.toInt()][field.y.toInt()][field.z.toInt()];
  }

  TTTGameFieldState? getLastField() {
    return this._lastMoveID != null ? this.getField(this._lastMoveID!) : null;
  }

  bool getHighlightedState(Vector3 field) {
    return gameState[field.x.toInt()][field.y.toInt()][field.z.toInt()]
        .getHighlightState();
  }

  void setBackgroundMode(bool state) {
    if (_backgroundMode == state) {
      return;
    }
    setForcedBackgroundMode(state);
  }

  void setForcedBackgroundMode(bool state) {
    _backgroundMode = state;
    _onBackgroundModeChange?.call(_backgroundMode);
    if (_backgroundMode) {
      setRandomGame(0.5);
      setActiveLayer(_gameSettings.getGFSize() - 2);
      setLayerRotation(_gameSettings.getDefaultRotation());
    } else {
      resetGame();
    }
    updateGameUI();
  }

  bool getBackgroundMode() {
    return this._backgroundMode;
  }

  void setOnBackgroundModeChange(Function(bool) fnc) {
    this._onBackgroundModeChange = fnc;
  }

  void setOnRegisteredMoveEvent(Function(Vector3) fnc) {
    this._onRegisteredmoveEvent = fnc;
  }

  TTTGameSettings getGameSettings() {
    return this._gameSettings;
  }

  int getWinsX() {
    return this._winsx.length;
  }

  int getWinsO() {
    return this._winso.length;
  }

  @override
  String toString() {
    int nGS = _gameSettings.getGFSize();
    String game = "";
    for (int x = 0; x < nGS; x++) {
      for (int y = 0; y < nGS; y++) {
        for (int z = 0; z < nGS; z++) {
          TTTFS state = gameState[x][y][z].getState();
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

  // DEFINES when two win objects are == -> affes list.contains() operation
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _WIN && (point == other.point) && (direction == other.direction);
}
