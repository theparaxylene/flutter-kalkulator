import 'package:flutter/material.dart';

import '../widgets/num_key.dart';

class Keyboard extends StatelessWidget {
  final List<String> keys;
  final void Function() onKeyTap;

  const Keyboard({
    super.key,
    required this.keys,
    required this.onKeyTap,
  });

  @override
  Widget build(BuildContext context) {
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
        onTap: onKeyTap,
      ),
      physics: const NeverScrollableScrollPhysics(),
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
