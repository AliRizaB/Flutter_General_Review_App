import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/mediaList/media_list_controller.dart';
import 'package:flutter_general_reviewer/modules/mediaList/widgets/add_media_dialog.dart';
import 'package:flutter_general_reviewer/modules/mediaList/widgets/media_grid.dart';
import 'package:get/get.dart';

class MediaListPage extends GetView<MediaListController> {
  const MediaListPage({
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
              onPressed: () => showMediaDialog(context),
              icon: Icon(Icons.add, size: 30),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
      ),

      body: SizedBox.expand(child: const MediaGridView()),
    );
  }
}
