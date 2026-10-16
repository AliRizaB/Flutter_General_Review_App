import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/services/storage_service.dart';
import 'package:get/get.dart';

Future<dynamic> showAPIKeyDialog() {
  final formKey = GlobalKey<FormState>();
  final service = Get.find<StorageService>();

  return Get.dialog(
    AlertDialog(
      title: Text('Enter API keys'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              buildTextField(StorageKeys.apiGame, 'Game', '...', service),
              const SizedBox(height: 12),
              buildTextField(StorageKeys.apiMovie, 'Movie', '...', service),
              const SizedBox(height: 12),
              buildTextField(StorageKeys.apiSeries, 'Series', '...', service),
              const SizedBox(height: 12),
              buildTextField(StorageKeys.apiAnime, 'Anime', 'No Need For', service),
              const SizedBox(height: 12),
              buildTextField(StorageKeys.apiBook, 'Book', '...', service),
            ],
          ),
        ),
      ),

      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(onPressed: () => Get.back(), child: Text("Cancel")),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            side: BorderSide(
              color: Theme.of(Get.context!).colorScheme.primary, 
              width: 2, // Border width
            ),
          ),
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              formKey.currentState!.save();
              Get.back();
            }
          },
          child: Text("Save"),
        ),
      ],
    ),
  );
}

TextFormField buildTextField(
  String key,
  String label,
  String site,
  StorageService service,
) {
  return TextFormField(
    initialValue: service.getValue(key) ?? '',
    onSaved: (value) {
      if (value != null) {
        service.setValue(key, value);
      }
    },
    decoration: InputDecoration(
      labelText: '$label API Key',
      hintText: 'Get from $site site',
      border: const OutlineInputBorder(),
    ),
  );
}
