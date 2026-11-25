import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../models/faq_item.dart';
import '../widgets/reveal.dart';
import '../widgets/section_container.dart';
import '../widgets/section_title.dart';

class FaqSection extends StatelessWidget {
  final List<FaqItem> items;
  final int? openIndex;
  final ValueChanged<int> onToggle;
  const FaqSection({
    super.key,
    required this.items,
    required this.openIndex,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionTitle('Frequently asked questions'),
        for (final (i, item) in items.indexed)
          Reveal(
            delay: Duration(milliseconds: 80 * i),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.hairline))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                InkWell(
                  onTap: () => onToggle(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Flexible(child: Text(item.question.toUpperCase(), style: displayStyle(14))),
                      AnimatedRotation(
                        turns: openIndex == i ? 0.125 : 0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        child: const Icon(Icons.add, size: 20),
                      ),
                    ]),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topLeft,
                  child: openIndex == i
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 640),
                            child: Text(item.answer, style: const TextStyle(color: AppColors.mute)),
                          ),
                        )
                      : const SizedBox(width: double.infinity),
                ),
              ]),
            ),
          ),
      ]),
    );
  }
}
