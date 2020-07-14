import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'quiz_brain.dart';

QuizBrain quizBrain = QuizBrain();

void main() {
  runApp(QuizzlerApp());
}

class QuizzlerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromRGBO(6, 20, 26, 1),
        body: Quiz(),
      ),
    );
  }
}

class Quiz extends StatefulWidget {
  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  //List to store scores
  List<Icon> scoreKeeper = [];

  void checkAnswer(bool userAnswer) {
    bool correctAnswer = quizBrain.getAnswer();
    setState(() {
      if (quizBrain.isFinished()) {
        int total = quizBrain.totalRightAnswers();
        quizBrain.reInitialize();
        var alertStyle = AlertStyle(
          backgroundColor: Color.fromRGBO(177, 182, 199, 1),
          animationType: AnimationType.fromBottom,
          isCloseButton: false,
          isOverlayTapDismiss: false,
          alertBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          titleStyle: TextStyle(
              color: Color.fromRGBO(14, 38, 99, 1),
              fontWeight: FontWeight.bold),
        );
        Alert(
            context: context,
            style: alertStyle,
            type: AlertType.success,
            title: 'Congratulations!',
            desc: 'You\'ve completed the quiz.You score is $total.',
            buttons: [
              DialogButton(
                child: Text(
                  'Reset',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  setState(() {
                    scoreKeeper = [];
                    quizBrain.reset();
                    Navigator.pop(context);
                  });
                },
              ),
              DialogButton(
                child: Text(
                  'Close App',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  setState(() {
                    exit(0);
                  });
                },
              )
            ]).show();
      } else {
        if (correctAnswer == userAnswer) {
          scoreKeeper.add(
            Icon(
              Icons.check,
              color: Color.fromRGBO(124, 242, 139, 1),
            ),
          );
          quizBrain.rightlyAnswered();
        } else {
          scoreKeeper
              .add(Icon(Icons.close, color: Color.fromRGBO(107, 78, 78, 1)));
        }

        quizBrain.nextQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Question/text area
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SafeArea(
              child: Center(
                child: Text(
                  quizBrain.getQuestionText(),
                  style: TextStyle(fontSize: 25.0, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        //true button
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: FlatButton(
              color: Color.fromRGBO(109, 163, 65, 1),
              child: Text(
                'True',
                style: TextStyle(color: Colors.white, fontSize: 17.0),
              ),
              onPressed: () {
                checkAnswer(true);
              },
            ),
          ),
        ),
        //false button "flat button"
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: FlatButton(
              color: Color.fromRGBO(191, 138, 17, 1),
              child: Text(
                'False',
                style: TextStyle(color: Colors.white, fontSize: 17.0),
              ),
              onPressed: () {
                checkAnswer(false);
              },
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        )
      ],
    );
  }
}
