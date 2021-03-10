import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SimpleCalculator(),
    );
  }
}

class SimpleCalculator extends StatefulWidget {
  @override
  _SimpleCalculatorState createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "0";
        result = "0";
        equationFontSize = 38.0;
        resultFontSize = 48.0;
      } else if (buttonText == "±") {
        if (equation.contains('-')) {
          equation = equation.substring(1);
        } else if (equation != "0") {
          equation = '-' + equation;
        }
      } else if (buttonText == "=") {
        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          result = "Error";
        }
      } else {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        if (equation == "0") {
          equation = buttonText;
        } else if (isOperation(buttonText) && endsWithOperation(equation)) {
          equation = equation.substring(0,equation.length-1) + buttonText;
        } else {
          equation += buttonText;
        }
      }
    });
  }

  Widget buildButton(
      String buttonText, double buttonHeight, Color buttonColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      color: buttonColor,
      child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
              side: BorderSide(
                  color: Colors.black, width: 1, style: BorderStyle.solid)),
          padding: EdgeInsets.all(16.0),
          onPressed: () => buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(
              equation,
              style: TextStyle(fontSize: equationFontSize, color: Colors.white),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Text(
              result,
              style: TextStyle(fontSize: resultFontSize, color: Colors.white),
            ),
          ),
          Expanded(
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 1,
                child: Table(
                  children: [
                    TableRow(children: [
                      buildButton("C", 1, Color.fromARGB(255, 86, 88, 89)),
                      buildButton("±", 1, Color.fromARGB(255, 86, 88, 89)),
                      buildButton("%", 1, Color.fromARGB(255, 86, 88, 89)),
                      buildButton("÷", 1, Color.fromARGB(255, 243, 162, 59)),
                    ]),
                    TableRow(children: [
                      buildButton("7", 1, Color.fromARGB(255, 113, 115, 117)),
                      buildButton("8", 1, Color.fromARGB(255, 113, 115, 117)),
                      buildButton("9", 1, Color.fromARGB(255, 113, 115, 117)),
                      buildButton("×", 1, Color.fromARGB(255, 243, 162, 59)),
                    ]),
                    TableRow(children: [
                      buildButton("4", 1, Color.fromARGB(255, 113, 115, 117)),
                      buildButton("5", 1, Color.fromARGB(255, 113, 115, 117)),
                      buildButton("6", 1, Color.fromARGB(255, 113, 115, 117)),
                      buildButton("-", 1, Color.fromARGB(255, 243, 162, 59)),
                    ]),
                    TableRow(children: [
                      buildButton("1", 1, Color.fromARGB(255, 113, 115, 117)),
                      buildButton("2", 1, Color.fromARGB(255, 113, 115, 117)),
                      buildButton("3", 1, Color.fromARGB(255, 113, 115, 117)),
                      buildButton("+", 1, Color.fromARGB(255, 243, 162, 59)),
                    ]),
                    TableRow(children: [
                      buildButton("0", 1, Color.fromARGB(255, 113, 115, 117)),
                      buildButton("0", 1, Color.fromARGB(255, 113, 115, 117)),
                      buildButton(".", 1, Color.fromARGB(255, 113, 115, 117)),
                      buildButton("=", 1, Color.fromARGB(255, 243, 162, 59)),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool isOperation(String buttonText) {
    if (buttonText == '÷' ||
        buttonText == '×' ||
        buttonText == '-' ||
        buttonText == '+')
      return true;
    else
      return false;
  }

  bool endsWithOperation(String equation) {
    var last = equation[equation.length-1];
    if (last == '÷' || last == '×' || last == '-' || last == '+')
      return true;
    else
      return false;
  }
}
