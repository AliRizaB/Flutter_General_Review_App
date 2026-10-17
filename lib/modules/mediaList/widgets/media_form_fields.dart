import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/mediaList/media_controller.dart';
import 'package:flutter_general_reviewer/modules/mediaList/widgets/add_media_widgets/api_options.dart';
import 'package:flutter_general_reviewer/modules/mediaList/widgets/add_media_widgets/image_selector.dart';
import 'package:flutter_general_reviewer/modules/mediaList/widgets/add_media_widgets/rating_widget.dart';
import 'package:flutter_general_reviewer/modules/mediaList/widgets/add_media_widgets/status_selector.dart';
import 'package:flutter_general_reviewer/modules/mediaList/widgets/add_media_widgets/title_field.dart';
import 'package:flutter_general_reviewer/modules/status/status_controller.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/form_fields/custom_text_field.dart';
import 'package:flutter_general_reviewer/services/storage_service.dart';

class MediaFormFields extends StatefulWidget {
  final MediaController mediaController;
  final StatusController statusController;
  final StorageService storageService;

  const MediaFormFields({
    super.key,
    required this.mediaController,
    required this.statusController,
    required this.storageService,
  });

  @override
  State<MediaFormFields> createState() => _MediaFormFieldsState();
}

class _MediaFormFieldsState extends State<MediaFormFields> {
  // Controllers are added cause the flutter_typeahead need them to write the text automatically.
  late final TextEditingController _nameTextController;
  late final TextEditingController _descTextController;

  @override
  void initState() {
    super.initState();
    _nameTextController = TextEditingController(
      text: widget.mediaController.name.value,
    );
    _descTextController = TextEditingController(
      text: widget.mediaController.description.value,
    );
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _descTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Api Search Options
        apiSearchOptions(widget.storageService),

        const SizedBox(height: 16),

        // Media Name
        MediaTitleField(
          mediaController: widget.mediaController,
          nameTextController: _nameTextController,
          descTextController: _descTextController,
        ),

        const SizedBox(height: 16),

        // Media Description
        CustomTextField(
          labelText: 'Description:',
          onChanged: (value) =>
              widget.mediaController.description.value = value,
          hintText: 'Maximum Length: 500',
          maxLines: 4,
          maxLength: 500,
          controller: _descTextController,
        ),
        const SizedBox(height: 16),

        // Rating Bar
        ratingWidget(widget.mediaController),

        const SizedBox(height: 16),

        StatusSelectorDropdown(
          mediaController: widget.mediaController,
          statusController: widget.statusController,
        ),

        const SizedBox(height: 16),

        ImageSelectorField(mediaController: widget.mediaController),
      ],
    );
  }
}
