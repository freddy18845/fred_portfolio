import 'package:flutter/material.dart';

import '../../core/utils.dart';

/// Two staggered columns on wide screens, one column on narrow screens.
class TwoColumn extends StatelessWidget {
  final List<Widget> items;
  final double offset;
  const TwoColumn(this.items, {super.key, this.offset = 60});

  Widget _column(List<Widget> list) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final w in list) Padding(padding: const EdgeInsets.only(bottom: 40), child: w)
        ],
      );

  @override
  Widget build(BuildContext context) {
    if (isNarrow(context)) return _column(items);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: _column([for (var i = 0; i < items.length; i += 2) items[i]])),
      const SizedBox(width: 24),
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(top: offset),
          child: _column([for (var i = 1; i < items.length; i += 2) items[i]]),
        ),
      ),
    ]);
  }
}
