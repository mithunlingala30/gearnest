import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Returns true when the app is running in a web browser OR the viewport
/// width is wider than the tablet breakpoint (900 px).
bool isWebLayout(BuildContext context) {
  return kIsWeb || MediaQuery.of(context).size.width > 900;
}

/// Returns true only for wide desktop viewports (> 1100 px).
bool isDesktopLayout(BuildContext context) {
  return kIsWeb && MediaQuery.of(context).size.width > 1100;
}

/// Clamp any width to the max content width used on web pages.
double webContentWidth(BuildContext context) {
  return MediaQuery.of(context).size.width.clamp(0.0, 1280.0);
}
