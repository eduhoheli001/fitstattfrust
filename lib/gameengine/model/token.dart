import './position.dart';
enum TokenType {
  green,
  yellow,
  blue,
  red,
}

enum TokenState {
  home,
  normal,
  safeinpair,
  safezone
}

class Token {
  final int id;
  final TokenType type;
  Position tokenPosition;
  TokenState tokenState;
  int positionInPath;

  Token(this.type, this.tokenPosition, this.tokenState, this.id, {this.positionInPath = 0});
}
