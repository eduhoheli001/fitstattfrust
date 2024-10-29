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
  int getPositionInPath(TokenType type, Position tokenPosition) {
    List<List<int>> path;

    switch (type) {
      case TokenType.green:
        path = Path.greenPath;
        break;
      case TokenType.yellow:
        path = Path.yellowPath;
        break;
      case TokenType.blue:
        path = Path.bluePath;
        break;
      case TokenType.red:
        path = Path.redPath;
        break;
    }

    for (int i = 0; i < path.length; i++) {
      if (path[i][0] == tokenPosition.row && path[i][1] == tokenPosition.column) {
        return i;
      }
    }

    // Gibt -1 zurück, wenn die Position nicht gefunden wird
    return -1;
  }

  void debugModeSetToken() {


    gameTokens[0].tokenPosition = Position(7, 1);
    gameTokens[0].positionInPath = getPositionInPath(gameTokens[0].type, gameTokens[0].tokenPosition);
    gameTokens[0].tokenState = TokenState.normal;

    gameTokens[1].tokenPosition = Position(8, 1);
    gameTokens[1].positionInPath = getPositionInPath(gameTokens[1].type, gameTokens[1].tokenPosition);
    gameTokens[1].tokenState = TokenState.normal;

    gameTokens[2].tokenPosition = Position(8, 2);
    gameTokens[2].positionInPath = getPositionInPath(gameTokens[2].type, gameTokens[2].tokenPosition);
    gameTokens[2].tokenState = TokenState.normal;

    gameTokens[3].tokenPosition = Position(8, 3);
    gameTokens[3].positionInPath = getPositionInPath(gameTokens[3].type, gameTokens[3].tokenPosition);
    gameTokens[3].tokenState = TokenState.normal;


    hasMovedToken = false;
    rollCount = 1;
    noSixCount = 0;

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

    // Zurücksetzen, um dem Spieler die Möglichkeit zu geben, den Zug zu nutzen
    hasMovedToken = false;
    notifyListeners();

    if (getRemainingRolls() == 0) {
      print("Keine verbleibenden Würfe");
      diceModel.setDiceOne(0); // Setzt auf 0.png, wenn keine Würfe mehr vorhanden sind
      _switchToNextPlayer();
      return;
    }

    // Überprüfen, ob der Spieler einen Token im Spiel hat
    bool hasTokenInPlay = gameTokens.any((token) =>
    token.type == currentPlayer &&
        token.tokenState != TokenState.home);

    // Spieler hat keinen Token im Spiel und keine 6 geworfen
    if (!hasTokenInPlay && diceRoll != 6) {
      rollCount++;
      if (rollCount >= 3) {
        rollCount = 0;
        _switchToNextPlayer();
      }
    } else if (diceRoll == 6) {
      rollCount = hasTokenInPlay ? 1 : 0; // Nur einen weiteren Wurf, wenn Token im Spiel ist
      print("6 geworfen, der Spieler darf erneut würfeln.");
    } else {
      print("Warten auf Bewegung des Spielers...");
    }
  }

  void moveToken(Token token, int steps, DiceModel diceModel, BuildContext context) {
    if (hasMovedToken) {
      print("Token kann nicht bewegt werden. Bitte würfeln Sie erneut.");
      return;
    }

    if (!isCurrentPlayer(token)) return;

    Position destination;
    int pathPosition;


    // Token von home ins Spiel bringen, wenn eine 6 geworfen wurde
    if (token.tokenState == TokenState.home && steps == 6) {
      noSixCount = 0;
      destination = _getPosition(token.type, 0);
      pathPosition = 0;

      // Sicherstellen, dass die Position nicht von einem eigenen Token besetzt ist
      if (_isPositionOccupiedBySameType(token, destination)) {
        print("if 1 Zug ungültig: Ein eigener Token befindet sich bereits auf der Startposition.");
        return;
      }

      // Prüfen, ob ein gegnerischer Token auf der Zielposition ist und ggf. entfernen
      var cutToken = _updateBoardState(token, destination, pathPosition);

      // Wenn ein gegnerischer Token vorhanden ist, wird dieser animiert zurückgesetzt
      if (cutToken != null) {
        animateCutTokenReset(cutToken);
      }

      _updateInitalPositions(token);

      this.gameTokens[token.id].tokenPosition = destination;
      this.gameTokens[token.id].positionInPath = pathPosition;
      this.gameTokens[token.id].tokenState = TokenState.normal;

      print("positionpath ${this.gameTokens[token.id].positionInPath}");
      print("positionpath ${this.gameTokens[token.id].tokenPosition}");

      hasMovedToken = true;
      rollCount = 1; //setzt würfel zurück auf eins
      notifyListeners();
    } else if (token.tokenState != TokenState.home) {
      // Token im Spielfeld bewegen
      int step = token.positionInPath + steps;
      if (step > 51) return;

      destination = _getPosition(token.type, step);
      pathPosition = step;

      print("positionpath2 ${destination}");
      print("positionpath2 ${pathPosition}");


      // Sicherstellen, dass Zielposition nicht von eigenem Token besetzt ist
      if (_isPositionOccupiedBySameType(token, destination)) {
        print("Zug ungültig: Ein eigener Token befindet sich bereits auf der Zielposition.");
        return;
      }
      var cutToken = _updateBoardState(token, destination, pathPosition);

      // Bewegung animieren
      animateTokenMovement(token, steps);
      // Animation für das Zurücksetzen des geschlagenen Tokens
      if (cutToken != null) {
        animateCutTokenReset(cutToken);
      }


      hasMovedToken = true;
      if (steps != 6) {
        noSixCount = 0;
        _switchToNextPlayer();
      }

    }
  }
  // Token-Bewegungsanimation für reguläre Schritte
  void animateTokenMovement(Token token, int steps) {
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
  }

