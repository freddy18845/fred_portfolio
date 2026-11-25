import 'package:flutter/material.dart';
import '../widgets/reveal.dart';

import '../../core/app_theme.dart';
import '../../core/utils.dart';
import '../../models/experience.dart';
import '../../models/profile.dart';
import '../widgets/accent_button.dart';
import '../widgets/section_container.dart';

class AboutSection extends StatelessWidget {
  final Profile profile;
  final List<Experience> experience;
  final ValueChanged<String> onOpenLink;
  const AboutSection({
    super.key,
    required this.profile,
    required this.experience,
    required this.onOpenLink,
  });

  @override
  Widget build(BuildContext context) {
    final narrow = isNarrow(context);
    final left = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(profile.quote.toUpperCase(), style: displayStyle(18)),
      const SizedBox(height: 20),
      AccentButton('LinkedIn', () => onOpenLink(profile.linkedIn)),
    ]);
    final right = Column(children: [
      _Row('Experience', '', '', header: true),
      for (final e in experience) _Row(e.company, e.role, e.year),
    ]);
    return SectionContainer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text.rich(TextSpan(style: displayStyle(narrow ? 26 : 44), children: [
          const TextSpan(text: 'RELIABLE '),
          TextSpan(
              text: profile.aboutLead.toUpperCase(),
              style: displayStyle(narrow ? 26 : 44, color: AppColors.mute)),
        ])),
        const SizedBox(height: 40),
        if (narrow)
          Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [Reveal(child: left), const SizedBox(height: 40), Reveal(child: right)])
        else
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Reveal(child: left)),
            const SizedBox(width: 40),
            Expanded(child: Reveal(delay: const Duration(milliseconds: 150), child: right)),
          ]),
      ]),
    );
  }
}

class _Row extends StatelessWidget {
  final String company, role, year;
  final bool header;
  const _Row(this.company, this.role, this.year, {this.header = false});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.hairline))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              flex: 3,
              child: Text(company,
                  style: TextStyle(fontSize: 13, color: header ? AppColors.mute : AppColors.ink))),
          Expanded(flex: 4, child: Text(role, style: const TextStyle(fontSize: 13))),
          SizedBox(
              width: 48,
              child: Text(year, textAlign: TextAlign.right, style: const TextStyle(fontSize: 13))),
        ]),
      );
}
