import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/app_category.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.category});
  final AppCategory category;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.toNamed(AppRoutes.MEDIAS, arguments: [category.id, category.name]);
      },

      title: Text(
        category.name,
        style: TextStyle(
          fontFamily: 'Isometra',
          fontSize: 25,
          color: category.contrastTextColor,
        ),
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: category.contrastTextColor.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),

      tileColor: category.getColor,
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 30,
        color: category.contrastTextColor,
      ),
    );
  }
}
