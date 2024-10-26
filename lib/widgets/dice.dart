import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../gameengine/model/dice_model.dart';
class Dice extends StatelessWidget {
  void updateDices(DiceModel dice) {
    for (int i = 0; i < 6; i++) {
      var duration = 100 + i * 100;
      Future.delayed(Duration(milliseconds: duration), () {
        dice.generateDiceOne();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> _diceOneImages = [
      "assets/1.png",
      "assets/2.png",
      "assets/3.png",
      "assets/4.png",
      "assets/5.png",
      "assets/6.png",
    ];
    final dice = Provider.of<DiceModel>(context);
    final c = dice.diceOneCount;
    var img = Image.asset(
      _diceOneImages[c - 1],
      gaplessPlayback: true,
      fit: BoxFit.fill,
    );

    return Card(
      elevation: 10,
      child: Container(
        padding: EdgeInsets.all(8), // Optional: Padding für ästhetische Anpassung
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () => updateDices(dice),
              child: Container(
                width: 40,
                height: 40,
                child: img,
              ),
            ),
            SizedBox(width: 10), // Optional: Abstand zwischen Würfel und Dropdown
            DropdownButton<int>(
              value: dice.diceOne,
              items: List.generate(6, (index) => index + 1)
                  .map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  dice.setDiceOne(newValue);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}


