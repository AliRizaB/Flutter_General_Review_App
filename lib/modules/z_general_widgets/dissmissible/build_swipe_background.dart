import 'package:flutter/material.dart';

Widget buildSwipeBackground({
  required Color color,
  required IconData icon,
  required Alignment alignment,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),

    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
    ),
    alignment: alignment,
    child: Icon(icon),
  );
}
