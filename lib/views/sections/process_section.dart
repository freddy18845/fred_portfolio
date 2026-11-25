import 'package:flutter/material.dart';
import '../widgets/reveal.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_theme.dart';
import '../../core/utils.dart';
import '../../models/process_step.dart';
import '../widgets/section_container.dart';

class ProcessSection extends StatelessWidget {
  final List<ProcessStep> steps;
  const ProcessSection({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    final narrow = isNarrow(context);
    final outline = GoogleFonts.archivo(
      fontSize: narrow ? 56 : 130,
      fontWeight: FontWeight.w800,
      height: .95,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = const Color(0xFF777777),
    );
    return SectionContainer(
      color: AppColors.ink,
      child: Column(children: [
        Text('HOW I WORK', style: outline, textAlign: TextAlign.center),
        const SizedBox(height: 60),
        if (narrow)
          Container(
            padding: const EdgeInsets.only(left: 24),
            decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: AppColors.accent))),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [for (final s in steps) _Step(s)]),
          )
        else
          Stack(children: [
            // The center line is drawn behind the columns, so no column
            // needs to know the other's height.
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(width: 1, color: AppColors.accent),
              ),
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    for (var i = 0; i < steps.length; i += 2) _Step(steps[i])
                  ]),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, top: 80),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    for (var i = 1; i < steps.length; i += 2) _Step(steps[i])
                  ]),
                ),
              ),
            ]),
          ]),
      ]),
    );
  }
}

class _Step extends StatelessWidget {
  final ProcessStep step;
  const _Step(this.step);

  @override
  Widget build(BuildContext context) => Reveal(
        child: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(step.number, style: GoogleFonts.robotoMono(color: AppColors.accent, fontSize: 12)),
          const SizedBox(height: 8),
          Text(step.title.toUpperCase(), style: displayStyle(36, color: Colors.white)),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text(step.description,
                style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 13)),
          ),
        ]),
      ));
}
