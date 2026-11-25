import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../models/card_info.dart';

/// Gradient thumbnail card. The thumbnail zooms slightly on hover.
class InfoCard extends StatefulWidget {
  final CardInfo info;
  final double ratio;
  final VoidCallback? onTap;
  const InfoCard(this.info, {super.key, this.ratio = 4 / 3, this.onTap});

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {

    final info = widget.info;
    debugPrint('card "${info.title}" link=${info.link} hasOnTap=${widget.onTap != null}');
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AspectRatio(
          aspectRatio: widget.ratio,
          child: ClipRect(
            child: AnimatedScale(
              scale: _hover ? 1.05 : 1,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              child: Container(
                padding: const EdgeInsets.all(14),
                alignment: Alignment.topLeft,
                decoration:info.assets.isEmpty? BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight, colors: info.colors),
                ):BoxDecoration(image: DecorationImage(image: AssetImage(info.assets))
                ),
                child: Row(children: [for (final t in info.tags) _Pill(t)]),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 250),
          style: displayStyle(16, color: _hover ? AppColors.accent : AppColors.ink),
          child: Text(info.title.toUpperCase()),
        ),
        const SizedBox(height: 6),
        Text(info.subtitle, style: const TextStyle(color: AppColors.mute, fontSize: 13)),
      ])),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill(this.text);

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(99)),
        child: Text(text, style: const TextStyle(fontSize: 10, color: AppColors.ink)),
      );
}
