import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../core/utils.dart';
import '../../models/profile.dart';
import '../../viewmodels/portfolio_view_model.dart';
import '../widgets/section_container.dart';

class FooterSection extends StatelessWidget {
  final Profile profile;
  final ValueChanged<SectionId> onNavigate;
  final ValueChanged<String> onOpenLink;
  const FooterSection({
    super.key,
    required this.profile,
    required this.onNavigate,
    required this.onOpenLink,
  });

  static const _links = [
    ('Home', SectionId.home),
    ('Process', SectionId.process),
    ('Work', SectionId.work),
    ('About', SectionId.about),
    ('Contact', SectionId.contact),
  ];

  @override
  Widget build(BuildContext context) {
    const label = TextStyle(color: AppColors.mute, fontSize: 12);
    const body = TextStyle(color: Colors.white, fontSize: 14, height: 1.7);

    final nav = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (final (text, id) in _links)
        InkWell(
          onTap: () => onNavigate(id),
          child: Text(text.toUpperCase(),
              style: displayStyle(28, color: id == SectionId.work ? AppColors.accent : Colors.white)),
        ),
    ]);
    final contact = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Contact', style: label),
      Text(
          '${profile.personalEmail}\n${profile.workEmail}\n${profile.phone}\n${profile.location}',
          style: body),
    ]);
    final follow = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Follow', style: label),
      InkWell(onTap: () => onOpenLink(profile.linkedIn), child: const Text('LinkedIn', style: body)),
    ]);

    return SectionContainer(
      color: AppColors.ink,
      vertical: 60,
      child: isNarrow(context)
          ? Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [nav, const SizedBox(height: 30), contact, const SizedBox(height: 30), follow])
          : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 13, child: nav),
              Expanded(flex: 10, child: contact),
              Expanded(flex: 10, child: follow),
            ]),
    );
  }
}
