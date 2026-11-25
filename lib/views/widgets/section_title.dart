import 'package:flutter/material.dart';
import 'reveal.dart';

import '../../core/app_theme.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Reveal(
        child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                shape: BoxShape.circle, border: Border.all(color: AppColors.accent, width: 2)),
          ),
          Flexible(child: Text(text.toUpperCase(), style: displayStyle(32))),
        ]),
      ));
}
