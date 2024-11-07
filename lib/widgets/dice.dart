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

  Future<void> updateDices(DiceModel dice, GameState gameState) async {
    if(gameState.isAllowedToRoll && gameState.getRemainingRolls() > 0) {

      if (gameState.getRemainingRolls() == 0) {
        return;
      }
      await player.setAsset('assets/audios/rolling-dice.mp3');
      player.play();

      for (int i = 0; i < 6; i++) {
        var duration = 100 + i * 100;
        Future.delayed(Duration(milliseconds: duration), () {
          dice.setDiceOne(Random().nextInt(6) + 1);
        });
      }
      Future.delayed(Duration(milliseconds: 600), () {
        gameState.rollDice(dice);
      });
    } else {
      print("Der Spieler muss erst seinen Token bewegen, bevor er erneut würfeln kann.");
    }

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

    return Card(
      elevation: 10,
      child: Container(
        padding: EdgeInsets.all(8),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => updateDices(dice, gameState),
              child: Container(
                width: 40,
                height: 40,
                child: Image.asset(
                  _diceImages[dice.diceOne],
                  gaplessPlayback: true,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            if(gameState.debugmode)
            SizedBox(width: 10),
            if(gameState.debugmode)
            DropdownButton<int>(
              value: dice.diceOne,
              items: List.generate(7, (index) => index).map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  dice.setDiceOne(newValue); // für Debugging
                  //gameState.rollCount = 0;
                  gameState.isAllowedToRoll = false;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}


