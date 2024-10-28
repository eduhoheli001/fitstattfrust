import 'package:flutter/material.dart';
import 'package:fitstattfrust/gameengine/path.dart';

import './position.dart';
import './token.dart';
import 'dice_model.dart';


class GameState with ChangeNotifier {
  List<Token> gameTokens = List.filled(16, Token(TokenType.green, Position(0, 0), TokenState.home, 0), growable: false);
  List<Position> starPositions = [];
  List<Position> greenInitital = [];
  List<Position> yellowInitital = [];
  List<Position> blueInitital = [];
  List<Position> redInitital = [];
  TokenType currentPlayer = TokenType.green;
  int noSixCount = 0;
  bool hasMovedToken=false;
  int rollCount = 0;

  bool isSafeZone(Token token, Position destination) {
    // Safezone Positionen
    final List<Position> greenSafeZone = [Position(7, 2), Position(7, 3), Position(7, 4), Position(7, 5)];
    final List<Position> yellowSafeZone = [Position(2, 7), Position(3, 7), Position(4, 7), Position(5, 7)];
    final List<Position> blueSafeZone = [Position(7, 12), Position(7, 11), Position(7, 10), Position(7, 9)];
    final List<Position> redSafeZone = [Position(12, 7), Position(11, 7), Position(10, 7), Position(9, 7)];

    switch (token.type) {
      case TokenType.green:
        return greenSafeZone.contains(destination);
      case TokenType.yellow:
        return yellowSafeZone.contains(destination);
      case TokenType.blue:
        return blueSafeZone.contains(destination);
      case TokenType.red:
        return redSafeZone.contains(destination);
      default:
        return false;
    }
  }
  bool isHomePosition(Token token, Position destination) {
    // Home-Positionen für jeden Token
    final List<Position> greenHomePositions = [Position(1, 1), Position(1, 2), Position(2, 1), Position(2, 2)];
    final List<Position> yellowHomePositions = [Position(1, 12), Position(1, 13), Position(2, 12), Position(2, 13)];
    final List<Position> redHomePositions = [Position(12, 1), Position(12, 2), Position(13, 1), Position(13, 2)];
    final List<Position> blueHomePositions = [Position(12, 12), Position(12, 13), Position(13, 12), Position(13, 13)];

    switch (token.type) {
      case TokenType.green:
        return greenHomePositions.contains(destination);
      case TokenType.yellow:
        return yellowHomePositions.contains(destination);
      case TokenType.red:
        return redHomePositions.contains(destination);
      case TokenType.blue:
        return blueHomePositions.contains(destination);
      default:
        return false;
    }
  }


  String getCurrentPlayerName() {
    switch (currentPlayer) {
      case TokenType.green:
      return "Grün";
      case TokenType.yellow:
        return "Gelb";
      case TokenType.blue:
        return "Blau";
      case TokenType.red:
        return "Rot";
    }
    return "";
  }


  GameState() {
    this.gameTokens = [
      //auch in isHomePosition ändern falls notwendig!!
      //Green
      Token(TokenType.green, Position(1, 1), TokenState.home, 0),
      Token(TokenType.green, Position(1, 2), TokenState.home, 1),
      Token(TokenType.green, Position(2, 1), TokenState.home, 2),
      Token(TokenType.green, Position(2, 2), TokenState.home, 3),

      // Yellow Tokens
      Token(TokenType.yellow, Position(1, 12), TokenState.home, 4),
      Token(TokenType.yellow, Position(1, 13), TokenState.home, 5),
      Token(TokenType.yellow, Position(2, 12), TokenState.home, 6),
      Token(TokenType.yellow, Position(2, 13), TokenState.home, 7),
      // Blue Tokens
      Token(TokenType.red, Position(12, 1), TokenState.home, 8),
      Token(TokenType.red, Position(12, 2), TokenState.home, 9),
      Token(TokenType.red, Position(13, 1), TokenState.home, 10),
      Token(TokenType.red, Position(13, 2), TokenState.home, 11),
      // Red Tokens
      Token(TokenType.blue, Position(12, 12), TokenState.home, 12),
      Token(TokenType.blue, Position(12, 13), TokenState.home, 13),
      Token(TokenType.blue, Position(13, 12), TokenState.home, 14),
      Token(TokenType.blue, Position(13, 13), TokenState.home, 15),
    ];

  }

