import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/app_category.dart';

class CategoryTile extends StatelessWidget {
  final double fontSize;
  final double iconSize;
  final VoidCallback onTap;
  final bool dense;
  final EdgeInsetsGeometry? contentPadding;

  const CategoryTile({
    super.key,
    required this.category,
    required this.fontSize,
    required this.onTap,
    required this.iconSize,
    required this.dense,
    this.contentPadding,
  });
  final AppCategory category;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: dense,
      visualDensity: dense
          ? const VisualDensity(horizontal: 0, vertical: -3)
          : VisualDensity.standard,
      contentPadding: contentPadding,
      minVerticalPadding: 0,

      title: Text(
        category.name,
        style: TextStyle(
          fontFamily: 'Isometra',
          fontSize: fontSize,
          color: category.contrastTextColor,
        ),
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: category.contrastTextColor.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),

      tileColor: category.getColor,
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: iconSize,
        color: category.contrastTextColor,
      ),
    );
  }
}
