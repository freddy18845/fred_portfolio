import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../core/utils.dart';
import '../widgets/reveal.dart';
import '../widgets/section_container.dart';

const _softText = Color(0xFFB5ABA4);
const _line = Color(0xFFD6C5BB);
const _chipBg = Color(0xFFF7F1ED);

/// TAP [payment confirmed] PAY, with the three payment methods as chips.
class ReelSection extends StatelessWidget {
  const ReelSection({super.key});

  static const _methods = ['NFC', 'Mobile Money', 'POS'];

  @override
  Widget build(BuildContext context) {
    final narrow = isNarrow(context);
    final size = narrow ? 44.0 : 72.0;

    return SectionContainer(
      vertical: 64,
      child: Reveal(
        dy: 0.1,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('TAP', style: displayStyle(size)),
            if (!narrow) ...[
              const SizedBox(width: 32),
              const _PaidCard(),
              const SizedBox(width: 32),
            ] else
              const SizedBox(width: 16),
            Text('PAY', style: displayStyle(size)),
          ]),
          const SizedBox(height: 32),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [for (final m in _methods) _Chip(m)],
          ),
        ]),
      ),
    );
  }
}

/// Replaces the grey placeholder box: a "payment received" screen.
class _PaidCard extends StatelessWidget {
  const _PaidCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 250,
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(children: [
        const Positioned(
          top: 18,
          right: 18,
          child: Icon(Icons.contactless_rounded, color: _softText, size: 26),
        ),
        Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(
                  color: AppColors.accent, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 46),
            ),
            const SizedBox(height: 18),
            const Text('Paid',
                style: TextStyle(
                    color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            const Text('Card or Mobile Money',
                style: TextStyle(color: _softText, fontSize: 13)),
          ]),
        ),
      ]),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  const _Chip(this.text);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: _chipBg,
      border: Border.all(color: _line),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(text,
        style: const TextStyle(
            color: AppColors.ink, fontSize: 14, fontWeight: FontWeight.w500)),
  );
}