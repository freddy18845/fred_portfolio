import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../core/utils.dart';
import 'on_visible.dart';

class GrowthStep {
  final String period, title, subtitle;
  final int year; // shown by the year counter when the marker reaches this step
  const GrowthStep({
    required this.period,
    required this.title,
    required this.subtitle,
    required this.year,
  });
}

/// A marker travels along a line through each step while the level, year and
/// progress bar count up. Starts when scrolled into view, then loops.
class GrowthPath extends StatelessWidget {
  final List<GrowthStep> steps;

  /// Must match the section's background (used to cut the line behind the dots).
  final Color background;

  /// Pause after finishing before the animation plays again.
  final Duration loopDelay;

  const GrowthPath({
    super.key,
    required this.steps,
    required this.background,
    this.loopDelay = const Duration(seconds: 4),
  });

  @override
  Widget build(BuildContext context) {
    return OnVisible(
      builder: (context, visible) => _GrowthBody(
        steps: steps,
        play: visible,
        background: background,
        loopDelay: loopDelay,
      ),
    );
  }
}

class _GrowthBody extends StatefulWidget {
  final List<GrowthStep> steps;
  final bool play;
  final Color background;
  final Duration loopDelay;
  const _GrowthBody({
    required this.steps,
    required this.play,
    required this.background,
    required this.loopDelay,
  });

  @override
  State<_GrowthBody> createState() => _GrowthBodyState();
}

class _GrowthBodyState extends State<_GrowthBody> with TickerProviderStateMixin {
  static const _track = Color(0xFFD9C8C2);

  late final int _n = widget.steps.length;
  late final AnimationController _c;
  late final AnimationController _pulse;
  late final Animation<double> _pos;
  bool _started = false;
  Timer? _loop;

