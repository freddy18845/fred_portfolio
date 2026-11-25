import 'package:flutter/material.dart';

/// Full-width band with centered 1100px content and page padding.
class SectionContainer extends StatelessWidget {
  final Color? color;
  final double vertical;
  final Widget child;

  const SectionContainer({super.key, this.color, this.vertical = 80, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: color,
      padding: EdgeInsets.symmetric(vertical: vertical),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: child),
        ),
      ),
    );
  }
}
