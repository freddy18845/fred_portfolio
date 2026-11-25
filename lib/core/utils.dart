import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

bool isNarrow(BuildContext c) => MediaQuery.sizeOf(c).width < 720;

Future<void> launchLink(String url) => launchUrl(Uri.parse(url));
