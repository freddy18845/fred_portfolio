import 'package:flutter/material.dart';

/// Reveals text letter by letter: each letter rises out of a clipped mask,
/// one after another. Words wrap like normal text.
class AnimatedLetters extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration delay;
  final Duration stagger;
  final Duration letterDuration;

  /// Index of the word (split on spaces) drawn in [highlightColor]; null for none.
  final int? highlightedWord;
  final Color highlightColor;

  const AnimatedLetters(
    this.text, {
    super.key,
    required this.style,
    this.delay = Duration.zero,
    this.stagger = const Duration(milliseconds: 45),
    this.letterDuration = const Duration(milliseconds: 700),
    this.highlightedWord,
    this.highlightColor = Colors.white,
  });

  @override
  State<AnimatedLetters> createState() => _AnimatedLettersState();
}

class _AnimatedLettersState extends State<AnimatedLetters>
    with SingleTickerProviderStateMixin {
  late final int _letters = widget.text.replaceAll(' ', '').length;
  late final Duration _total =
      widget.letterDuration + widget.stagger * (_letters > 1 ? _letters - 1 : 0);
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: _total);
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _letter(String ch, int i, double size, Color? color) {
    final total = _total.inMicroseconds;
    final start = i * widget.stagger.inMicroseconds / total;
    final end = start + widget.letterDuration.inMicroseconds / total;
    final interval = Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0), curve: Curves.easeOutCubic);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = interval.transform(_controller.value);
        return ClipRect(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: size * 0.04),
            child: Transform.translate(
              offset: Offset(0, (1 - t) * size),
              child: Opacity(
                opacity: t,
                child: AnimatedDefaultTextStyle(
                  style: widget.style.copyWith(color: color),
                  duration: const Duration(milliseconds: 600),
                  child: Text(ch),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.style.fontSize ?? 16;
    var index = 0;
    return Semantics(
      label: widget.text,
      excludeSemantics: true,
      child: Wrap(
        spacing: size * 0.28,
        children: [
          for (final (w, word) in widget.text.split(' ').indexed)
            Row(mainAxisSize: MainAxisSize.min, children: [
              for (final ch in word.split(''))
                _letter(ch, index++, size,
                    w == widget.highlightedWord ? widget.highlightColor : widget.style.color),
            ]),
        ],
      ),
    );
  }
}
