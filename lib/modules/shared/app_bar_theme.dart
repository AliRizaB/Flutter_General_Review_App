import 'package:flutter/material.dart';

Color getAppBarColor(ThemeData theme) {
  final isDark = theme.brightness == Brightness.dark;

  if (isDark) {
    return Color.alphaBlend(
      theme.colorScheme.primary.withValues(alpha: 0.25),
      theme.colorScheme.surface,
    );
  } else {
    return Color.alphaBlend(
      theme.colorScheme.primary.withValues(alpha: 0.12),
      theme.colorScheme.surface,
    );
  }
}

Color getAppBarForegroundColor(ThemeData theme) {
  final isDark = theme.brightness == Brightness.dark;

  return isDark ? theme.colorScheme.onSurface : theme.colorScheme.primary;
}
