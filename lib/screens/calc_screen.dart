import 'package:flutter/material.dart';

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

  var question = '';
  var submitted = '';
  var answer = 'ans';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 18,
              ),
              child: Column(
                children: [
                  // SUBMITTED PARTS
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        submitted,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),

                  // CURRENT QUESTION
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        question,
                        style: TextStyle(
                          fontSize: 36,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),

                  //ANSWER
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        answer,
                        style: const TextStyle(fontSize: 48),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // KEYBOARD
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.grey.shade100,
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
          ),
        ],
      ),
    );
  }

  void onKeyTap(int index) {
    setState(() {
      if (index == 0) {
        // =
      } else if (index == 1) {
        // C
        if (question.isNotEmpty) {
          question = '';
        } else if (question.isEmpty && submitted.isNotEmpty) {
          submitted = '';
        }
      } else if (index == 2) {
        // DEL
        if (question.isNotEmpty) {
          question = question.substring(0, question.length - 1);
        }
      } else if (index == 3) {
        // %
        question = double.parse('${double.parse(question) / 100}')
            .toStringAsFixed(question.length);
      } else if ((index + 1) % 4 == 0) {
        // Operators
        if (question.isNotEmpty) {
          submitted += ('$question ${keys[index]} ');
          question = '';
        }
      } else if (index == 18) {
        // .
        if (!question.contains('.')) {
          question += keys[index];
        }
      } else {
        // Numbers
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
