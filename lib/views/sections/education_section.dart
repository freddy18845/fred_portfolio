import 'package:flutter/material.dart';

import '../../models/card_info.dart';
import '../widgets/growth_path.dart';
import '../widgets/section_container.dart';
import '../widgets/section_title.dart';

class EducationSection extends StatelessWidget {
  final List<CardInfo> items;
  final ValueChanged<String>? onOpenLink; // not used by the growth path
  const EducationSection({super.key, required this.items, this.onOpenLink});

  /// Last 4-digit year found in "2023 – 2025" style text.
  static int _lastYear(String s) {
    final years = RegExp(r'\d{4}').allMatches(s).map((m) => int.parse(m.group(0)!)).toList();
    return years.isEmpty ? DateTime.now().year : years.last;
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      for (final e in items)
        GrowthStep(
          period: e.period,
          title: e.title,
          subtitle: e.subtitle,
          year: _lastYear(e.period),
        ),
      GrowthStep(
        period: 'Now',
        title: 'Always learning',
        subtitle: 'What’s next',
        year: DateTime.now().year,
      ),
    ];

    return SectionContainer(
      vertical: 60,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionTitle('Education and certifications'),
        GrowthPath(steps: steps, background: Colors.white ,),
      ]),
    );
  }
}