import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../models/card_info.dart';

// Move these into AppColors if you want them app-wide.
const _tint = Color(0xFFE3D4CB);
const _line = Color(0xFFD6C5BB);
const _pillBg = Color(0xFFF7F1ED);

/// Project card: fixed-ratio visual, platform + tags, title, outcome, footer.
/// Use [InfoCard] for education; this one is for projects only.
///
/// Conventions (see portfolio_repository.dart):
///  - info.tags.first is the platform, the rest are pills.
///  - info.subtitle line 1 = description, line 2 = country.
class ProjectCard extends StatefulWidget {
  final CardInfo info;
  final Widget? visual; // diagram shown when there is no screenshot asset
  final VoidCallback? onTap;
  final String linkLabel;
  const ProjectCard(this.info,
      {super.key, this.visual, this.onTap, this.linkLabel = 'View project →'});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final info = widget.info;
    final lines = info.subtitle.split('\n');
    final description = lines.first;
    final country = lines.length > 1 ? lines[1] : null;
    final platform = info.tags.isNotEmpty ? info.tags.first : null;
    final pills = info.tags.length > 1 ? info.tags.skip(1) : const <String>[];

    Widget visual;
    if (info.assets.isNotEmpty) {
      visual = Padding(
        padding: const EdgeInsets.all(22),
        child: Image.asset(info.assets, fit: BoxFit.contain),
      );
    } else {
      visual = widget.visual ?? const SizedBox.shrink();
    }

    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AspectRatio(
            aspectRatio: 1.8,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: _tint,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _line),
              ),
              child: AnimatedScale(
                scale: _hover ? 1.03 : 1,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                child: visual,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (platform != null)
                Text(platform,
                    style: const TextStyle(
                        color: AppColors.accent, fontSize: 13, fontWeight: FontWeight.w600)),
              for (final t in pills) _Pill(t),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: displayStyle(22, color: _hover ? AppColors.accent : AppColors.ink),
            child: Text(info.title),
          ),
          const SizedBox(height: 8),
          Text(description,
              style: const TextStyle(color: AppColors.mute, fontSize: 15, height: 1.5)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: _line))),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(country ?? '',
                  style: const TextStyle(color: AppColors.mute, fontSize: 13)),
              if (widget.onTap != null)
                Text(widget.linkLabel,
                    style: const TextStyle(
                        color: AppColors.ink, fontSize: 13, fontWeight: FontWeight.w600)),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill(this.text);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: _pillBg,
      border: Border.all(color: _line),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.ink)),
  );
}