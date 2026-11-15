import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/services/storage_service.dart';
import 'package:get/get.dart';

class ChangeLanguageWidget extends StatelessWidget {
  const ChangeLanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = Get.find<StorageService>();
    return Obx(() {
      return DropdownButtonFormField<String>(
        initialValue: storageService.selectedLanguageCode.value,
        decoration: const InputDecoration(
          labelText: 'Select Language',
          border: OutlineInputBorder(),
        ),
        items: [
          DropdownMenuItem(value: 'tr', child: Text('Türkçe')),
          DropdownMenuItem(value: 'en', child: Text('English')),
        ],
        onChanged: (String? value) {
          if (value != null) {
            storageService.setLanguageCode(value);
          }
        },
      );
    });
  }
}
