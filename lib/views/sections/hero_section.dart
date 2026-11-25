import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_theme.dart';
import '../../models/profile.dart';
import '../../viewmodels/portfolio_view_model.dart';
import '../widgets/accent_button.dart';
import '../widgets/floating_circle.dart';
import '../widgets/reveal.dart';
import '../widgets/section_container.dart';
import '../widgets/typing_terminal.dart';

class HeroSection extends StatelessWidget {
  final Profile profile;
  final ValueChanged<SectionId> onNavigate;
  const HeroSection({super.key, required this.profile, required this.onNavigate});

  static const _links = [
    ('Work', SectionId.work),
    ('About', SectionId.about),
    ('Process', SectionId.process),
    ('Contact', SectionId.contact),
  ];

  // TODO: move into Profile so all copy lives in portfolio_repository.dart.
  static const _proof =
      'Building Flutter payment apps since 2022 in South Africa, Zimbabwe and Eswatini.\n'
      'NFC cards, Mobile Money and POS terminals.';

  static const _softText = Color(0xFFB5ABA4); // readable grey on charcoal

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 720;

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Reveal(
          delay: const Duration(milliseconds: 150),
          dy: 0.5,
          child: Text.rich(
            TextSpan(
              style: const TextStyle(color: _softText, fontSize: 17, height: 1.5),
              children: [
                TextSpan(
                  text: profile.name,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                ),
                TextSpan(text: '  ·  ${profile.role}  ·  ${profile.location}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Reveal(
            delay: const Duration(milliseconds: 300),
            dy: 0.2,
            child: Text(
              profile.headline, // sentence case, full white
              style: displayStyle(narrow ? 40 : 76, color: Colors.white)
                  .copyWith(height: 1.04, letterSpacing: narrow ? -1 : -2.5),
            ),
          ),
        ),
        const SizedBox(height: 28),
        Reveal(
          delay: const Duration(milliseconds: 500),
          dy: 0.3,
          child: const Text(_proof,
              style: TextStyle(color: _softText, fontSize: 17, height: 1.5)),
        ),
        const SizedBox(height: 36),
        Reveal(
          delay: const Duration(milliseconds: 650),
          dy: 0.3,
          child: Wrap(spacing: 16, runSpacing: 12, children: [
            AccentButton('See my work', () => onNavigate(SectionId.work)),
            OutlinedButton(
              onPressed: () => onNavigate(SectionId.contact),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: _softText, width: 1.5),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              child: const Text('Let’s talk',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ]),
        ),
      ],
    );

    return SectionContainer(
      color: AppColors.ink,
      vertical: 0,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _Nav(narrow: narrow, links: _links, onNavigate: onNavigate),
        Padding(
          padding: EdgeInsets.only(top: narrow ? 48 : 96, bottom: narrow ? 64 : 110),
          child: narrow
          // Phones: text over a partly visible circle, no terminal.
              ? Stack(children: [
            const Positioned(right: -80, top: 0, child: FloatingCircle(size: 220)),
            text,
          ])
          // Desktop: text left, circle + terminal right, vertically centred.
              : Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(flex: 11, child: text),
            const SizedBox(width: 40),
            Expanded(
              flex: 9,
              child: SizedBox(
                height: 440,
                child: Stack(children: const [
                  Positioned(right: 0, top: 20, child: FloatingCircle(size: 400)),
                  Positioned(
                    left: 0,
                    right: 60,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Reveal(
                        delay: Duration(milliseconds: 600),
                        dy: 0.12,
                        duration: Duration(milliseconds: 900),
                        child: TypingTerminal(delay: Duration(milliseconds: 1400)),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _Nav extends StatelessWidget {
  final bool narrow;
  final List<(String, SectionId)> links;
  final ValueChanged<SectionId> onNavigate;
  const _Nav({required this.narrow, required this.links, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text.rich(
            TextSpan(
              style: GoogleFonts.archivo(
                  fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
              children: const [
                TextSpan(text: 'Fred Oppong'),
                TextSpan(text: '.dev', style: TextStyle(color: AppColors.accent)),
              ],
            ),
          ),
          if (!narrow)
            Row(children: [
              for (final (label, id) in links)
                TextButton(
                  onPressed: () => onNavigate(id),
                  child: Text(label,
                      style: const TextStyle(color: Colors.white, fontSize: 15)),
                ),
            ]),
          AccentButton('Let’s talk', () => onNavigate(SectionId.contact)),
        ]),
        const SizedBox(height: 18),
        Container(width: double.infinity, height: 1, color: Colors.white24),
      ]),
    );
  }
}