import 'package:flutter/material.dart';

class ArrowedTexts extends StatelessWidget {
  final List<String> texts;
  final TextStyle? style;
  final double? iconSize;
  final MainAxisAlignment? mainAxisAlignment;
  const ArrowedTexts(
    this.texts, {
    super.key,
    this.style,
    this.iconSize,
    this.mainAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
      children: texts
          .map(
            (e) => Text(
              e,
              style: style,
            ),
          )
          .expand((element) => [Icon(Icons.arrow_right_sharp, size: iconSize), element])
          .skip(1)
          .toList(),
    );
  }
}
