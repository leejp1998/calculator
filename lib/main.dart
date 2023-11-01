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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(height: 50,),
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerLeft,
                    child: Text(userQuestion, style: TextStyle(fontSize: 20),),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    child: Text(userAnswer, style: TextStyle(fontSize: 20),),
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
                            });
                          },);
                      } else if (idx == buttons.length - 1) {
                        // equal button
                        return MyButton(
                            color: Colors.blue,
                            textColor: Colors.white,
                            buttonText: buttons[idx],
                            buttonTapped: () {
                              setState(() {
                                evaluateEquation();
                              });
                        },);
                      } else {
                        return MyButton(
                          color: isOperator(buttons[idx]) ? Colors.blue : Colors.blue[50],
                          textColor: isOperator(buttons[idx]) ? Colors.white : Colors.blue,
                          buttonText: buttons[idx],
                          buttonTapped: () {
                            setState(() {
                              userQuestion += buttons[idx];
                            });
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
    String finalQuestion = userQuestion;
    finalQuestion = finalQuestion.replaceAll(String.fromCharCode(215), '*');
    finalQuestion = finalQuestion.replaceAll(String.fromCharCode(247), '/');

    Parser p = Parser();
    Expression exp = p.parse(finalQuestion);

    ContextModel cm = ContextModel();
    double ans = exp.evaluate(EvaluationType.REAL, cm);

    userAnswer = ans.toString();
  }
}
