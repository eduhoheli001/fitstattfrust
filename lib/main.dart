import 'package:flutter/material.dart';
import './gameengine/model/game_state.dart';
import './widgets/gameplay.dart';
import 'package:provider/provider.dart';
import './widgets/dice.dart';
import './gameengine/model/dice_model.dart';
import 'gameengine/model/token.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fit statt frust',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => GameState()),
          ChangeNotifierProvider(create: (context) => DiceModel()),
        ],
        child: GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GlobalKey keyBar = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    int remainingRolls = gameState.getRemainingRolls();
    final dice = Provider.of<DiceModel>(context);
    final List<Map<String, dynamic>> playerOptions = [
      {'color': Colors.green, 'name': 'Grün', 'type': TokenType.green},
      {'color': Colors.yellow, 'name': 'Gelb', 'type': TokenType.yellow},
      {'color': Colors.blue, 'name': 'Blau', 'type': TokenType.blue},
      {'color': Colors.red, 'name': 'Rot', 'type': TokenType.red},
    ];
    return Scaffold(
      appBar: AppBar(
        key: keyBar,
        title: Text('Fit statt Frust'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Spiel Optionen',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.refresh),
              title: Text('Spiel zurücksetzen'),
              onTap: () {
                Navigator.pop(context);
                gameState.resetGame();
              },
            ),
            if (gameState.debugmode)
              ListTile(
                leading: Icon(Icons.bug_report),
                title: Text('Debugger'),
                onTap: () {
                  Navigator.pop(context);
                  gameState.debugModeSetToken();
                },
              ),
            if (gameState.debugmode)
              ListTile(
                leading: Icon(Icons.people),
                title: Text('Spieler auswählen'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Wähle einen Spieler aus'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: playerOptions.map((option) {
                            return ListTile(
                              leading:
                                  Icon(Icons.circle, color: option['color']),
                              title: Text(option['name']),
                              onTap: () {
                                setState(() {
                                  gameState.setCurrentPlayer(option['type']);
                                  gameState.rollCount = 0;
                                  gameState.isAllowedToRoll = true;
                                });
                                Navigator.of(context).pop();
                              },
                            );
                          }).toList(),
                        ),
                      );
                    },
                  );
                },
              ),
            if (gameState.debugmode)
              ListTile(
                leading: Icon(Icons.casino),
                title: Text('Würfelwert auswählen'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Wähle einen Würfelwert'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(7, (index) => index)
                              .map((int value) {
                            return ListTile(
                              leading: Icon(
                                Icons.casino,
                                color: value == 0 ? Colors.grey : Colors.black,
                              ),
                              title: Text(value.toString()),
                              onTap: () {
                                dice.setDiceOne(value);
                                gameState.isAllowedToRoll = false;
                                Navigator.of(context).pop();
                              },
                            );
                          }).toList(),
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Card(
              elevation: 8,
              child: Container(
                width: double.infinity,
                color: gameState.getColorCurrentPlayer(),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Aktueller Spieler: ${gameState.getCurrentPlayerName()}",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Verbleibende Würfe: $remainingRolls",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black38,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(padding: const EdgeInsets.all(8), child: Dice()),
                  ],
                ),
              ),
            ),
          ),
          GamePlay(keyBar, gameState),
        ],
      ),
    );
  }
}
