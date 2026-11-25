import 'package:flutter/material.dart';

/// Calls [builder] with `visible = true` once the widget scrolls into view.
class OnVisible extends StatefulWidget {
  final Widget Function(BuildContext context, bool visible) builder;
  const OnVisible({super.key, required this.builder});

  @override
  State<OnVisible> createState() => _OnVisibleState();
}

class _OnVisibleState extends State<OnVisible> {
  bool _visible = false;
  ScrollPosition? _position;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _position?.removeListener(_check);
    _position = Scrollable.maybeOf(context)?.position;
    _position?.addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    super.dispose();
  }

  void _check() {
    if (_visible || !mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    if (top < MediaQuery.sizeOf(context).height * 0.8) {
      setState(() => _visible = true);
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _visible);
}