  void _switchToNextPlayer() {
    switch (currentPlayer) {
      case TokenType.green:
        currentPlayer = TokenType.yellow;
        break;
      case TokenType.yellow:
        currentPlayer = TokenType.blue;
        break;
      case TokenType.blue:
        currentPlayer = TokenType.red;
        break;
      case TokenType.red:
        currentPlayer = TokenType.green;
        break;
    }
    notifyListeners();
  }
  //reset game
  void resetGame() {
    //muss noch getestet werden!!!
    currentPlayer = TokenType.green;
    rollCount = 0;
    noSixCount = 0;
    hasMovedToken = false;

    //reset gametoken
    gameTokens = [
      Token(TokenType.green, Position(1, 1), TokenState.home, 0),
      Token(TokenType.green, Position(1, 2), TokenState.home, 1),
      Token(TokenType.green, Position(2, 1), TokenState.home, 2),
      Token(TokenType.green, Position(2, 2), TokenState.home, 3),
      Token(TokenType.yellow, Position(1, 12), TokenState.home, 4),
      Token(TokenType.yellow, Position(1, 13), TokenState.home, 5),
      Token(TokenType.yellow, Position(2, 12), TokenState.home, 6),
      Token(TokenType.yellow, Position(2, 13), TokenState.home, 7),
      Token(TokenType.red, Position(12, 1), TokenState.home, 8),
      Token(TokenType.red, Position(12, 2), TokenState.home, 9),
      Token(TokenType.red, Position(13, 1), TokenState.home, 10),
      Token(TokenType.red, Position(13, 2), TokenState.home, 11),
      Token(TokenType.blue, Position(12, 12), TokenState.home, 12),
      Token(TokenType.blue, Position(12, 13), TokenState.home, 13),
      Token(TokenType.blue, Position(13, 12), TokenState.home, 14),
      Token(TokenType.blue, Position(13, 13), TokenState.home, 15),
    ];
    notifyListeners();
  }
  //zum testen des Spielfeldes
  void debugModeSetToken() {
    //muss noch getestet werden!!!
    currentPlayer = TokenType.green; //ausahl welcher spieler
    rollCount = 0;
    noSixCount = 0;
    hasMovedToken = false;

    //reset gametoken
    gameTokens = [
      /*
      Token(TokenType.green, Position(1, 1), TokenState.home, 0),
      Token(TokenType.green, Position(1, 2), TokenState.home, 1),
      Token(TokenType.green, Position(2, 1), TokenState.home, 2),
      Token(TokenType.green, Position(2, 2), TokenState.home, 3),
      Token(TokenType.yellow, Position(1, 12), TokenState.home, 4),
      Token(TokenType.yellow, Position(1, 13), TokenState.home, 5),
      Token(TokenType.yellow, Position(2, 12), TokenState.home, 6),
      Token(TokenType.yellow, Position(2, 13), TokenState.home, 7),
      Token(TokenType.red, Position(12, 1), TokenState.home, 8),
      Token(TokenType.red, Position(12, 2), TokenState.home, 9),
      Token(TokenType.red, Position(13, 1), TokenState.home, 10),
      Token(TokenType.red, Position(13, 2), TokenState.home, 11),
      Token(TokenType.blue, Position(12, 12), TokenState.home, 12),
      Token(TokenType.blue, Position(12, 13), TokenState.home, 13),
      Token(TokenType.blue, Position(13, 12), TokenState.home, 14),
      Token(TokenType.blue, Position(13, 13), TokenState.home, 15),*/

      Token(TokenType.green, Position(6, 2), TokenState.normal, 0),
      Token(TokenType.green, Position(6, 3), TokenState.normal, 1),
    //  Token(TokenType.green, Position(7, 4), TokenState.normal, 2),
    //  Token(TokenType.green, Position(7, 1), TokenState.normal, 3),
      /*Token(TokenType.yellow, Position(1, 12), TokenState.normal, 4),
      Token(TokenType.yellow, Position(1, 13), TokenState.normal, 5),
      Token(TokenType.yellow, Position(2, 12), TokenState.normal, 6),
      Token(TokenType.yellow, Position(2, 13), TokenState.normal, 7),
      Token(TokenType.red, Position(12, 1), TokenState.normal, 8),
      Token(TokenType.red, Position(12, 2), TokenState.normal, 9),
      Token(TokenType.red, Position(13, 1), TokenState.normal, 10),
      Token(TokenType.red, Position(13, 2), TokenState.normal, 11),
      Token(TokenType.blue, Position(12, 12), TokenState.normal, 12),
      Token(TokenType.blue, Position(12, 13), TokenState.normal, 13),
      Token(TokenType.blue, Position(13, 12), TokenState.normal, 14),
      Token(TokenType.blue, Position(13, 13), TokenState.normal, 15)*/





    ];
    notifyListeners();
  }



//Checkwinner
  void checkWinner(BuildContext context) {
    bool allInSafeZone = gameTokens
        .where((token) => token.type == currentPlayer)
        .every((token) => token.tokenState == TokenState.safezone);

    if (allInSafeZone) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sieger!"),
            content: Text("${getCurrentPlayerName()} hat gewonnen!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  resetGame(); // Spiel zurücksetzen
                },
                child: Text("Spiel zurücksetzen"),
              ),
            ],
          );
        },
      );
    }
  }


  bool isCurrentPlayer(Token token) {
    return token.type == currentPlayer;
  }

  int getRemainingRolls() { //ausgabe für remaining rolls
    bool hasTokenInPlay = gameTokens.any((token) =>
    token.type == currentPlayer &&
        token.tokenState != TokenState.home &&
        token.tokenState != TokenState.safezone);
    return hasTokenInPlay ? 1 : (3 - rollCount);
  }


  void rollDice(DiceModel diceModel) {
    print("rollDice");
    int diceRoll = diceModel.generateDiceOne();

    hasMovedToken = false;
    notifyListeners();

    if (getRemainingRolls() == 0) {
      print("diceOne0");
      diceModel.setDiceOne(0); // Setzt auf 0.png, wenn keine Würfe mehr vorhanden sind/muss getestet werden
      _switchToNextPlayer();
      return;
    }

    // Überprüfung: Hat der Spieler Tokens im Spielfeld?
    bool hasTokenInPlay = gameTokens.any((token) =>
    token.type == currentPlayer &&
        token.tokenState != TokenState.home);

    // Falls kein Token im Spiel und keine 6, Wurfzähler erhöhen und ggf. Spielerwechsel
    if (!hasTokenInPlay && diceRoll != 6) {
      rollCount++;
      if (rollCount >= 3) {
        rollCount = 0;
        _switchToNextPlayer();
      }
    } else if (diceRoll == 6) {
      rollCount = hasTokenInPlay ? 1 : 0; // Setzt rollCount auf 1, wenn bereits ein Token im Spiel ist
      print("6 geworfen, der Spieler darf erneut würfeln.");
    } else {
      print("Warten auf Bewegung des Spielers...");
    }
  }

  void moveToken(Token token, int steps, DiceModel diceModel,BuildContext context) {
    if (hasMovedToken) {
      print("Token kann nicht bewegt werden. Bitte würfeln Sie erneut.");
      return;
    }

    if (!isCurrentPlayer(token)) return;

    // Token von home ins Spiel bringen
    if (token.tokenState == TokenState.home && steps == 6) {
      noSixCount = 0;
      Position destination = _getPosition(token.type, 0);
      int pathPosition = 0;

      // Sicherstellen, dass keine Position doppelt belegt wird
      if (_isPositionOccupiedBySameType(token, destination)) {
        print("Zug ungültig: Ein eigener Token befindet sich bereits auf der Startposition.");
        return;
      }

      _updateInitalPositions(token);
      _updateBoardState(token, destination, pathPosition);
      this.gameTokens[token.id].tokenPosition = destination;
      this.gameTokens[token.id].positionInPath = pathPosition;
      hasMovedToken = true;
      rollCount = 1; // Nach Einsetzen des Tokens nur noch ein Wurf zulassen
      notifyListeners();
    } else if (token.tokenState != TokenState.home) {
      // Token im Spielfeld bewegen
      int step = token.positionInPath + steps;
      if (step > 51) return;

      Position destination = _getPosition(token.type, step);
      int pathPosition = step;

      if (_isPositionOccupiedBySameType(token, destination)) {
        print("Zug ungültig: Ein eigener Token befindet sich bereits auf der Zielposition.");
        return;
      }

      var cutToken = _updateBoardState(token, destination, pathPosition);
      // Token-Bewegungslogik und Animation
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

      hasMovedToken = true;
      if (steps != 6) {
        noSixCount = 0;
        _switchToNextPlayer();
      }
    }

   // checkWinner(context);
  }

  bool _isPositionOccupiedBySameType(Token token, Position destination) {
    return gameTokens.any((tkn) =>
    tkn.type == token.type &&
        tkn.tokenPosition == destination &&
        tkn.id != token.id); // sicherstellen, dass es nicht der gleiche Token ist
  }


  Token? _updateBoardState(Token token, Position destination, int pathPosition) {
    Token? cutToken;

    // Prüfen, ob der Token auf einer "home"-Position bleibt
    if (isHomePosition(token, destination)) {
      this.gameTokens[token.id].tokenState = TokenState.home;
      print("home");
      return null;
    }

    // Prüfen, ob der Token in eine "safezone" gelangt
    if (isSafeZone(token, destination)) {
      this.gameTokens[token.id].tokenState = TokenState.safezone;
      print("safezone");
      return null;
    }

    // Prüfen, ob auf der Zielposition ein anderer Token steht
    List<Token> tokenAtDestination = this.gameTokens.where((tkn) => tkn.tokenPosition == destination).toList();

    // Wenn kein Token auf der Zielposition ist, setze den Token auf "normal"
    if (tokenAtDestination.isEmpty) {
      this.gameTokens[token.id].tokenState = TokenState.normal;
      print("normal");
      return null;
    }

    // Tokens desselben Spielertyps auf der Zielposition
    List<Token> tokenAtDestinationSameType = tokenAtDestination.where((tkn) => tkn.type == token.type).toList();

    // Wenn bereits ein eigener Token auf der Zielposition ist, ist der Zug ungültig
    if (tokenAtDestinationSameType.isNotEmpty) {
      print("Zug ungültig: Ein eigener Token befindet sich bereits auf dieser Position.");

      //setToken
      return null;
    }

    // Tokens verschiedener Spielertypen auf der Zielposition
    for (Token tkn in tokenAtDestination) {
      if (tkn.type != token.type && tkn.tokenState != TokenState.safezone) {
        cutToken = tkn;
      }
    }

    // Setze den Zustand des Tokens auf "normal", wenn er erfolgreich gezogen werden konnte
    this.gameTokens[token.id].tokenState = TokenState.normal;
    return cutToken;
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
        this.gameTokens[token.id].tokenState = TokenState.home;
        this.gameTokens[token.id].tokenPosition = this.greenInitital.removeAt(0);
        break;
      case TokenType.yellow:
        this.gameTokens[token.id].tokenState = TokenState.home;
        this.gameTokens[token.id].tokenPosition = this.yellowInitital.removeAt(0);
        break;
      case TokenType.blue:
        this.gameTokens[token.id].tokenState = TokenState.home;
        this.gameTokens[token.id].tokenPosition = this.blueInitital.removeAt(0);
        break;
      case TokenType.red:
        this.gameTokens[token.id].tokenState = TokenState.home;
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
