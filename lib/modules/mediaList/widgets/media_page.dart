import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/Utilities/rating_details.dart';
import 'package:flutter_general_reviewer/Utilities/status_controller.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/modules/mediaList/media_list_controller.dart';
import 'package:flutter_general_reviewer/modules/review/review_list.dart';
import 'package:flutter_general_reviewer/modules/mediaList/widgets/add_media_dialog.dart';
import 'package:flutter_general_reviewer/modules/review/widget/add_review_dialog.dart';
import 'package:flutter_general_reviewer/routes/app_pages.dart';
import 'package:get/get.dart';

class MediaPage extends GetView<MediaListController> {
  MediaPage({super.key});

  final AppMedia media = Get.arguments as AppMedia;
  final StatusController statusController = Get.find<StatusController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.3,
      ),
      appBar: AppBar(
        backgroundColor: theme.colorScheme.onSecondary,
        title: Text(media.name, style: TextStyle(fontFamily: 'Isometra')),
        centerTitle: true,
        elevation: 0,
        actions: [_buildOptionButtons(context)],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            _buildMediaBanner(context),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAboutMedia(context),

                  const SizedBox(height: 16),

                  // Description Section
                  Text(
                    'Description',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      media.description!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                  // Reviews
                  _buildReviewButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //
  // BUILD MORE OPTION BUTTONS
  //
  PopupMenuButton<String> _buildOptionButtons(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == 'update') {
          // Handle Update action
          showMediaDialog(context, toUpdateMedia: media);
        } else if (value == 'delete') {
          // Handle Delete action
          controller.deleteMedia(media.id!);
          Navigator.of(context).pop();
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'update',
          child: Row(
            children: [
              Icon(Icons.edit, size: 20),
              SizedBox(width: 8),
              Text('Update'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red, size: 20),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  //
  //  MEDIA IMAGE BUILD
  //
  Widget _buildMediaBanner(BuildContext context) {
    final hasImagePath = media.imagePath != null && media.imagePath!.isNotEmpty;

    return Stack(
      children: [
        Container(
          height: 280,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: hasImagePath
              ? Image.file(
                  File(media.imagePath!),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildFallbackImage(),
                )
              : _buildFallbackImage(),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackImage() {
    return Image.asset('assets/images/noImage.jpg', fit: BoxFit.contain);
  }

  //
  // BUILD PERSONAL INFO ABOUT MEDIA
  //
  Container _buildAboutMedia(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [_buildRatingCard(context), _buildStatusBadge(context)],
      ),
    );
  }

  //
  // Connected Status Badge from StatusController
  //
  Widget _buildStatusBadge(BuildContext context) {
    return Obx(() {
      // Find matching status by status identifier
      final status = statusController.statuses.firstWhereOrNull(
        (s) =>
            s.id == media.statusId, // Adjust parameter name to match your model
      );

      final statusName = status?.name ?? 'Unknown';
      final statusColor = status?.getColor ?? Colors.grey;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onInverseSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          statusName,
          style: TextStyle(
            color: statusColor,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      );
    });
  }

  //
  // Rating Display Component
  //
  Widget _buildRatingCard(BuildContext context) {
    final RatingDetails ratingInfo = getRatingDetails(media.rating);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onInverseSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
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

  //
  // Review Button
  //
  SizedBox _buildReviewButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
        ),
        onPressed: () => Get.toNamed(AppRoutes.REVIEWS),
        icon: const Icon(Icons.rate_review_rounded),
        label: const Text(
          'Write a Review',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Review Dialog placeholder
  void _openReviewDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Write a Review'),
        content: ReviewList(),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => showAddReviewDialog(context),
            child: const Text("Add Review"),
          ),
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }
}
