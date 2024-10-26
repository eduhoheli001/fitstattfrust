import 'package:flutter/material.dart';
import 'package:fitstattfrust/gameengine/path.dart';

import './position.dart';
import './token.dart';

class GameState with ChangeNotifier {
  List<Token> gameTokens = List.filled(16, Token(TokenType.green, Position(0, 0), TokenState.initial, 0), growable: false);
  List<Position> starPositions = [];
  List<Position> greenInitital = [];
  List<Position> yellowInitital = [];
  List<Position> blueInitital = [];
  List<Position> redInitital = [];
  TokenType currentPlayer = TokenType.green;
  String currentPlayerName = "Grün:Laura";
  GameState() {
    this.gameTokens = [
      //Green
      Token(TokenType.green, Position(1, 1), TokenState.initial, 0),
      Token(TokenType.green, Position(1, 2), TokenState.initial, 1),
      Token(TokenType.green, Position(2, 1), TokenState.initial, 2),
      Token(TokenType.green, Position(2, 2), TokenState.initial, 3),

      // Yellow Tokens
      Token(TokenType.yellow, Position(1, 12), TokenState.initial, 4),
      Token(TokenType.yellow, Position(1, 13), TokenState.initial, 5),
      Token(TokenType.yellow, Position(2, 12), TokenState.initial, 6),
      Token(TokenType.yellow, Position(2, 13), TokenState.initial, 7),
      // Blue Tokens
      Token(TokenType.red, Position(12, 1), TokenState.initial, 8),
      Token(TokenType.red, Position(12, 2), TokenState.initial, 9),
      Token(TokenType.red, Position(13, 1), TokenState.initial, 10),
      Token(TokenType.red, Position(13, 2), TokenState.initial, 11),
      // Red Tokens
      Token(TokenType.blue, Position(12, 12), TokenState.initial, 12),
      Token(TokenType.blue, Position(12, 13), TokenState.initial, 13),
      Token(TokenType.blue, Position(13, 12), TokenState.initial, 14),
      Token(TokenType.blue, Position(13, 13), TokenState.initial, 15),
    ];

    //das muss überarbeitet werden!!!!!!Das sind die savepositions
    this.starPositions = [
      Position(6, 1),
      Position(2, 6),
      Position(1, 8),
      Position(6, 12),
      Position(8, 13),
      Position(12, 8),
      Position(13, 6),
      Position(8, 2),
    ];
  }
  void _switchToNextPlayer() {
    switch (currentPlayer) {
      case TokenType.green:
        currentPlayer = TokenType.yellow;
        currentPlayerName = "Grün:Laura";
        break;
      case TokenType.yellow:
        currentPlayer = TokenType.blue;
        currentPlayerName = "Blau:Hannah";
        break;
      case TokenType.blue:
        currentPlayer = TokenType.red;
        currentPlayerName = "Blau:Ange";
        break;
      case TokenType.red:
        currentPlayer = TokenType.green;
        currentPlayerName = "Blau:Fabio";
        break;
    }
    notifyListeners();
  }

  bool isCurrentPlayer(Token token) {
    return token.type == currentPlayer;
  }



  void moveToken(Token token, int steps) {

    //Darf ich spielen
    if (!isCurrentPlayer(token)) return;

    if (token.tokenState == TokenState.home) return;
    if (token.tokenState == TokenState.initial && steps != 6) return;

    Position destination;
    int pathPosition;

    if (token.tokenState == TokenState.initial && steps == 6) {

      destination = _getPosition(token.type, 0);
      pathPosition = 0;
      _updateInitalPositions(token);
      _updateBoardState(token, destination, pathPosition);
      this.gameTokens[token.id].tokenPosition = destination;
      this.gameTokens[token.id].positionInPath = pathPosition;
      notifyListeners();

    } else if (token.tokenState != TokenState.initial) {

      int step = token.positionInPath + steps;

      if (step > 51) return;// hier muss die pfadlänge eachtet werden (52 elemente)
      destination = _getPosition(token.type, step);
      pathPosition = step;
      var cutToken = _updateBoardState(token, destination, pathPosition);
      int duration = 0;

      for (int i = 1; i <= steps; i++) {
        duration += 500;
        Future.delayed(Duration(milliseconds: duration), () {
          int stepLoc = token.positionInPath + 1;
          this.gameTokens[token.id].tokenPosition = _getPosition(token.type, stepLoc);
          this.gameTokens[token.id].positionInPath = stepLoc;
          token.positionInPath = stepLoc;
          notifyListeners();
        });
      }

      if (cutToken != null) {
        int cutSteps = cutToken.positionInPath;
        for (int i = 1; i <= cutSteps; i++) {
          duration += 100;
          Future.delayed(Duration(milliseconds: duration), () {
            int stepLoc = cutToken.positionInPath - 1;
            this.gameTokens[cutToken.id].tokenPosition = _getPosition(cutToken.type, stepLoc);
            this.gameTokens[cutToken.id].positionInPath = stepLoc;
            cutToken.positionInPath = stepLoc;
            notifyListeners();
          });
        }

        Future.delayed(Duration(milliseconds: duration), () {
          _cutToken(cutToken);
          notifyListeners();
        });
      }
    }

    // Spielerwechsel nur -> wenn keine 6
    if (steps != 6)
      _switchToNextPlayer();

  }

