import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/appbar_base.dart';
import 'package:flutter_general_reviewer/modules/media/media_controller.dart';
import 'package:flutter_general_reviewer/modules/media/widgets/media_dialog.dart';
import 'package:flutter_general_reviewer/modules/media/widgets/media_grid.dart';
import 'package:get/get.dart';

class MediaListPage extends GetView<MediaController> {
  const MediaListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBase(
        title: controller.categoryName,
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
