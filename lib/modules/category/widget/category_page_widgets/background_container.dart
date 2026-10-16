import 'package:flutter/material.dart';

Widget backgroundContainer({
  required Color color,
  required Icon icon,
  required Alignment alignment,
}) {
  return Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
    ),
    alignment: alignment,
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: icon,
  );
}
