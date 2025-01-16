import 'dart:ui';

import 'package:tritac3d/utils/tttGameController.dart';

abstract class TTTGameManager {
  void startGame();
  void setGameController(TTTGameController controller);
  void setOnGameEnd(VoidCallback onGameEnd);
  bool isOpenForRevenge();
  void dispose();
}
