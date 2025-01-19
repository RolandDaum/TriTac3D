import 'package:vector_math/vector_math.dart';

void main() {
  // TODO: Test ADmob
  // https://codelabs.developers.google.com/codelabs/admob-ads-in-flutter?hl=de#3

  _WIN win1 = _WIN(Vector3(0, 2, 0), Vector3(1, 0, 0));
  _WIN win2 = _WIN(Vector3(0, 2, 0), Vector3(1, 0, 0));

  List<_WIN> calcedWins = [win1, win2];

  List<_WIN> wins = [
    _WIN(Vector3(0, 2, 0), Vector3(1, 0, 0)),
    _WIN(Vector3(0, 2, 0), Vector3(1, 0, 0))
  ];

  calcedWins.forEach((win) {
    print(wins.contains(win));
  });

  // Vector3 v1 = Vector3(0, 2, 0);
  // Vector3 v2 = Vector3(0, 2.0, 0);
  // print(v1 == v2);
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
      other is _WIN && (point == other.point) && (direction == other.direction);

  // @override
  // int get hashCode => Object.hash(point, direction);
}

// class _WIN {
//   Vector3 point;
//   Vector3 direction;
//   late int id;

//   _WIN(this.point, this.direction) {
//     id = int.parse((point.x.toInt().abs().toString() +
//         point.y.toInt().abs().toString() +
//         point.z.toInt().abs().toString() +
//         direction.x.toInt().abs().toString() +
//         direction.y.toInt().abs().toString() +
//         direction.z.toInt().abs().toString()));
//     print(id);
//   }

//   @override
//   String toString() {
//     return '$point - $direction';
//   }

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) || other is _WIN && identical(id, other.id);

//   // other is _WIN && identical(hashCode, other.hashCode);

//   // // // this is gone fuck up because its will result in slitely different solutions depending on the code platform
//   // @override
//   // int get hashCode => point.hashCode ^ direction.hashCode;
//   // NEVER USE THIS AGAIN
// }
