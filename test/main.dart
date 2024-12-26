import 'package:tritac3d/utils/tttGame.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  TTTGame game = TTTGame(3);
  game.setMove(Vector3(0, 0, 0), tttFieldState.cricle);
  game.setMove(Vector3(1, 0, 0), tttFieldState.cricle);
  game.setMove(Vector3(2, 0, 0), tttFieldState.cricle);

  game.setMove(Vector3(0, 1, 0), tttFieldState.cricle);
  game.setMove(Vector3(0, 2, 0), tttFieldState.cricle);

  game.setMove(Vector3(0, 0, 1), tttFieldState.cricle);
  game.setMove(Vector3(0, 0, 2), tttFieldState.cricle);

  print(game.toString());
}