// Animation für das Zurücksetzen eines geschlagenen Tokens
  void animateCutTokenReset(Token cutToken) {
    int cutSteps = cutToken.positionInPath;
    int duration = 0;
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



  bool _isPositionOccupiedBySameType(Token token, Position destination) {
    return gameTokens.any((tkn) =>
    tkn.type == token.type &&
        tkn.tokenPosition == destination &&
        tkn.id != token.id);
  }


  Token? _updateBoardState(Token token, Position destination, int pathPosition) {
    Token? cutToken;

    // Prüfen, ob der Token auf einer "home"-Position bleibt
    if (isHomePosition(token, destination)) {
      gameTokens[token.id].tokenState = TokenState.home;
      print("_updateBoardState: home");
      return null;
    }

    // Prüfen, ob der Token in eine "safezone" gelangt
    if (isSafeZone(token, destination)) {
      gameTokens[token.id].tokenState = TokenState.safezone;
      print("_updateBoardState: safezone");
      return null;
    }

    // Prüfen, ob auf der Zielposition ein anderer Token steht
    List<Token> tokenAtDestination = gameTokens.where((tkn) => tkn.tokenPosition == destination).toList();

    // Wenn kein Token auf der Zielposition ist, setze den Token auf "normal"
    if (tokenAtDestination.isEmpty) {
      gameTokens[token.id].tokenState = TokenState.normal;
      print("_updateBoardState: normal");
      return null;
    }

    // Tokens verschiedener Spielertypen auf der Zielposition
    for (Token tkn in tokenAtDestination) {
      if (tkn.type != token.type && tkn.tokenState != TokenState.safezone) {
        cutToken = tkn;
        print("_updateBoardState: Ein Token wurde gekickt.");
        break;
      }
    }

    // Setze den Zustand des Tokens auf "normal", wenn er erfolgreich gezogen werden konnte
    gameTokens[token.id].tokenState = TokenState.normal;
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
        print("0: ${node[0]} 1: ${node[1]}");
        break;
      case TokenType.yellow:
        List<int> node = Path.yellowPath[step];
        destination = Position(node[0], node[1]);
        print("0: ${node[0]} 1: ${node[1]}");
        break;
      case TokenType.blue:
        List<int> node = Path.bluePath[step];
        destination = Position(node[0], node[1]);
        print("0: ${node[0]} 1: ${node[1]}");
        break;
      case TokenType.red:
        List<int> node = Path.redPath[step];
        destination = Position(node[0], node[1]);
        print("0: ${node[0]} 1: ${node[1]}");
        break;
    }
    return destination;
  }
}
