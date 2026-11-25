import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../core/utils.dart';
import '../../models/card_info.dart';

class EducationRow extends StatefulWidget {
  final CardInfo info;
  final VoidCallback? onTap;
  const EducationRow(this.info, {super.key, this.onTap});

  @override
  State<EducationRow> createState() => _EducationRowState();
}

class _EducationRowState extends State<EducationRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final info = widget.info;
    final narrow = isNarrow(context);
    final tappable = widget.onTap != null;

    final title = AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 250),
      style: displayStyle(narrow ? 20 : 24,
          color: _hover ? AppColors.accent : AppColors.ink),
      child: Text(info.title.toUpperCase()),
    );
    final subtitle = Text(info.subtitle,
        style: const TextStyle(color: AppColors.mute, fontSize: 14));
    final tags = Wrap(spacing: 6, runSpacing: 6, children: [
      for (final t in info.tags) _Tag(t),
    ]);

    return MouseRegion(
      cursor: tappable ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.fromLTRB(_hover ? 12 : 0, 22, 0, 22),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: _hover ? AppColors.accent : AppColors.hairline),
            ),
          ),
          child: narrow
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            title,
            const SizedBox(height: 6),
            subtitle,
            if (info.tags.isNotEmpty) ...[const SizedBox(height: 10), tags],
          ])
              : Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(flex: 5, child: title),
            Expanded(flex: 5, child: subtitle),
            Expanded(
              flex: 3,
              child: Align(alignment: Alignment.centerRight, child: tags),
            ),
            SizedBox(
              width: 36,
              child: tappable
                  ? Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.arrow_outward,
                    size: 20,
                    color: _hover ? AppColors.accent : AppColors.mute),
              )
                  : null,
            ),
          ]),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag(this.text);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.hairline),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(text, style: const TextStyle(fontSize: 11, color: AppColors.ink)),
  );
}