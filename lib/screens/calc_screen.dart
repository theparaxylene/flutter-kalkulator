import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

import '../widgets/history_box.dart';
import '../widgets/num_key.dart';

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

  final questionHistory = [
    'adfdas',
    'fadsfads',
    'dasf',
    'adsfs',
  ];
  var question = '';
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
                child: Column(
                  children: [
                    // QUESTION HISTORY
                    HistoryBox(
                      solved: questionHistory,
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
                              question,
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
    var finalQuestion = question;

    if (finalQuestion.isNotEmpty) {
      finalQuestion = finalQuestion.replaceAll('×', '*');
      finalQuestion = finalQuestion.replaceAll('÷', '/');

      Parser p = Parser();
      Expression exp = p.parse(finalQuestion);
      ContextModel cm = ContextModel();

      double eval = exp.evaluate(EvaluationType.REAL, cm);

      answer = eval.toString();

      question = double.parse(answer).toStringAsFixed(0);
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
        answer = '';
        question = '';
      }

      // DEL
      else if (index == 2) {
        if (question.isNotEmpty) {
          question = question.substring(0, question.length - 1);
        }
      }

      // %
      else if (index == 3) {
        question = double.parse('${double.parse(question) / 100}')
            .toStringAsFixed(question.length);
      }

      // Operators
      else if ((index + 1) % 4 == 0) {
        if (question.isNotEmpty) {
          question += (' ${keys[index]} $question ');
        }
      }

      // .
      else if (index == 18) {
        if (!question.contains('.')) {
          question += keys[index];
        }
      }

      // Numbers
      else {
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
