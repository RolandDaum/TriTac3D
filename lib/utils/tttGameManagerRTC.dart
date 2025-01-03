import 'package:tritac3d/utils/WebRTCConnectionManager.dart';
import 'package:tritac3d/utils/tttGameManager.dart';

class TTTgameManagerRTC implements TTTGameManager {
  late WebRTCConnectionManager _webRTCConnectionManager;
  
  TTTgameManagerRTC(this._webRTCConnectionManager);

  @override
  void startGame() {
    // TODO: implement startGame
  }
  @override
  void setGameController(controller) {
    // TODO: implement setGameController
  }
}
