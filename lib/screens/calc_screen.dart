import 'package:flutter/material.dart';

import '../widgets/keyboard.dart';
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
  var answer = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(question),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(answer),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      setState(() {
                        question += keys[index];
                      });
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
