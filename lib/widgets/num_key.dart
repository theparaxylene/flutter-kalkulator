import 'package:flutter/material.dart';

class NumKey extends StatelessWidget {
  final String text;
  final Color keyColor;
  final Color textColor;
  final void Function() onTap;

  const NumKey({
    super.key,
    required this.text,
    required this.keyColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: keyColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: text.contains('assets/')
                ? Image.asset(
                    text,
                    color: textColor,
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: 24,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
          ),
        ),
      ),
    );
  }
}
