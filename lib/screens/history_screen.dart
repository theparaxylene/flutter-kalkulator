import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<String> solvedQuestions;

  const HistoryScreen({
    super.key,
    required this.solvedQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView.builder(
          itemCount: solvedQuestions.length,
          itemBuilder: (context, index) => Text(solvedQuestions[index]),
        ),
      ),
    );
  }
}
