import 'package:flutter/material.dart';
import './gameengine/model/game_state.dart';
import './widgets/gameplay.dart';
import 'package:provider/provider.dart';
import './widgets/dice.dart';
import './gameengine/model/dice_model.dart';

void main() => runApp(FitStattFrust());
class FitStattFrust extends StatelessWidget {
  const FitStattFrust({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fit statt Frust',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => GameState()),
          ChangeNotifierProvider(create: (context) => DiceModel()),
        ],
        child: MyHomePage(title: 'Fit statt Frust Spiel'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey keyBar = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    return Scaffold(
      appBar: AppBar(
        key: keyBar,
        title: Text('Fit statt Frust'),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 20,
              child: Text(
                "Aktueller Spieler: ${gameState.getCurrentPlayerName()}",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
          GamePlay(keyBar, gameState),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              child:Dice()
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          child: Text(
            "Aktueller Spieler: ${gameState.getCurrentPlayerName()}",
            style: TextStyle(fontSize: 8, color: Colors.black),
          ),
        ),
      ),
     // floatingActionButton: ,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
