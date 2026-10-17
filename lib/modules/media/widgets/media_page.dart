// Essentials
import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/utilities/app_bar_theme.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/dissmissible/delete_confirmation.dart';
import 'package:get/get.dart';

// Models
import 'package:flutter_general_reviewer/models/app_media.dart';

// Controller
import 'package:flutter_general_reviewer/modules/media/media_controller.dart';

// Build Widgets
import 'package:flutter_general_reviewer/modules/media/widgets/media_page_widgets/media_description.dart';
import 'package:flutter_general_reviewer/modules/media/widgets/media_page_widgets/media_banner.dart';
import 'package:flutter_general_reviewer/modules/media/widgets/media_page_widgets/media_info.dart';
import 'package:flutter_general_reviewer/modules/media/widgets/media_page_widgets/review_button.dart';

// Connection to Widget
import 'package:flutter_general_reviewer/modules/media/widgets/media_dialog.dart';

class MediaPage extends GetView<MediaController> {
  MediaPage({super.key});

  final AppMedia initialMedia = Get.arguments as AppMedia;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: getAppBarColor(theme),
        foregroundColor: getAppBarForegroundColor(theme),
        centerTitle: true,
        elevation: 0,
        title: Obx(() {
          // Fetching media again for updated media
          final currentMedia =
              controller.medias.firstWhereOrNull(
                (media) => media.id == initialMedia.id,
              ) ??
              initialMedia;
          return Text(
            currentMedia.name,
            style: theme.textTheme.headlineMedium!.copyWith(
              color: getAppBarForegroundColor(theme),
              fontFamily: 'Isometra',
            ),
          );
        }),

        actions: [
          _MediaOptionsButton(
            initialMedia: initialMedia,
            controller: controller,
          ),
        ],
      ),
      body: Obx(() {
        final currentMedia =
            controller.medias.firstWhereOrNull(
              (media) => media.id == initialMedia.id,
            ) ??
            initialMedia;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image
              MediaBanner(media: currentMedia),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MediaInfoBar(media: currentMedia),

                    const SizedBox(height: 16),

                    // Description Section
                    MediaDescription(media: currentMedia),

                    const SizedBox(height: 16),
                    // Reviews
                    ReviewButton(mediaId: currentMedia.id!),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _MediaOptionsButton extends StatelessWidget {
  final AppMedia initialMedia;
  final MediaController controller;
  const _MediaOptionsButton({
    required this.initialMedia,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) async {
        // Fetching fresh State
        final currentMedia =
            controller.medias.firstWhereOrNull(
              (m) => m.id == initialMedia.id,
            ) ??
            initialMedia;

        if (value == 'update') {
          // Handle Update action
          showMediaDialog(context, toUpdateMedia: currentMedia);
        } else if (value == 'delete') {
          // Handle Delete action
          final bool isConfirmed = await deleteConfirmDialog(
            title: currentMedia.name,
          );
          if (isConfirmed) {
            await controller.deleteMedia(currentMedia);
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          }
        }
      },
      itemBuilder: (BuildContext context) => const [
        PopupMenuItem<String>(
          value: 'update',
          child: Row(
            children: [
              Icon(Icons.edit, size: 20),
              SizedBox(width: 8),
              Text('Update'),
            ],
          ),
        ),
        PopupMenuItem<String>(
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
}
