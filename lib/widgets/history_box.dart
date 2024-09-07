import 'package:flutter/material.dart';

class HistoryBox extends StatelessWidget {
  final List<String> solved;

  const HistoryBox({
    super.key,
    required this.solved,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ListView.builder(
        itemCount: solved.length,
        reverse: true,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  solved[index],
                  style: const TextStyle(fontSize: 20, color: Colors.black38),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
