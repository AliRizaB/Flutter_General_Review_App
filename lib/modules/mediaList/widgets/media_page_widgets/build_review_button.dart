import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../../routes/app_pages.dart';

SizedBox buildReviewButton(ThemeData theme, int id) {
  return SizedBox(
    width: double.infinity,
    height: 52,
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 2,
      ),
      onPressed: () => Get.toNamed(AppRoutes.REVIEWS, arguments: id),
      icon: Icon(
        Icons.rate_review_rounded,
        color: theme.colorScheme.onPrimaryContainer,
      ),
      label: Text(
        'Write a Review',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
    ),
  );
}
