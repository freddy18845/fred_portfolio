import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../core/utils.dart';
import 'on_visible.dart';

class TimelineItem extends StatefulWidget {
  final String period, title, subtitle;
  final List<String> tags;
  final VoidCallback? onTap;

  /// Draw the progress line below this item's dot.
  final bool drawLine;

  /// The last "still learning" marker: hollow, pulsing dot.
  final bool upcoming;

  const TimelineItem({
    super.key,
    required this.period,
    required this.title,
    required this.subtitle,
    this.tags = const [],
    this.onTap,
    this.drawLine = true,
    this.upcoming = false,
  });

  @override
  State<TimelineItem> createState() => _TimelineItemState();
}

class _TimelineItemState extends State<TimelineItem> {
  static const _periodWidth = 140.0;
  static const _markerWidth = 48.0;
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final narrow = isNarrow(context);
    final tappable = widget.onTap != null;
    final lineLeft = (narrow ? 0 : _periodWidth) + _markerWidth / 2 - 1;

    return OnVisible(
      builder: (context, visible) {
        final period = Text(
          widget.period,
          style: const TextStyle(
              color: AppColors.accent, fontWeight: FontWeight.w600, fontSize: 14),
        );

        final dot = widget.upcoming
            ? const _PulseDot()
            : Padding(
          padding: const EdgeInsets.only(top: 8),
          child: AnimatedScale(
            scale: visible ? 1 : 0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.soft, width: 3),
                boxShadow: const [
                  BoxShadow(color: AppColors.accent, blurRadius: 0, spreadRadius: 1),
                ],
              ),
            ),
          ),
        );

        final content = MouseRegion(
          cursor: tappable ? SystemMouseCursors.click : MouseCursor.defer,
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
            child: AnimatedOpacity(
              opacity: visible ? 1 : 0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              child: AnimatedSlide(
                offset: visible ? Offset.zero : const Offset(0.04, 0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 44),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    if (narrow) ...[period, const SizedBox(height: 4)],
                    Row(children: [
                      Flexible(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          style: displayStyle(narrow ? 20 : 26,
                              color: _hover && tappable ? AppColors.accent : AppColors.ink),
                          child: Text(widget.title.toUpperCase()),
                        ),
                      ),
                      if (tappable) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_outward, size: 18, color: AppColors.mute),
                      ],
                    ]),
                    const SizedBox(height: 6),
                    Text(widget.subtitle,
                        style: const TextStyle(color: AppColors.mute, fontSize: 14)),
                    if (widget.tags.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(spacing: 6, runSpacing: 6, children: [
                        for (final t in widget.tags) _Tag(t),
                      ]),
                    ],
                  ]),
                ),
              ),
            ),
          ),
        );

        return Stack(children: [
          // Progress line: a grey track with an orange fill that grows down.
          if (widget.drawLine)
            Positioned(
              left: lineLeft,
              top: 24,
              bottom: 0,
              width: 2,
              child: Stack(fit: StackFit.expand, children: [
                const ColoredBox(color: AppColors.hairline),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: visible ? 1 : 0),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeInOutCubic,
                  builder: (context, t, _) => Align(
                    alignment: Alignment.topCenter,
                    child: FractionallySizedBox(
                      heightFactor: t,
                      widthFactor: 1,
                      child: const ColoredBox(color: AppColors.accent),
                    ),
                  ),
                ),
              ]),
            ),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (!narrow)
              SizedBox(
                width: _periodWidth,
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Align(alignment: Alignment.topRight, child: period),
                ),
              ),
            SizedBox(width: _markerWidth, child: Align(alignment: Alignment.topCenter, child: dot)),
            Expanded(child: content),
          ]),
        ]);
      },
    );
  }
}

/// Hollow dot with a soft ring that keeps pulsing outward.
class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
  AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (!MediaQuery.disableAnimationsOf(context)) _c.repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final t = Curves.easeOut.transform(_c.value);
          return Stack(alignment: Alignment.center, children: [
            Container(
              width: 16 + 16 * t,
              height: 16 + 16 * t,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withAlpha((110 * (1 - t)).round()),
              ),
            ),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.soft,
                border: Border.all(color: AppColors.accent, width: 2.5),
              ),
            ),
          ]);
        },
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag(this.text);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.hairline),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(text, style: const TextStyle(fontSize: 11, color: AppColors.ink)),
  );
}
