import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/modules/media/media_controller.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/form_fields/custom_text_field.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class MediaTitleField extends StatelessWidget {
  final MediaController mediaController;
  final TextEditingController nameTextController;
  final TextEditingController descTextController;

  const MediaTitleField({
    super.key,
    required this.mediaController,
    required this.nameTextController,
    required this.descTextController,
  });

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<AppMedia>(
      controller: nameTextController,
      debounceDuration: const Duration(milliseconds: 400),
      suggestionsCallback: (search) =>
          mediaController.searchMediaFromApi(search),
      itemBuilder: (context, AppMedia suggestion) {
        return ListTile(
          title: Text(suggestion.name),
          subtitle:
              (suggestion.description != null &&
                  suggestion.description!.isNotEmpty)
              ? Text(
                  suggestion.description ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
        );
      },
      onSelected: (AppMedia selectedMedia) =>
          mediaController.applySelectedMedia(
            selectedMedia: selectedMedia,
            nameController: nameTextController,
            descController: descTextController,
          ),
      builder: (context, textController, focusNode) {
        return CustomTextField(
          labelText: 'Media Name',
          onChanged: (value) => mediaController.name.value = value,
          hintText: 'Type to search...',
          controller: textController,
          focusNode: focusNode,
        );
      },
    );
  }
}
