import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/medias/media_controller.dart';
import 'package:flutter_general_reviewer/modules/medias/widgets/add_media_dialog.dart';
import 'package:flutter_general_reviewer/modules/medias/widgets/media_grid.dart';
import 'package:get/get.dart';

class MediaPage extends GetView<MediaController> {
  const MediaPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  final int categoryId;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    debugPrint(categoryId.toString());
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              categoryName,
              style: TextStyle(fontFamily: 'Isometra', fontSize: 25),
            ),
            IconButton(
              onPressed: () => showAddMediaDialog(context),
              icon: Icon(Icons.add, size: 30),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
      ),

      body: controller.medias.isNotEmpty
          ? Text("NO MEDIA")
          : Obx(
              () => ListView.builder(
                itemCount: controller.medias.length,
                itemBuilder: (context, index) {
                  final currentMedia = controller.medias[index];
                  return ListTile(title: Text(currentMedia.name));
                },
              ),
            ),
    );
  }
}
