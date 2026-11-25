import 'dart:async';

import 'package:flutter/material.dart';

import 'animated_letters.dart';

/// Letter-reveal headline where one word at a time turns white.
/// The first word starts white; every [interval] the white moves to the next
/// word and the previous word fades back to its normal color, then loops.
class HighlightedHeadline extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration delay;
  final Duration stagger;
  final Duration interval;

  /// Time before the highlight first moves on (lets the reveal finish).
  final Duration initialDelay;
  final Color highlightColor;

  const HighlightedHeadline(
    this.text, {
    super.key,
    required this.style,
    this.delay = Duration.zero,
    this.stagger = const Duration(milliseconds: 45),
    this.interval = const Duration(milliseconds: 1500),
    this.initialDelay = const Duration(milliseconds: 2500),
    this.highlightColor = Colors.white,
  });

  @override
  State<HighlightedHeadline> createState() => _HighlightedHeadlineState();
}

class _HighlightedHeadlineState extends State<HighlightedHeadline> {
  int _index = 0;
  Timer? _start;
  Timer? _tick;

  int get _wordCount => widget.text.split(' ').length;

  void _advance() {
    if (mounted) setState(() => _index = (_index + 1) % _wordCount);
  }

  @override
  void initState() {
    super.initState();
    _start = Timer(widget.initialDelay, () {
      _advance();
      _tick = Timer.periodic(widget.interval, (_) => _advance());
    });
  }

  @override
  void dispose() {
    _start?.cancel();
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedLetters(
      widget.text,
      style: widget.style,
      delay: widget.delay,
      stagger: widget.stagger,
      highlightedWord: _index,
      highlightColor: widget.highlightColor,
    );
  }
}
