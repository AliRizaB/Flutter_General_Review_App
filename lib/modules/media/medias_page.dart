// Essentials
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_general_reviewer/modules/media/media_controller.dart';

// Widgets & Shared 
import 'package:flutter_general_reviewer/modules/shared/appbar_base.dart';
import 'package:flutter_general_reviewer/modules/media/widgets/dialog/show_media_dialog.dart';
import 'package:flutter_general_reviewer/modules/media/widgets/grid/media_grid.dart';

class MediaListPage extends GetView<MediaController> {
  const MediaListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBase(
        title: controller.categoryName,
        actions: [
          IconButton(
            onPressed: () => showMediaDialog(),
            icon: Icon(Icons.add, size: 30),
          ),
        ],
      ),

      body: SizedBox.expand(child: const MediaGrid()),
    );
  }
}
