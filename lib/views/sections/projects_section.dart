import 'package:flutter/material.dart';

import '../widgets/accent_button.dart';
import '../widgets/flow_diagram.dart';
import '../widgets/project_card.dart';
import '../widgets/reveal.dart';
import '../widgets/section_container.dart';
import '../widgets/section_title.dart';
import '../widgets/two_column.dart';
import '../../models/card_info.dart';

class ProjectsSection extends StatelessWidget {
  final List<CardInfo> projects;
  final VoidCallback onGetInTouch;
  final ValueChanged<String>? onOpenLink;
  const ProjectsSection({
    super.key,
    required this.projects,
    required this.onGetInTouch,
    this.onOpenLink,
  });

  // Diagrams for projects without screenshots. Keys must match the project
  // titles in portfolio_repository.dart.
  static const _visuals = <String, Widget>{
    'Food ordering kiosk': FlowDiagram([
      [FlowNode('Kiosk', 'Customer order')],
      [FlowNode('Payment request', 'Kiosk app', highlight: true)],
      [
        FlowNode('POS', 'Certified device'),
        FlowNode('Speedpoint', 'Certified device'),
      ],
    ]),
    'Core banking integration': FlowDiagram([
      [FlowNode('Banking app', 'Customer channel')],
      [FlowNode('T24', 'Core banking', highlight: true)],
      [FlowNode('Postilion', 'Payment switch')],
    ]),
  };

  @override
  Widget build(BuildContext context) {
    final open = onOpenLink;

    return SectionContainer(
      child: Column(children: [
        const SectionTitle('Major projects'),
        TwoColumn([
          for (final (i, p) in projects.indexed)
            Reveal(
              delay: Duration(milliseconds: 120 * i),
              child: ProjectCard(
                p,
                visual: _visuals[p.title],
                linkLabel: (p.link ?? '').contains('play.google')
                    ? 'View on Play Store →'
                    : 'View project →',
                onTap: (open == null || p.link == null) ? null : () => open(p.link!),
              ),
            ),
        ]),
        const SizedBox(height: 20),
        AccentButton('Get in touch', onGetInTouch),
      ]),
    );
  }
}