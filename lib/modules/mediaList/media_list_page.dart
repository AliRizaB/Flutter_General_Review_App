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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text(
          categoryName,
          style: theme.textTheme.headlineMedium!.copyWith(
            fontFamily: 'Isometra',
          ),
        ),

        actions: [
          IconButton(
            onPressed: () => showMediaDialog(context),
            icon: Icon(Icons.add, size: 30),
          ),
        ],
      ),

      body: SizedBox.expand(child: const MediaGridView()),
    );
  }
}
