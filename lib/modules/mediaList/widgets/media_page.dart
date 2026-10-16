// Essentials
import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/utilities/app_bar_theme.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/dissmissible/delete_confirmation.dart';
import 'package:get/get.dart';

// Models
import 'package:flutter_general_reviewer/models/app_media.dart';

// Controller
import 'package:flutter_general_reviewer/modules/mediaList/media_controller.dart';

// Build Widgets
import 'package:flutter_general_reviewer/modules/mediaList/widgets/media_page_widgets/build_desc.dart';
import 'package:flutter_general_reviewer/modules/mediaList/widgets/media_page_widgets/build_image.dart';
import 'package:flutter_general_reviewer/modules/mediaList/widgets/media_page_widgets/build_media_info.dart';
import 'package:flutter_general_reviewer/modules/mediaList/widgets/media_page_widgets/build_review_button.dart';

// Connection to Widget
import 'package:flutter_general_reviewer/modules/mediaList/widgets/add_media_dialog.dart';

class MediaPage extends GetView<MediaController> {
  MediaPage({super.key});

  final AppMedia initialMedia = Get.arguments as AppMedia;

  AppMedia get media =>
      controller.medias.firstWhereOrNull((m) => m.id == initialMedia.id) ??
      initialMedia;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: getAppBarColor(theme),
          foregroundColor: getAppBarForegroundColor(theme),

          title: Text(
            media.name,
            style: theme.textTheme.headlineMedium!.copyWith(
              color: getAppBarForegroundColor(theme),
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
              buildMediaBanner(theme, media),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildMediaInfo(theme, media),

                    const SizedBox(height: 16),

                    // Description Section
                    buildDescription(theme, media),

                    const SizedBox(height: 16),
                    // Reviews
                    buildReviewButton(theme, media.id!),
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
          final bool isConfirmed = await deleteConfirmDialog(title: media.name);
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
}
