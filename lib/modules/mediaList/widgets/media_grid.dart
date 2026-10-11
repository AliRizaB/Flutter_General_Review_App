import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/Utilities/status_controller.dart';
import 'package:flutter_general_reviewer/modules/mediaList/media_list_controller.dart';
import 'package:get/get.dart';

class MediaGridView extends GetView<MediaListController> {
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
        return const Center(
          child: ListTile(
            tileColor: Colors.redAccent,
            title: Text(
              "NO MEDIA",
              textAlign: TextAlign
                  .center, // Centers the text inside the full-width tile
              style: TextStyle(fontFamily: 'Isometra', fontSize: 30),
            ),
          ),
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

              child: DottedBorder(
                options: RectDottedBorderOptions(
                  dashPattern: const [20, 25],
                  stackFit: StackFit.passthrough,
                  strokeWidth: 5,
                  padding: const EdgeInsets.all(2),
                  color: statusColor,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Stack(
                    children: [
                      // Media Image Render
                      Positioned.fill(
                        child:
                            (currentMedia.imagePath != null &&
                                currentMedia.imagePath!.isNotEmpty)
                            ? Image.file(
                                File(currentMedia.imagePath!),
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/noImage.jpg',
                                fit: BoxFit.cover,
                              ),
                      ),

                      // Title of the media is showing
                      Positioned(
                        bottom: 8,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withValues(alpha: 0.5),
                                Colors.black,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          child: Text(
                            currentMedia.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Isometra',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
