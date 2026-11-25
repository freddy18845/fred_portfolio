import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Floating WhatsApp button. Grows a label on hover.
class WhatsAppButton extends StatefulWidget {
  final VoidCallback onPressed;
  const WhatsAppButton({super.key, required this.onPressed});

  @override
  State<WhatsAppButton> createState() => _WhatsAppButtonState();
}

class _WhatsAppButtonState extends State<WhatsAppButton> {
// replace _teal and _darkTeal with:
  static const _greenTop = Color(0xFF9DE682);
  static const _greenBottom = Color(0xFF80D45C);
  static const _greenTopHover = Color(0xFF8BDE70);
  static const _greenBottomHover = Color(0xFF6CC84A);
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      builder: (context, v, child) => Transform.scale(scale: v, child: child),
      child: Tooltip(
        message: 'Chat on WhatsApp',
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: GestureDetector(
            onTap: widget.onPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              // replace the decoration of the AnimatedContainer with:
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _hover
                      ? const [_greenTopHover, _greenBottomHover]
                      : const [_greenTop, _greenBottom],
                ),
                borderRadius: BorderRadius.circular(29),
                boxShadow: const [
                  BoxShadow(color: Color(0x66000000), blurRadius: 16, offset: Offset(0, 6)),
                ],
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const WhatsAppLogo(size: 34),
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  child: _hover
                      ? const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text('Chat with me',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                  )
                      : const SizedBox.shrink(),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

/// The WhatsApp logo: a speech bubble outline with a phone handset inside.
class WhatsAppLogo extends StatelessWidget {
  final double size;
  final Color color;
  const WhatsAppLogo({super.key, this.size = 32, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(alignment: Alignment.center, children: [
        CustomPaint(size: Size(size, size), painter: _BubblePainter(color)),
        Align(
          alignment: const Alignment(0, -0.08),
          child: Icon(Icons.phone, size: size * 0.44, color: color),
        ),
      ]),
    );
  }
}

class _BubblePainter extends CustomPainter {
  final Color color;
  const _BubblePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final center = Offset(s * .5, s * .5);
    final r = s * .4;
    final start = 130 * math.pi / 180;
    final sweep = 340 * math.pi / 180;
    final startPoint = center + Offset(math.cos(start), math.sin(start)) * r;

    final path = Path()
      ..moveTo(startPoint.dx, startPoint.dy)
      ..arcTo(Rect.fromCircle(center: center, radius: r), start, sweep, false)
      ..lineTo(s * .08, s * .93) // the bubble's tail
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * .075
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_BubblePainter old) => old.color != color;
}