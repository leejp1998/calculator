import 'package:audioplayers/audioplayers.dart';
import 'package:calculator/buttons.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
  }

class _CalculatorState extends State<Calculator> {

  var userQuestion = '';
  var userAnswer = '';
  bool isLastTappedOperator = false;
  bool isLastTappedEvaluate = false;

  final List<String> buttons = [
    'C', 'DEL', '%', String.fromCharCode(247), //division
    '7', '8', '9', String.fromCharCode(215), //multiplication
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    'ANS', '0', '.', '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/coco.png'), fit: BoxFit.fitWidth, opacity: 0.5,),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(height: 50,),
                  Container(
                    // equation
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    child: Text(userQuestion, style: TextStyle(fontSize: 30, color: isLastTappedEvaluate ? Colors.indigo[900] : Colors.blueGrey[900]),),
                  ),
                  Container(
                    // answer
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    child: Text(userAnswer, style: TextStyle(fontSize: 20, color: Colors.blueGrey[700]),),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.blue[200],
              child: Container(
                child: GridView.builder(
                  itemCount: buttons.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,),
                    itemBuilder: (BuildContext context, int idx) {
                      if (idx == 0) {
                        // clear button
                        return MyButton(
                          color: Colors.purple[300],
                          textColor: Colors.white,
                          buttonText: buttons[idx],
                          buttonTapped: () {
                            setState(() {
                              userQuestion = '';
                              userAnswer = '';
                              isLastTappedOperator = false;
                            });
                          },);
                      } else if (idx == 1) {
                        // delete button
                        return MyButton(
                          color: isOperator(buttons[idx]) ? Colors.blue : Colors.blue[50],
                          textColor: isOperator(buttons[idx]) ? Colors.white : Colors.blue,
                          buttonText: buttons[idx],
                          buttonTapped: () {
                            setState(() {
                              userQuestion = userQuestion.substring(0, userQuestion.length - 1);
                              isLastTappedOperator = equationEndWithOperator(userQuestion);
                              evaluateEquation();
                            });
                          },);
                      } else if (idx == buttons.length - 1) {
                        // equal button
                        return MyButton(
                            color: Colors.blue,
                            textColor: Colors.white,
                            buttonText: buttons[idx],
                            buttonTapped: () {
                              AudioPlayer().play(AssetSource('audio/cat_meow.mp3'));
                              setState(() {
                                pressEvaluateButton();
                              });
                        },);
                      } else {
                        return MyButton(
                          color: isOperator(buttons[idx]) ? Colors.blue : Colors.blue[50],
                          textColor: isOperator(buttons[idx]) ? Colors.white : Colors.blue,
                          buttonText: buttons[idx],
                          buttonTapped: () {
                            setState(() {
                              if (!isOperator(buttons[idx]) && isLastTappedEvaluate) {
                                userQuestion = '';
                                isLastTappedOperator = false;
                              } else if (!isOperator(buttons[idx])) {
                                isLastTappedOperator = false;
                              } else if (isOperator(buttons[idx]) && isLastTappedOperator) {
                                userQuestion = userQuestion.substring(0, userQuestion.length - 1);
                                isLastTappedOperator = true;
                              } else {
                                isLastTappedOperator = true;
                              }
                              userQuestion += buttons[idx];
                            });
                            evaluateEquation();
                          },);
                      }
                    },
                )
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isOperator(String s) {
    if (s == '%' || s == String.fromCharCode(247) || s == String.fromCharCode(215) || s == '-' || s == '+') {
      return true;
    }
    return false;
  }

  void evaluateEquation() {
    if (isLastTappedEvaluate) {
      setState(() {
        isLastTappedEvaluate = false;
      });
    }
    if (equationEndWithOperator(userQuestion)) {
      setState(() {
        userAnswer = '';
      });
      return;
    }

    String finalQuestion = userQuestion;
    finalQuestion = finalQuestion.replaceAll(String.fromCharCode(215), '*');
    finalQuestion = finalQuestion.replaceAll(String.fromCharCode(247), '/');

    Parser p = Parser();
    Expression exp = p.parse(finalQuestion);

    ContextModel cm = ContextModel();
    double ans = exp.evaluate(EvaluationType.REAL, cm);

    if (ans == ans.roundToDouble()) {
      userAnswer = ans.round().toString();
    } else {
      userAnswer = ans.toString();
    }
  }
  
  bool equationEndWithOperator(String equation) {
    return equation.endsWith(String.fromCharCode(247)) ||
        equation.endsWith(String.fromCharCode(215)) ||
        equation.endsWith('-') ||
        equation.endsWith('+');
  }

  void pressEvaluateButton() {
    setState(() {
      userQuestion = userAnswer;
      userAnswer = '';
      isLastTappedEvaluate = true;
    });
  }
}
