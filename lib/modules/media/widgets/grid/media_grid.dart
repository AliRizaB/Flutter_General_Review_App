// Essentials
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controllers
import 'package:flutter_general_reviewer/modules/status/status_controller.dart';
import 'package:flutter_general_reviewer/modules/media/media_controller.dart';

// Widgets
import 'package:flutter_general_reviewer/modules/shared/empty_state.dart';
import 'package:flutter_general_reviewer/modules/media/widgets/grid/media_card.dart';

const _sliverGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 3,
  crossAxisSpacing: 12,
  mainAxisSpacing: 12,
  childAspectRatio: 0.75,
);

class MediaGrid extends GetView<MediaController> {
  const MediaGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final statusController = Get.find<StatusController>();

    return Obx(() {
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

      return GridView.builder(
        padding: const EdgeInsets.all(8),
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: _sliverGridDelegate,

        itemCount: controller.medias.length,

        itemBuilder: (context, index) {
          final currentMedia = controller.medias[index];

          return Obx(() {
            final statusColor = statusController.getStatusColor(
              currentMedia.statusId,
            );
            return MediaCard(
              key: ValueKey(currentMedia.id ?? index),
              media: currentMedia,
              statusColor: statusColor,
              onTap: () => Get.toNamed('/mediaView', arguments: currentMedia),
            );
          });
        },
      );
    });
  }
}
