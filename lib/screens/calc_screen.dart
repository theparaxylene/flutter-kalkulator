import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:intl/intl.dart';

import '../widgets/num_key.dart';

class CalcScreen extends StatefulWidget {
  const CalcScreen({super.key});

  @override
  State<CalcScreen> createState() => _CalcScreenState();
}

class _CalcScreenState extends State<CalcScreen> {
  final keys = [
    'SC',
    'C',
    'DEL',
    '÷',
    '7',
    '8',
    '9',
    '×',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '00',
    '.',
    '=',
  ];

  var question = '';
  var submitted = '';
  var answer = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blueGrey.shade50,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // QUESTION
                      SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                submitted + question,
                                // 'question',
                                style: TextStyle(
                                  fontSize: 36,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //ANSWER
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          reverse: true,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                answer.isNotEmpty
                                    ? '= ${NumberFormat.decimalPattern().format(double.parse(answer))}'
                                    : answer,
                                style: TextStyle(
                                  fontSize: answer.length > 9
                                      ? 64 - (answer.length * 0.5)
                                      : 64,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // DIVIDER
            // getDivider(),

            // KEYBOARD
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: getKeyboard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GridView getKeyboard() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisExtent: 80,
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) => NumKey(
        text: keys[index],
        keyColor: getKeyColor(index),
        textColor: getTextColor(index),
        onTap: () {
          onKeyTap(index);
        },
      ),
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  Padding getDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 10,
      ),
      child: Container(
        color: Colors.black12,
        width: double.infinity,
        height: 2,
      ),
    );
  }

  void solve() {
    var finalQuestion = submitted + question;

    if (finalQuestion.isNotEmpty) {
      finalQuestion = finalQuestion.replaceAll('×', '*');
      finalQuestion = finalQuestion.replaceAll('÷', '/');

      Parser p = Parser();
      Expression exp = p.parse(finalQuestion);
      ContextModel cm = ContextModel();

      double eval = exp.evaluate(EvaluationType.REAL, cm);

      // to check if eval has decimals
      if (eval % 1 == 0) {
        answer = eval.toStringAsFixed(0);
      } else {
        answer = '$eval';
        // to check if has recurring decimals
        if (answer.split('.')[1].length > 6) {
          if (answer.split('.')[1].substring(0, 3) ==
              answer.split('.')[1].substring(3, 6)) {
            answer = eval.toStringAsFixed(3);
          }
        }
        if (answer.split('.')[1].length > 9) {
          answer = eval.toStringAsFixed(10);
        }
      }
    }
  }

  void onKeyTap(int index) {
    setState(() {
      // SCIENTIFIC
      if (index == 0) {
        // change to scientific keyboard
      }

      // =
      else if (index == 19) {
        solve();
      }

      // C
      else if (index == 1) {
        question = '';
        submitted = '';
        answer = '';
      }

      // DEL
      else if (index == 2) {
        if (question.isNotEmpty) {
          question = question.substring(0, question.length - 1);
        } else {
          submitted = submitted.trim();
          if (submitted.isNotEmpty) {
            submitted = submitted.substring(0, submitted.length - 1);
          }
        }
      }

      // %
      // else if (index == 3) {
      //   if (answer.isNotEmpty) {
      //     question = answer;
      //     answer = '';
      //     submitted = '';
      //   }
      //   question = double.parse('${double.parse(question) / 100}')
      //       .toStringAsFixed(question.length);
      // }

      // Operators
      else if ((index + 1) % 4 == 0) {
        if (question.isNotEmpty) {
          if (answer.isNotEmpty) {
            submitted = answer;
            answer = '';
            question = '';
          }
          submitted += '$question ${keys[index]} ';
          question = '';
        }
      }

      // .
      else if (index == 18) {
        if (answer.isNotEmpty) {
          answer = '';
          question = '';
          submitted = '';
        }
        if (!question.contains('.')) {
          if (question.isEmpty) {
            question += '0';
          }
          question += keys[index];
        }
      }

      // Numbers
      else {
        if (answer.isNotEmpty) {
          question = '';
          answer = '';
          submitted = '';
        }
        question += keys[index];
      }
    });
  }
}

Color getKeyColor(int index) {
  if (index == 0) {
    return Colors.indigo.shade900;
  } else {
    return Colors.indigo.shade100.withOpacity(0.25);
  }
}

Color getTextColor(int index) {
  if (index == 0) {
    return Colors.indigo.shade100;
  } else if (index < 3) {
    return Colors.red.shade400;
  } else if ((index + 1) % 4 == 0) {
    return Colors.indigo.shade900;
  } else {
    return Colors.black54;
  }
}
