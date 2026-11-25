import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dark terminal card that types its lines out, then blinks a cursor.
class TypingTerminal extends StatefulWidget {
  final Duration delay;
  const TypingTerminal({super.key, this.delay = Duration.zero});

  static const _text =
      '~/fred \$ flutter build apk\n✓ NFC payment flow\n✓ Mobile Money checkout\n✓ POS / Speedpoint link\n✓ Runs on budget phones\n~/fred \$ ';

  @override
  State<TypingTerminal> createState() => _TypingTerminalState();
}

class _TypingTerminalState extends State<TypingTerminal> with TickerProviderStateMixin {
  static const _green = Color(0xFF9EF0B8);
  late final AnimationController _type = AnimationController(
      vsync: this, duration: Duration(milliseconds: TypingTerminal._text.length * 32));
  late final AnimationController _blink =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _type.value = 1;
      return;
    }
    _blink.repeat(reverse: true);
    Future.delayed(widget.delay, () {
      if (mounted) _type.forward();
    });
  }

  @override
  void dispose() {
    _type.dispose();
    _blink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const text = TypingTerminal._text;
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xFF0F0F0F), borderRadius: BorderRadius.circular(8)),
      child: AnimatedBuilder(
        animation: Listenable.merge([_type, _blink]),
        builder: (context, _) {
          final count = (_type.value * text.length).floor().clamp(0, text.length);
          final base = GoogleFonts.robotoMono(fontSize: 12, height: 1.7, color: _green);
          // The untyped remainder is transparent so the card never changes size.
          return Text.rich(TextSpan(style: base, children: [
            TextSpan(text: text.substring(0, count)),
            TextSpan(
                text: '▍',
                style: TextStyle(color: _green.withAlpha((255 * _blink.value).round()))),
            TextSpan(text: text.substring(count), style: const TextStyle(color: Colors.transparent)),
          ]));
        },
      ),
    );
  }
}
