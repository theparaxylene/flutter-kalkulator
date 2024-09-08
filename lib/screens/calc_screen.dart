import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

import '../widgets/history_box.dart';
import '../widgets/num_key.dart';
import 'history_screen.dart';

class CalcScreen extends StatefulWidget {
  const CalcScreen({super.key});

  @override
  State<CalcScreen> createState() => _CalcScreenState();
}

class _CalcScreenState extends State<CalcScreen> {
  final keys = [
    '=',
    'C',
    'DEL',
    '%',
    '7',
    '8',
    '9',
    '÷',
    '4',
    '5',
    '6',
    '×',
    '1',
    '2',
    '3',
    '-',
    '0',
    '00',
    '.',
    '+',
  ];

  var question = '';
  var submitted = '';
  var answer = '';
  final List<String> questionHistory = [];

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
                child: Column(
                  children: [
                    // QUESTION HISTORY
                    SizedBox(
                      height: 72,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: HistoryBox(
                              solved: questionHistory.reversed.toList(),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: questionHistory.isNotEmpty
                                ? TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HistoryScreen(
                                            solvedQuestions: questionHistory,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'EXPAND',
                                      style: TextStyle(
                                        color: Colors.indigo.shade900,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ],
                      ),
                    ),

                    // QUESTION
                    // const SizedBox(height: 20),
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
                              // 'answer',
                              answer,
                              style: const TextStyle(fontSize: 48),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // DIVIDER
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 10,
              ),
              child: Container(
                color: Colors.black12,
                width: double.infinity,
                height: 2,
              ),
            ),

            // KEYBOARD
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.builder(
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
                ),
              ),
            ),
          ],
        ),
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
        answer = eval.toString();
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

      // prevent from adding duplicates
      if (!questionHistory.contains('$submitted$question = $answer')) {
        questionHistory.add('$submitted$question = $answer');
      }
    }
  }

  void onKeyTap(int index) {
    setState(() {
      // =
      if (index == 0) {
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
        }
      }

      // %
      else if (index == 3) {
        if (answer.isNotEmpty) {
          question = answer;
          answer = '';
          submitted = '';
        }
        question = double.parse('${double.parse(question) / 100}')
            .toStringAsFixed(question.length);
      }

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
    return Colors.indigo.shade900;
  } else if ((index + 1) % 4 == 0) {
    return Colors.indigo.shade900;
  } else {
    return Colors.black54;
  }
}
