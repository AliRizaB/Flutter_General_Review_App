// ignore_for_file: public_member_api_docs, sort_constructors_first
// Essentials
import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/shared/dissmissible/dissmiss_functions.dart';
import 'package:get/get.dart';

import 'package:flutter_general_reviewer/modules/shared/appbar_base.dart';
import 'package:flutter_general_reviewer/routes/app_pages.dart';

// Models
import 'package:flutter_general_reviewer/models/app_media.dart';

// Controller
import 'package:flutter_general_reviewer/modules/media/media_controller.dart';

// Build Widgets
import 'package:flutter_general_reviewer/modules/media/widgets/detail/media_description_widget.dart';
import 'package:flutter_general_reviewer/modules/media/widgets/detail/media_banner_widget.dart';
import 'package:flutter_general_reviewer/modules/media/widgets/detail/media_infobar_widget.dart';
import 'package:flutter_general_reviewer/modules/shared/form_fields/build_button.dart';

// Connection to Widget
import 'package:flutter_general_reviewer/modules/media/widgets/dialog/show_media_dialog.dart';

class MediaDetailPage extends GetView<MediaController> {
  MediaDetailPage({super.key});

  final AppMedia initialMedia = Get.arguments as AppMedia;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _ReactiveAppbar(initialMedia: initialMedia),
      body: Obx(() {
        final currentMedia = controller.resolveMedia(initialMedia);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image
              MediaBannerWidget(media: currentMedia),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MediaInfoBarWidget(media: currentMedia),

                    const SizedBox(height: 16),

                    // Description Section
                    MediaDescriptionWidget(media: currentMedia),

                    const SizedBox(height: 16),
                    // Reviews
                    BuildButton(
                      icon: Icons.rate_review_rounded,
                      label: "Write a Review",
                      onTap: () => Get.toNamed(
                        AppRoutes.REVIEWS,
                        arguments: currentMedia.id,
                      ),
                    ),
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

enum _MediaActions { update, delete }

class _MediaOptionsButton extends GetView<MediaController> {
  final AppMedia media;
  const _MediaOptionsButton({required this.media});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MediaActions>(
      icon: const Icon(Icons.more_vert),
      onSelected: (action) async {
        switch (action) {
          case _MediaActions.update:
            showMediaDialog(toUpdateMedia: media);
          case _MediaActions.delete:
            final bool isConfirmed = await deleteConfirmDialog(
              title: media.name,
            );
            if (isConfirmed) {
              await controller.deleteMedia(media);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            }
        }
      },
      itemBuilder: (BuildContext context) => const [
        PopupMenuItem(
          value: _MediaActions.update,
          child: Row(
            children: [
              Icon(Icons.edit, size: 20),
              SizedBox(width: 8),
              Text('Update'),
            ],
          ),
        ),
        PopupMenuItem(
          value: _MediaActions.delete,
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

class _ReactiveAppbar extends GetView<MediaController>
    implements PreferredSizeWidget {
  final AppMedia initialMedia;
  const _ReactiveAppbar({required this.initialMedia});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentMedia = controller.resolveMedia(initialMedia);
      return AppBarBase(
        title: currentMedia.name,
        actions: [_MediaOptionsButton(media: currentMedia)],
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
