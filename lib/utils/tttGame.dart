import 'package:vector_math/vector_math.dart';

void main() {
  _win w1 = _win(Vector3(0, 0, 0), Vector3(1, 1, 1));
  _win w2 = _win(Vector3(0, 0, 0), Vector3(1, 1, 1));
  print(w1 == w2);
  print(Vector3(0, 0, 0) == Vector3(0, 0, 0));
  print(w1.toString() == w2.toString());
  print(w1.hashCode);
  print(w2.hashCode);
}

class TTTGame {
  int nGS = 3;
  Vector3 _lastMove = Vector3(0, 0, 0);
  tttFieldState _lastFieldState =
      tttFieldState.empty; // Might later be used as the player who starts
  List<_win> _winsO = [];
  List<_win> _winsX = [];

  /// Layer (top -> bottom)
  /// Colum/Row
  /// Colum/Row
  late List<List<List<tttFieldState>>> gameState;

  TTTGame(this.nGS) {
    gameState = List.generate(
        nGS,
        (_) => List.generate(
            nGS, (_) => List.generate(nGS, (_) => tttFieldState.empty)));
  }
  TTTGame.gameSize({required int gameSize}) : this(gameSize);

  @override
  String toString() {
    String game = "";
    for (int x = 0; x < nGS; x++) {
      for (int y = 0; y < nGS; y++) {
        for (int z = 0; z < nGS; z++) {
          tttFieldState state = gameState[x][y][z];
          switch (state) {
            case tttFieldState.cricle:
              game += "O";
              break;
            case tttFieldState.cross:
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

    if (_winsX.isNotEmpty) {
      game += "\n${_winsX.length} wins for ${tttFieldState.cross.name}";
      for (int i = 0; i < _winsX.length; i++) {
        game += "\n${_winsX[i]}";
      }
    }
    if (_winsO.isNotEmpty) {
      game += "\n${_winsO.length} wins for ${tttFieldState.cricle.name}";
      for (int i = 0; i < _winsO.length; i++) {
        game += "\n${_winsO[i]}";
      }
    }

    return game;
  }

  void setMove(Vector3 lastMove, tttFieldState state) {
    _lastMove = lastMove;
    _lastFieldState = state;
    gameState[_lastMove.x.toInt()][_lastMove.y.toInt()][_lastMove.z.toInt()] =
        _lastFieldState;
    checkforwin();

    // TODO: Add autocheck and
  }

  // TODO: Add multiple wins (lines with same symbol) in order to win -> GENIUS

  /// Fins all possible wins in the cubic game field and safes them in calss win object
  /// It only finds the wins based on the last move but there are some which dont fall under this group, though idk. which ones
  /// LOGIC 1:
  /// Given is n as the cubic side length. n^3 is the total number of fields in the game.
  /// The number of all 2D layers with a size of n^2, not only in the 'normal' orientation, is n^2+6
  /// On all of these layers there can be a possible n streak of cross/cricle with wich you can win
  /// (n^3 are all the normal layers; +6 is const for a cube and represents all the diagonal layers you can lay through it)
  ///
  /// LOGIC 2:
  ///  The last move must be the one who won the game
  ///  The n Streak of cross/circle must start/end/cross the last set field in any way if the player won
  ///  Backtrace everey possible win combination path from the last set field -> Spreak out winning lines in all posssible directions
  /// I USE LOGIC 2!!!
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

    List<_win> wins = [];
    // TODO: Check if the point is even on the line -> Works either way, cause were checking only the last played symbol -> but there might be some unncessery checks -> not to heavy on small cubes
    // (1 0 0)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[i][y][z]) {
        break;
      } else if (i == nGS - 1) {
        wins.add(
            _win(Vector3(0, y.toDouble(), z.toDouble()), Vector3(1, 0, 0)));
      }
    }
    // (0 1 0)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[x][i][z]) {
        break;
      } else if (i == nGS - 1) {
        wins.add(
            _win(Vector3(x.toDouble(), 0, z.toDouble()), Vector3(0, 1, 0)));
      }
    }
    // (0 0 1)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[x][y][i]) {
        break;
      } else if (i == nGS - 1) {
        wins.add(
            _win(Vector3(x.toDouble(), y.toDouble(), 0), Vector3(0, 0, 1)));
      }
    }

    // (1 1 0)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[i][i][z]) {
        break;
      } else if (i == nGS - 1) {
        wins.add(_win(Vector3(0, 0, z.toDouble()), Vector3(1, 1, 0)));
      }
    }
    // (1 -1 0)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[i][nGS - i - 1][z]) {
        break;
      } else if (i == nGS - 1) {
        wins.add(_win(Vector3(0, nGS - 1, z.toDouble()), Vector3(1, -1, 0)));
      }
    }
    // (1 0 1)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[i][y][i]) {
        break;
      } else if (i == nGS - 1) {
        wins.add(_win(Vector3(0, y.toDouble(), 0), Vector3(1, 0, 1)));
      }
    }
    // (1 0 -1)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[i][y][nGS - i - 1]) {
        break;
      } else if (i == nGS - 1) {
        wins.add(_win(Vector3(0, y.toDouble(), nGS - 1), Vector3(1, 0, -1)));
      }
    }
    // (0 1 1)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[x][i][i]) {
        break;
      } else if (i == nGS - 1) {
        wins.add(_win(Vector3(x.toDouble(), 0, 0), Vector3(0, 1, 1)));
      }
    }
    // (0 1 -1)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[x][i][nGS - i - 1]) {
        break;
      } else if (i == nGS - 1) {
        wins.add(_win(Vector3(x.toDouble(), 0, nGS - 1), Vector3(0, 1, -1)));
      }
    }

    // (1 1 1)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[i][i][i]) {
        break;
      } else if (i == nGS - 1) {
        wins.add(_win(Vector3(0, 0, 0), Vector3(1, 1, 1)));
      }
    }

    // (1 1 -1)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[i][i][nGS - i - 1]) {
        break;
      } else if (i == nGS - 1) {
        wins.add(_win(Vector3(0, 0, nGS - 1), Vector3(1, 1, -1)));
      }
    }
    // (-1 1 1)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[nGS - i - 1][i][i]) {
        break;
      } else if (i == nGS - 1) {
        wins.add(_win(Vector3(nGS - 1, 0, 0), Vector3(-1, 1, 1)));
      }
    }
    // (-1 1 -1)
    for (int i = 0; i < nGS; i++) {
      if (_lastFieldState != gameState[nGS - i - 1][i][nGS - i - 1]) {
        break;
      } else if (i == nGS - 1) {
        wins.add(_win(Vector3(nGS - 1, 0, nGS - 1), Vector3(-1, 1, -1)));
      }
    }

    if (wins.isEmpty) {
      return;
    }
    if (_lastFieldState == tttFieldState.cricle) {
      _winsO = <_win>{
        ..._winsO,
        ...wins
      }.toList(); // Merges the existing and new wins togther while removing duplicates
    } else if (_lastFieldState == tttFieldState.cross) {
      _winsX = <_win>{..._winsX, ...wins}.toList();
    }
  }
}

enum tttFieldState { empty, cross, cricle }

class _win {
  Vector3 point;
  Vector3 direction;

  _win(this.point, this.direction);

  @override
  String toString() {
    return '$point - $direction';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _win && identical(hashCode, other.hashCode);

  @override
  int get hashCode => point.hashCode ^ direction.hashCode;
}
