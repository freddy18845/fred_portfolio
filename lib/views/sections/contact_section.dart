import 'package:flutter/material.dart';
import '../widgets/reveal.dart';

import '../../core/app_theme.dart';
import '../../core/utils.dart';
import '../../models/profile.dart';
import '../widgets/accent_button.dart';
import '../widgets/section_container.dart';

class ContactSection extends StatelessWidget {
  final Profile profile;
  final VoidCallback onEmail;
  const ContactSection({super.key, required this.profile, required this.onEmail});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(children: [
        Reveal(
          dy: 0.12,
          duration: const Duration(milliseconds: 900),
          child: Text('LET’S TALK NOW',
              textAlign: TextAlign.center, style: displayStyle(isNarrow(context) ? 48 : 110)),
        ),
        const SizedBox(height: 16),
        const Text('Open to Flutter and mobile payments roles and projects.',
            style: TextStyle(color: AppColors.mute)),
        const SizedBox(height: 20),
        AccentButton(profile.personalEmail, onEmail),
      ]),
    );
  }
}
