import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/shared/functions/rating_details.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/modules/status/status_controller.dart';
import 'package:get/get.dart';

class MediaInfoBar extends StatelessWidget {
  final AppMedia media;

  const MediaInfoBar({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _RatingCard(media: media),
          _StatusBadge(media: media),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final AppMedia media;

  const _StatusBadge({required this.media});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusController = Get.find<StatusController>();

    return Obx(() {
      final status = statusController.statuses.firstWhereOrNull(
        (status) => status.id == media.statusId,
      );

      // Status Info
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
}

class _RatingCard extends StatelessWidget {
  final AppMedia media;

  const _RatingCard({required this.media});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
}
