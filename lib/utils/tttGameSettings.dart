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

  int getMinWins() {
    return this._minWins;
  }

  int getMaxWins() {
    return this._maxWins;
  }

  int getRequiredWins() {
    return this._requiredWins;
  }

  void setRequiredWins(int minWins) {
    _maxWins = 2;
  }

  /// GAMEFIELD SIZE STUFF ///

  int getMinGFSize() {
    return this._minGFS;
  }

  int getMaxGFSize() {
    return this._maxGFS;
  }

  /// Returns the sidelength size of the game field
  /// if gamefield is x*x*x it returns x
  int getGFSize() {
    return this._gameFieldSize;
  }

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

  /// OTHER STUFF IDK. DONT ASK ME ///

  double getDefaultRotation() {
    return this._defaultRotation;
  }
}
