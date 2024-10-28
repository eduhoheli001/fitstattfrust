import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../gameengine/model/dice_model.dart';
import '../gameengine/model/game_state.dart';


class Dice extends StatelessWidget {
  const Dice({super.key});

  void updateDices(DiceModel dice, GameState gameState) {
    if (gameState.getRemainingRolls() == 0) {
      dice.setDiceOne(0); // Setzt das Bild auf 0.png, wenn keine verbleibenden Würfe vorhanden sind
      return;
    }

    // Animation für den Würfel
    for (int i = 0; i < 6; i++) {
      var duration = 100 + i * 100;
      Future.delayed(Duration(milliseconds: duration), () {
        dice.setDiceOne(Random().nextInt(6) + 1);
      });
    }

    Future.delayed(Duration(milliseconds: 600), () {
      int finalRoll = dice.generateDiceOne();
      gameState.rollDice(dice);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> _diceImages = [
      "assets/0.png", // Bild für 0 Würfe
      "assets/1.png",
      "assets/2.png",
      "assets/3.png",
      "assets/4.png",
      "assets/5.png",
      "assets/6.png",
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
            SizedBox(width: 10),
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
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}


