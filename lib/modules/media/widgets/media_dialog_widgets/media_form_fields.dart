import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/modules/media/media_controller.dart';
import 'package:flutter_general_reviewer/modules/media/widgets/media_dialog_widgets/api_options.dart';
import 'package:flutter_general_reviewer/modules/media/widgets/media_dialog_widgets/image_selector_field.dart';
import 'package:flutter_general_reviewer/modules/media/widgets/media_dialog_widgets/rating_widget.dart';
import 'package:flutter_general_reviewer/modules/media/widgets/media_dialog_widgets/status_selector.dart';
import 'package:flutter_general_reviewer/modules/media/widgets/media_dialog_widgets/title_field.dart';
import 'package:flutter_general_reviewer/modules/status/status_controller.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/form_fields/custom_text_field.dart';
import 'package:flutter_general_reviewer/services/storage_service.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';

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
  late final SuggestionsController<AppMedia> _suggestionsController;
  late final Worker _apiKeyWorker;

  @override
  void initState() {
    super.initState();
    _nameTextController = TextEditingController(
      text: widget.mediaController.name.value,
    );
    _descTextController = TextEditingController(
      text: widget.mediaController.description.value,
    );

    _suggestionsController = SuggestionsController<AppMedia>();

    // Re-run the search whenever the API chip changes
    _apiKeyWorker = ever(
      widget.storageService.selectedCategoryKey,
      (_) => _suggestionsController.refresh(),
    );
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _descTextController.dispose();
    _apiKeyWorker.dispose();
    _suggestionsController.dispose();
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
          suggestionsController: _suggestionsController,
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
          validator: (_) => null,
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
