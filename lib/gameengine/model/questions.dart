import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class QuestionTest {
  String questionText;
  List<String> options;
  int correctAnswerIndex;

  QuestionTest({
    this.questionText = '',
    this.options = const [],
    this.correctAnswerIndex = -1,
  });

  //Fragen müssen noch überarbeitet werden!!
  static List<QuestionTest> questions = [
    QuestionTest(
      questionText: 'Welche Farbe hat der Himmel?',
      options: ['Grün', 'Rot', 'Blau'],
      correctAnswerIndex: 2,
    ),
    QuestionTest(
      questionText: 'Wie viele Kontinente gibt es?',
      options: ['5', '6', '7'],
      correctAnswerIndex: 2,
    ),
    QuestionTest(
      questionText: 'Wie viele Beine hat eine Spinne?',
      options: ['6', '8', '10'],
      correctAnswerIndex: 1,
    ),
  ];

  Future<bool> showRandomQuestionDialog(BuildContext context) async {
    final randomQuestion = questions[Random().nextInt(questions.length)];
    final Completer<bool> completer = Completer<bool>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(randomQuestion.questionText),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: randomQuestion.options
                .asMap()
                .entries
                .map(
                  (option) => ListTile(
                    title: Text(option.value),
                    onTap: () {
                      final isCorrect =
                          option.key == randomQuestion.correctAnswerIndex;
                      Navigator.of(context).pop();
                      completer.complete(isCorrect);
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
    return completer.future;
  }
}
