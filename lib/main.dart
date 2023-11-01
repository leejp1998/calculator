import 'package:calculator/buttons.dart';
import 'package:flutter/material.dart';

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

  final List<String> buttons = [
    'C', 'DEL', '%', '/',
    '7', '8', '9', 'x',
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
            child: Container(),
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
                        return MyButton(
                          color: Colors.purple[300],
                          textColor: Colors.white,
                          buttonText: buttons[idx],);
                      } else if (idx == 1) {
                        return MyButton(
                          color: Colors.green[300],
                          textColor: Colors.white,
                          buttonText: buttons[idx],);
                      } else {
                        return MyButton(
                          color: isOperator(buttons[idx]) ? Colors.blue : Colors.blue[50],
                          textColor: isOperator(buttons[idx]) ? Colors.white : Colors.blue,
                          buttonText: buttons[idx],);
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
    if (s == '%' || s == '/' || s == 'x' || s == '-' || s == '+') {
      return true;
    }
    return false;
  }
}