  Token? _updateBoardState(Token token, Position destination, int pathPosition) {
    Token? cutToken;

    if (this.starPositions.contains(destination)) {
      this.gameTokens[token.id].tokenState = TokenState.safe;
      return null;
    }

    List<Token> tokenAtDestination = this.gameTokens.where((tkn) => tkn.tokenPosition == destination).toList();

    if (tokenAtDestination.isEmpty) {
      this.gameTokens[token.id].tokenState = TokenState.normal;
      return null;
    }

    List<Token> tokenAtDestinationSameType = tokenAtDestination.where((tkn) => tkn.type == token.type).toList();

    if (tokenAtDestinationSameType.length == tokenAtDestination.length) {
      for (Token tkn in tokenAtDestinationSameType) {
        this.gameTokens[tkn.id].tokenState = TokenState.safeinpair;
      }
      this.gameTokens[token.id].tokenState = TokenState.safeinpair;
      return null;
    }

    if (tokenAtDestinationSameType.length < tokenAtDestination.length) {
      for (Token tkn in tokenAtDestination) {
        if (tkn.type != token.type && tkn.tokenState != TokenState.safeinpair) {
          cutToken = tkn;
        } else if (tkn.type == token.type) {
          this.gameTokens[tkn.id].tokenState = TokenState.safeinpair;
        }
      }
      this.gameTokens[token.id].tokenState = tokenAtDestinationSameType.isNotEmpty ? TokenState.safeinpair : TokenState.normal;
      return cutToken;
    }
    return null;
  }

  void _updateInitalPositions(Token token) {

    switch (token.type) {
      case TokenType.green:
        this.greenInitital.add(token.tokenPosition);
        break;
      case TokenType.yellow:
        this.yellowInitital.add(token.tokenPosition);
        break;
      case TokenType.blue:
        this.blueInitital.add(token.tokenPosition);
        break;
      case TokenType.red:
        this.redInitital.add(token.tokenPosition);
        break;
    }
  }

  void _cutToken(Token token) {

    switch (token.type) {
      case TokenType.green:
        this.gameTokens[token.id].tokenState = TokenState.initial;
        this.gameTokens[token.id].tokenPosition = this.greenInitital.removeAt(0);
        break;
      case TokenType.yellow:
        this.gameTokens[token.id].tokenState = TokenState.initial;
        this.gameTokens[token.id].tokenPosition = this.yellowInitital.removeAt(0);
        break;
      case TokenType.blue:
        this.gameTokens[token.id].tokenState = TokenState.initial;
        this.gameTokens[token.id].tokenPosition = this.blueInitital.removeAt(0);
        break;
      case TokenType.red:
        this.gameTokens[token.id].tokenState = TokenState.initial;
        this.gameTokens[token.id].tokenPosition = this.redInitital.removeAt(0);
        break;
    }
  }

  Position _getPosition(TokenType type, int step) {

    Position destination;
    switch (type) {
      case TokenType.green:
        List<int> node = Path.greenPath[step];
        destination = Position(node[0], node[1]);
        break;
      case TokenType.yellow:
        List<int> node = Path.yellowPath[step];
        destination = Position(node[0], node[1]);
        break;
      case TokenType.blue:
        List<int> node = Path.bluePath[step];
        destination = Position(node[0], node[1]);
        break;
      case TokenType.red:
        List<int> node = Path.redPath[step];
        destination = Position(node[0], node[1]);
        break;
    }
    return destination;
  }
}
