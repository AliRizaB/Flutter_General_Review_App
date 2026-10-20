import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/profile/widgets/api_key_widgets/api_key_field.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/form_fields/form_cancel_button.dart';
import 'package:flutter_general_reviewer/services/storage_service.dart';
import 'package:get/get.dart';

Future<dynamic> showAPIKeyDialog() {
  final formKey = GlobalKey<FormState>();
  final storageService = Get.find<StorageService>();

  return Get.dialog(
    AlertDialog(
      title: Text('Enter API keys'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              ApiKeyField(
                title: 'Game Api Key',
                initialValue:
                    storageService.getValue(StorageKeys.apiGame) ?? '',
                providerName: 'RAWG.io',
                providerUrl: 'https://rawg.io/',
                onSaved: (newValue) =>
                    storageService.setValue(StorageKeys.apiGame, newValue),
              ),

              const SizedBox(height: 12),
              ApiKeyField(
                title: 'Film & TV API Key',
                initialValue:
                    storageService.getValue(StorageKeys.apiMovieAndSeries) ??
                    '',
                providerName: 'OMDb API',
                providerUrl: 'https://www.omdbapi.com/apikey.aspx',
                onSaved: (value) => storageService.setValue(
                  StorageKeys.apiMovieAndSeries,
                  value,
                ),
              ),
              const SizedBox(height: 12),
              NoApiKeyCard(
                title: 'Book Api',
                providerName: 'Open Library',
                icon: Icons.book_outlined,
              ),

              const SizedBox(height: 12),
              NoApiKeyCard(
                title: 'Anime Api',
                providerName: 'AniList GraphQL',
                icon: Icons.tv_rounded,
              ),
            ],
          ),
        ),
      ),

      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FormCancelButton(),
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
