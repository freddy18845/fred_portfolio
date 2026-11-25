import 'package:flutter/material.dart';

import '../../core/app_theme.dart';

class AccentButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const AccentButton(this.label, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      ),
      child: Text(label),
    );
  }
}
