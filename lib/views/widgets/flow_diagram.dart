import 'package:flutter/material.dart';

import '../../core/app_theme.dart';

class FlowNode {
  final String label;
  final String caption;
  final bool highlight;
  const FlowNode(this.label, this.caption, {this.highlight = false});
}

/// Left-to-right flow. Each inner list is one stage; nodes inside a stage
/// stack vertically. Scales down on narrow screens instead of overflowing.
class FlowDiagram extends StatelessWidget {
  final List<List<FlowNode>> stages;
  const FlowDiagram(this.stages, {super.key});

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < stages.length; i++) {
      if (i > 0) {
        children.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Icon(Icons.arrow_right_alt_rounded, size: 40, color: AppColors.ink),
        ));
      }
      children.add(Column(mainAxisSize: MainAxisSize.min, children: [
        for (var j = 0; j < stages[i].length; j++) ...[
          if (j > 0) const SizedBox(height: 12),
          _Node(stages[i][j]),
        ],
      ]));
    }
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(mainAxisSize: MainAxisSize.min, children: children),
        ),
      ),
    );
  }
}

class _Node extends StatelessWidget {
  final FlowNode node;
  const _Node(this.node);

  @override
  Widget build(BuildContext context) {
    final fg = node.highlight ? const Color(0xFFF7F1ED) : AppColors.ink;
    return Container(
      constraints: const BoxConstraints(minWidth: 120),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: node.highlight ? AppColors.ink : const Color(0xFFF7F1ED),
        border: Border.all(color: AppColors.ink, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(node.label,
            textAlign: TextAlign.center,
            style: TextStyle(color: fg, fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(node.caption,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: node.highlight ? const Color(0xFFCFC3BB) : AppColors.mute,
                fontSize: 11)),
      ]),
    );
  }
}