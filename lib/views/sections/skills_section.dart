import 'package:flutter/material.dart';
import '../widgets/reveal.dart';

import '../../core/app_theme.dart';
import '../../models/profile.dart';
import '../widgets/section_container.dart';
import '../widgets/section_title.dart';

class SkillsSection extends StatelessWidget {
  final Profile profile;
  const SkillsSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionTitle('Skills'),
        Wrap(spacing: 40, runSpacing: 12, children: [
          for (final (i, s) in profile.skills.indexed)
            Reveal(
              delay: Duration(milliseconds: 60 * i),
              dy: 0.3,
              child: Text(s.toUpperCase(), style: displayStyle(28)),
            ),
        ]),
        const SizedBox(height: 50),
        Reveal(
          child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 520),
            padding: const EdgeInsets.all(36),
            color: AppColors.ink,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(profile.achievement.toUpperCase(),
                  textAlign: TextAlign.center, style: displayStyle(18, color: Colors.white)),
              const SizedBox(height: 14),
              const Text('Key achievement', style: TextStyle(color: AppColors.mute)),
            ]),
          ),
        )),
      ]),
    );
  }
}
