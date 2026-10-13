import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/Utilities/rating_details.dart';
import 'package:flutter_general_reviewer/modules/status/status_controller.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/modules/mediaList/media_list_controller.dart';
import 'package:flutter_general_reviewer/modules/mediaList/widgets/add_media_dialog.dart';
import 'package:flutter_general_reviewer/routes/app_pages.dart';
import 'package:get/get.dart';

class MediaPage extends GetView<MediaListController> {
  MediaPage({super.key});

  final AppMedia initialMedia = Get.arguments as AppMedia;
  final StatusController statusController = Get.find<StatusController>();

  AppMedia get media =>
      controller.medias.firstWhereOrNull((m) => m.id == initialMedia.id) ??
      initialMedia;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          title: Text(
            media.name,
            style: theme.textTheme.headlineMedium!.copyWith(
              fontFamily: 'Isometra',
            ),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [_buildOptionButtons(context, theme)],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image
              _buildMediaBanner(theme),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAboutMedia(theme),

                    const SizedBox(height: 16),

                    // Description Section
                    Text(
                      'Description:',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        media.description ?? '',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 18,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                    // Reviews
                    _buildReviewButton(theme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //
  // BUILD MORE OPTION BUTTONS
  //
  PopupMenuButton<String> _buildOptionButtons(
    BuildContext context,
    ThemeData theme,
  ) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) async {
        if (value == 'update') {
          // Handle Update action
          showMediaDialog(context, toUpdateMedia: media);
        } else if (value == 'delete') {
          // Handle Delete action
          final bool isConfirmed = await _getDialogConfirmation(
            media.name,
            theme,
          );
          if (isConfirmed) {
            await controller.deleteMedia(media);
            if (!context.mounted) return;
            Navigator.of(context).pop();
          }
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
  Widget _buildMediaBanner(ThemeData theme) {
    final hasImagePath = media.imagePath != null && media.imagePath!.isNotEmpty;

    return Stack(
      children: [
        Container(
          height: 280,
          width: double.infinity,
          decoration: BoxDecoration(color: theme.colorScheme.surface),
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
  Container _buildAboutMedia(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [_buildRatingCard(theme), _buildStatusBadge(theme)],
      ),
    );
  }

  //
  // Connected Status Badge from StatusController
  //
  Widget _buildStatusBadge(ThemeData theme) {
    return Obx(() {
      // Find matching status by status identifier
      final status = statusController.statuses.firstWhereOrNull(
        (s) =>
            s.id == media.statusId, // Adjust parameter name to match your model
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
  Widget _buildRatingCard(ThemeData theme) {
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

  //
  // Review Button
  //
  SizedBox _buildReviewButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
        ),
        onPressed: () => Get.toNamed(AppRoutes.REVIEWS, arguments: media.id!),
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

  Future<bool> _getDialogConfirmation(String mediaName, ThemeData theme) async {
    final result = await Get.defaultDialog(
      backgroundColor: theme.colorScheme.error,
      title: 'Delete the $mediaName?',
      content: Text(
        'Are you sure?',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),

      confirmTextColor: Colors.white,
      textConfirm: 'YES',
      onConfirm: () => Get.back(result: true),

      buttonColor: theme.colorScheme.onError,

      cancelTextColor: Colors.white,
      textCancel: 'no',
      onCancel: () => false,
    );

    return result ?? false;
  }
}
