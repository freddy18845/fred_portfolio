import 'package:flutter/material.dart';

/// Scales and fades its child in with a small overshoot, then keeps it
/// drifting slowly up and down. Used by the hero circle and the hero name.
class FloatIn extends StatefulWidget {
  final Widget child;
  final Duration delay;

  /// How far (in pixels) the child drifts above and below its resting place.
  final double distance;

  /// The point the scale-in grows from.
  final Alignment alignment;

  const FloatIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.distance = 12,
    this.alignment = Alignment.center,
  });

  @override
  State<FloatIn> createState() => _FloatInState();
}

class _FloatInState extends State<FloatIn> with TickerProviderStateMixin {
  late final AnimationController _enter =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));
  late final AnimationController _float =
      AnimationController(vsync: this, duration: const Duration(seconds: 4));
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _enter.value = 1;
      return;
    }
    _float.repeat(reverse: true);
    Future.delayed(widget.delay, () {
      if (mounted) _enter.forward();
    });
  }

  @override
  void dispose() {
    _enter.dispose();
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_enter, _float]),
      child: widget.child,
      builder: (context, child) {
        final e = Curves.easeOutBack.transform(_enter.value);
        final dy = widget.distance * (Curves.easeInOut.transform(_float.value) * 2 - 1);
        return Opacity(
          opacity: e.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, dy),
            child: Transform.scale(
              scale: 0.6 + 0.4 * e,
              alignment: widget.alignment,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
