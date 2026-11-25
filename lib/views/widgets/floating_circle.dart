import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import 'float_in.dart';

/// The hero's accent circle.
class FloatingCircle extends StatelessWidget {
  final double size;
  const FloatingCircle({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return FloatIn(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
      ),
    );
  }
}
