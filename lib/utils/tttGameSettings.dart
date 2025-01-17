import 'dart:convert';
import 'dart:math';

class TTTGameSettings {
  final int _minGFS = 3;
  final int _maxGFS = 6;
  int _gameFieldSize = 3;
  Function(int)? _onGFSizeChange;

  late int _maxWins;
  final int _minWins = 1;
  int _requiredWins = 1;

  /// Calculates the Maximum possible amounts of wins one player can achieve in a game -> the never will hahaha
  void _setMaxWins() {
    // Count of every win possibility divided by 2   // Max. Anzahl an Gewinnen für ein Spieler (n^2)/2 + n + 4 -> .round()
    _maxWins = ((pow(_gameFieldSize, 2) / 2) + _gameFieldSize + 4).round();
  }

  /// Sets the recommented amount of requried wins -> Currently min + (d(max,min))/2
  void _setRecommendedRequiredWins() {
    _requiredWins = (_minWins + ((_maxWins - _minWins) / 2)).round();
  }

  double _defaultRotation = 55.0;

  TTTGameSettings() {
    _setMaxWins();
    _setRecommendedRequiredWins();
  }

  /// - GET n' SET - ///

  /// WIN STUFF ///

  int getMinWins() => _minWins;

  int getMaxWins() => _maxWins;

  int getRequiredWins() => _requiredWins;

  void setRequiredWins(int reqWins) {
    // print("SETTINGS REQUIRED WINS TO: " + reqWins.toString());
    // print("ALLOWED MAX WINS ARE: " + _maxWins.toString());
    if (!(reqWins > this._maxWins || reqWins < this._minWins)) {
      this._requiredWins = reqWins;
    } else if (reqWins > this._maxWins) {
      this._requiredWins = getMaxWins();
    }
  }

  /// GAMEFIELD SIZE STUFF ///

  int getMinGFSize() => _minGFS;

  int getMaxGFSize() => _maxGFS;

  /// Returns the sidelength size of the game field
  /// if gamefield is x*x*x it returns x
  int getGFSize() => _gameFieldSize;

  void setGFSize(int size) {
    if (size >= _minGFS && size <= _maxGFS) {
      this._gameFieldSize = size;
      _onGFSizeChange?.call(this._gameFieldSize);
    }
    _setMaxWins();
  }

  void setOnGFSizeChange(Function(int) fnc) {
    this._onGFSizeChange = fnc;
  }

  double getDefaultRotation() => _defaultRotation;

  /// JSON IN/EXPORT ///
  String toJsonString() {
    return jsonEncode({
      'type': 'settings',
      'settings': {
        'gameFieldSize': getGFSize(),
        'requiredWins': getRequiredWins(),
      }
    });
  }

  // void fromJsonString(String jsonSettings) {
  //   Map<String, dynamic> settings = jsonDecode(jsonSettings);
  //   setGFSize(settings['Settings']['gameFieldSize']);
  //   setRequiredWins(settings['Settings']['requiredWins']);
  // }
}
