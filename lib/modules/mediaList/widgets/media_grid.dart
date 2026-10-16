import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/empty_state.dart';
import 'package:flutter_general_reviewer/modules/mediaList/widgets/media_grid_widgets/build_media.dart';
import 'package:flutter_general_reviewer/modules/status/status_controller.dart';
import 'package:flutter_general_reviewer/modules/mediaList/media_controller.dart';
import 'package:get/get.dart';

class MediaGridView extends GetView<MediaController> {
  const MediaGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final statusController = Get.find<StatusController>();

    return Obx(() {
      // Tracking if the Statuses are loaded
      final _ = statusController.statuses;

      if (controller.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.medias.isEmpty) {
        return const EmptyState(
          icon: Icons.photo_album_outlined,
          title: 'No Media',
          subtitle: 'Please add media via top right button',
        );
      }
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),

          itemCount: controller.medias.length,

          itemBuilder: (context, index) {
            final currentMedia = controller.medias[index];
            final statusColor = statusController.getStatusColor(
              currentMedia.statusId,
            );

            return GestureDetector(
              key: ValueKey(currentMedia.id ?? index),
              onTap: () => Get.toNamed('/mediaView', arguments: currentMedia),

              child: buildMedia(statusColor, currentMedia),
            );
          },
        ),
      );
    });
  }
}
