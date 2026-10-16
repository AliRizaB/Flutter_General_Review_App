import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/mediaList/media_controller.dart';

TextFormField mediaDescription(
  MediaController controller,
  TextEditingController descTextController,
) {
  return TextFormField(
      controller: descTextController,
      onChanged: (value) => controller.description.value = value,
      maxLines: 4,
      maxLength: 500,
      decoration: const InputDecoration(
        labelText: 'Description:',
        hintText: 'Maximum Length: 500',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please Enter A Small Description";
        }
        return null;
      },
    );
}
