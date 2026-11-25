import 'dart:ui';

class CardInfo {
  final String title, subtitle, assets, period;
  final List<String> tags;
  final List<Color> colors;
  final String? link;

  const CardInfo({
    required this.title,
    required this.subtitle,
    required this.colors,
    this.assets = '',
    this.period = '',
    this.tags = const [],
    this.link,
  });
}