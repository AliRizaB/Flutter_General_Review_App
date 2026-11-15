// Essentials
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controllers & Models
import 'package:flutter_general_reviewer/modules/category/sub_category/sub_category_controller.dart';
import 'package:flutter_general_reviewer/modules/media/media_controller.dart';
import 'package:flutter_general_reviewer/models/app_category.dart';

// Widgets
import 'package:flutter_general_reviewer/modules/media/widgets/dialog/api_search_options_widget.dart';
import 'package:flutter_general_reviewer/modules/media/widgets/dialog/image_selector_widget.dart';
import 'package:flutter_general_reviewer/modules/media/widgets/dialog/rating_widget.dart';
import 'package:flutter_general_reviewer/modules/media/widgets/dialog/status_selector_widget.dart';
import 'package:flutter_general_reviewer/modules/media/widgets/dialog/title_search_wigdet.dart';
import 'package:flutter_general_reviewer/modules/shared/form_fields/change_category_selector.dart';
import 'package:flutter_general_reviewer/modules/shared/form_fields/custom_text_field.dart';

class MediaFormFields extends GetView<MediaController> {
  final bool isEditing;

  const MediaFormFields({super.key, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    final subCategoryController = Get.find<SubCategoryController>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        // Api Search Options
        ApiSearchOptionsWidget(),

        ChangeCategorySelector<AppCategory>(
          isEdit: isEditing,
          listValues: subCategoryController.categories,
          selectedId: controller.categoryId.value,
          getItemId: (subCategory) => subCategory.id,
          getItemLabel: (subCategory) => subCategory.name,
          onChanged: (int? newId) {
            if (newId != null) {
              controller.categoryId.value = newId;
            }
          },
        ),

        // Media Name & TypeAhead Search Option
        TitleSearchWidget(),

        // Media Description
        CustomTextField(
          labelText: 'Description:',
          onChanged: (value) => controller.description.value = value,
          hintText: 'Maximum Length: 500',
          maxLines: 4,
          maxLength: 500,
          controller: controller.descTextController,
          validator: (_) => null,
        ),

        // Rating Bar
        RatingWidget(),

        StatusSelectorWidget(),

        ImageSelectorWidget(),
      ],
    );
  }
}
