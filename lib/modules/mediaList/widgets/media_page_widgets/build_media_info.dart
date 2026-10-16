import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/Utilities/rating_details.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/modules/status/status_controller.dart';
import 'package:get/get.dart';

Container buildMediaInfo(ThemeData theme, AppMedia media) {
  return Container(
    padding: EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: theme.colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [_buildRatingCard(theme, media), _buildStatusBadge(theme, media)],
    ),
  );
}

Widget _buildStatusBadge(ThemeData theme, AppMedia media) {
  final StatusController statusController = Get.find<StatusController>();
  return Obx(() {
    // Find matching status by status identifier
    final status = statusController.statuses.firstWhereOrNull(
      (s) =>
          s.id == media.statusId, 
    );

    final statusName = status?.name ?? 'Unknown';
    final statusColor = status?.getColor ?? Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Text(
        statusName,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  });
}

//
// Rating Display Component
//
Widget _buildRatingCard(ThemeData theme, AppMedia media) {
  final RatingDetails ratingInfo = getRatingDetails(media.rating);

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: theme.colorScheme.outlineVariant),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(ratingInfo.icon, color: ratingInfo.color, size: 28),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ratingInfo.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ratingInfo.color,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
