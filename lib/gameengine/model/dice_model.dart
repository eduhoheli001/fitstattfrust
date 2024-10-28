import 'dart:math';
import 'package:flutter/material.dart';
class DiceModel with ChangeNotifier {
  int diceOne = 1;

  int get diceOneCount => diceOne;

  int generateDiceOne() {
    diceOne = Random().nextInt(6) + 1;
    print("diceOne: $diceOne");
    notifyListeners();
    return diceOne;
  }

  void setDiceOne(int value) {
    diceOne = value;
    print("Manual diceOne set to: $diceOne");
    notifyListeners();
  }


}