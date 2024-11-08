import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../gameengine/model/dice_model.dart';
import '../gameengine/model/game_state.dart';
import 'package:just_audio/just_audio.dart';

class Dice extends StatefulWidget {
  const Dice({super.key});

  @override
  State<Dice> createState() => _DiceState();
}

class _DiceState extends State<Dice> {
  AudioPlayer player = AudioPlayer();
  double _currentAngle = 0;
  Timer? _rotationTimer;
  bool animateDice = false; //für async -> animation -> sonst schleife

  Future<void> updateDices(DiceModel dice, GameState gameState) async {
    if (animateDice == false) {
      if (gameState.isAllowedToRoll && gameState.getRemainingRolls() > 0) {
        if (gameState.getRemainingRolls() == 0) {
          return;
        }

        setState(() {
          animateDice = true;
          _currentAngle = Random().nextDouble() * 2 * pi;
        });

        await player.setAsset('assets/audios/rolling-dice.mp3');
        player.play();

        _rotationTimer =
            Timer.periodic(const Duration(milliseconds: 50), (timer) {
          setState(() {
            _currentAngle += pi / 6; // 30 Grad pro Schritt
          });
        });

        for (int i = 0; i < 6; i++) {
          var duration = 100 + i * 100;
          Future.delayed(Duration(milliseconds: duration), () {
            dice.setDiceOne(Random().nextInt(6) + 1);
          });
        }

        Future.delayed(Duration(milliseconds: 600), () {
          gameState.rollDice(dice);
          animateDice = false;
          _rotationTimer?.cancel();
          setState(() {
            _currentAngle = 0;
          });
        });
      } else {
        print(
            "Der Spieler muss erst seinen Token bewegen, bevor er erneut würfeln kann.");
      }
    }
  }

  @override
  void dispose() {
    _rotationTimer?.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> _diceImages = [
      "assets/images/0.png", // Bild für 0 Würfe
      "assets/images/1.png",
      "assets/images/2.png",
      "assets/images/3.png",
      "assets/images/4.png",
      "assets/images/5.png",
      "assets/images/6.png",
    ];

    final dice = Provider.of<DiceModel>(context);
    final gameState = Provider.of<GameState>(context, listen: false);

    return GestureDetector(
      onTap: () => updateDices(dice, gameState),
      child: SizedBox(
        width: 60,
        height: 60,
        child: Transform.rotate(
          angle: _currentAngle,
          child: Image.asset(
            _diceImages[dice.diceOne],
            gaplessPlayback: true,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