  @override
  void initState() {
    super.initState();
    // Position along the steps: 0 = first step, n-1 = last step.
    final items = <TweenSequenceItem<double>>[
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.3, end: 0).chain(CurveTween(curve: Curves.easeOut)),
        weight: 400,
      ),
    ];
    for (var i = 1; i < _n; i++) {
      items.add(TweenSequenceItem(
        tween: Tween<double>(begin: (i - 1).toDouble(), end: i.toDouble())
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 1100,
      ));
      items.add(TweenSequenceItem(tween: ConstantTween<double>(i.toDouble()), weight: 600));
    }
    _c = AnimationController(
        vsync: this, duration: Duration(milliseconds: 400 + (_n - 1) * 1700));
    _pos = TweenSequence<double>(items).animate(_c);
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    _c.addStatusListener((status) {
      if (status == AnimationStatus.completed) _scheduleLoop();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.play && !_started) _start();
  }

  @override
  void didUpdateWidget(covariant _GrowthBody old) {
    super.didUpdateWidget(old);
    if (widget.play && !_started) _start();
  }

  void _start() {
    _started = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _c.value = 1;
    } else {
      _c.forward(from: 0);
      _pulse.repeat();
    }
  }

  void _scheduleLoop() {
    if (!mounted || MediaQuery.disableAnimationsOf(context)) return;
    _loop?.cancel();
    _loop = Timer(widget.loopDelay, () {
      if (mounted) _c.forward(from: 0);
    });
  }

  void _replay() {
    if (MediaQuery.disableAnimationsOf(context)) return;
    _loop?.cancel();
    _c.forward(from: 0);
  }

  @override
  void dispose() {
    _loop?.cancel();
    _c.dispose();
    _pulse.dispose();
    super.dispose();
  }

  /// 0..1 for step [i]: grows as the marker approaches it.
  double _reveal(double pos, int i) => ((pos - (i - 0.15)) / 0.15).clamp(0.0, 1.0);

  String _status(double pos) {
    final p = pos.clamp(0.0, _n - 1.0);
    final i = p.floor();
    final j = (i + 1).clamp(0, _n - 1);
    final year = (widget.steps[i].year +
        (widget.steps[j].year - widget.steps[i].year) * (p - i))
        .round();
    final level = i == _n - 1 ? 'Level $_n · next' : 'Level ${i + 1}';
    return '$level · $year';
  }

  Widget _dot(double reveal, bool last) {
    final scale = 0.5 + 0.5 * Curves.easeOutBack.transform(reveal);
    final pulse = Curves.easeOut.transform(_pulse.value);
    final hollow = last && reveal >= 1;
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: hollow ? widget.background : Color.lerp(_track, AppColors.accent, reveal),
          border: Border.all(
              color: hollow ? AppColors.accent : widget.background, width: 3),
          boxShadow: hollow
              ? [
            BoxShadow(
              color: AppColors.accent.withAlpha((115 * (1 - pulse)).round()),
              spreadRadius: 12 * pulse,
            ),
          ]
              : null,
        ),
      ),
    );
  }

  Widget _fade(double reveal, Widget child) => Opacity(
    opacity: reveal,
    child: Transform.translate(offset: Offset(0, 8 * (1 - reveal)), child: child),
  );

  Widget _texts(GrowthStep s, double reveal, {required CrossAxisAlignment align}) {
    final textAlign = align == CrossAxisAlignment.center ? TextAlign.center : TextAlign.start;
    return _fade(
      reveal,
      Column(crossAxisAlignment: align, children: [
        Text(s.title,
            textAlign: textAlign,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, height: 1.3)),
        const SizedBox(height: 2),
        Text(s.subtitle,
            textAlign: textAlign,
            style: const TextStyle(color: AppColors.mute, fontSize: 11, height: 1.3)),
      ]),
    );
  }

  Widget _period(GrowthStep s, double reveal) => _fade(
    reveal,
    Text(s.period,
        style: const TextStyle(
            color: AppColors.accent, fontWeight: FontWeight.w600, fontSize: 12)),
  );

  Widget _wide(double pos, double width) {
    final colW = width / _n;
    final p = pos.clamp(0.0, _n - 1.0);
    final headOpacity = 1 - _reveal(pos, _n - 1);
    return Stack(children: [
      Positioned(
          left: colW / 2, right: colW / 2, top: 34, height: 2,
          child: const ColoredBox(color: _track)),
      Positioned(
          left: colW / 2, top: 34, height: 2, width: p * colW,
          child: const ColoredBox(color: AppColors.accent)),
      Positioned(
        left: (0.5 + p) * colW - 7,
        top: 28,
        child: Opacity(
          opacity: pos < 0 ? 0 : headOpacity,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.ink,
              border: Border.all(color: AppColors.accent, width: 2),
            ),
          ),
        ),
      ),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        for (var i = 0; i < _n; i++)
          Expanded(
            child: Column(children: [
              SizedBox(height: 18, child: Center(child: _period(widget.steps[i], _reveal(pos, i)))),
              Padding(
                padding: const EdgeInsets.only(top: 9, bottom: 12),
                child: _dot(_reveal(pos, i), i == _n - 1),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _texts(widget.steps[i], _reveal(pos, i),
                    align: CrossAxisAlignment.center),
              ),
            ]),
          ),
      ]),
    ]);
  }

  Widget _narrow(double pos) {
    return Column(children: [
      for (var i = 0; i < _n; i++)
        Stack(children: [
          if (i < _n - 1)
            Positioned(
              left: 7, top: 20, bottom: 0, width: 2,
              child: Stack(fit: StackFit.expand, children: [
                const ColoredBox(color: _track),
                Align(
                  alignment: Alignment.topCenter,
                  child: FractionallySizedBox(
                    heightFactor: (pos - i).clamp(0.0, 1.0),
                    widthFactor: 1,
                    child: const ColoredBox(color: AppColors.accent),
                  ),
                ),
              ]),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: _dot(_reveal(pos, i), i == _n - 1),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _period(widget.steps[i], _reveal(pos, i)),
                  const SizedBox(height: 2),
                  _texts(widget.steps[i], _reveal(pos, i), align: CrossAxisAlignment.start),
                ]),
              ),
            ]),
          ),
        ]),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_c, _pulse]),
      builder: (context, _) {
        final pos = _started ? _pos.value : -1.0;
        final xp = pos < 0 ? 0.0 : (pos + 1) / _n;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(_status(pos),
                style: const TextStyle(
                    color: AppColors.accent, fontWeight: FontWeight.w600, fontSize: 14)),
            TextButton.icon(
              onPressed: _replay,
              icon: const Icon(Icons.replay, size: 16),
              label: const Text('Replay'),
              style: TextButton.styleFrom(foregroundColor: AppColors.ink),
            ),
          ]),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Container(
              height: 6,
              color: const Color(0xFFE5D3CC),
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: xp.clamp(0.0, 1.0),
                child: const ColoredBox(color: AppColors.accent, child: SizedBox.expand()),
              ),
            ),
          ),
          const SizedBox(height: 26),
          if (isNarrow(context))
            _narrow(pos)
          else
            LayoutBuilder(builder: (context, c) => _wide(pos, c.maxWidth)),
        ]);
      },
    );
  }
}