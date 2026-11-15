import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/profile/widgets/api/api_field.dart';
import 'package:flutter_general_reviewer/modules/profile/widgets/api/change_language_widget.dart';
import 'package:flutter_general_reviewer/modules/shared/form_fields/form_buttons.dart';
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
            spacing: 12,
            children: [
              // ApiKeyField(
              //   title: 'Game Api Key',
              //   initialValue:
              //       storageService.getValue(StorageKeys.apiGame) ?? '',
              //   providerName: 'RAWG.io',
              //   providerUrl: 'https://rawg.io/',
              //   onSaved: (newValue) =>
              //       storageService.setValue(StorageKeys.apiGame, newValue),
              // ),
              ApiField(
                title: 'IGDB Client ID',
                initialValue:
                    storageService.getValue(StorageKeys.apiGameClientId) ?? '',
                providerName: 'Twitch Dev Console',
                providerUrl: 'https://dev.twitch.tv/console',
                onSaved: (newValue) => storageService.setValue(
                  StorageKeys.apiGameClientId,
                  newValue,
                ),
              ),

              ApiField(
                title: 'IGDB Client Secret',
                initialValue:
                    storageService.getValue(StorageKeys.apiGameClientSecret) ??
                    '',
                providerName: 'Twitch Dev Console',
                providerUrl: 'https://dev.twitch.tv/console',
                onSaved: (newValue) => storageService.setValue(
                  StorageKeys.apiGameClientSecret,
                  newValue,
                ),
              ),

              ApiField(
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

              NoApiCard(
                title: 'Book Api',
                providerName: 'Open Library',
                icon: Icons.book_outlined,
              ),

              NoApiCard(
                title: 'Anime Api',
                providerName: 'AniList GraphQL',
                icon: Icons.tv_rounded,
              ),

              const SizedBox(height: 12),
              ChangeLanguageWidget(),
            ],
          ),
        ),
      ),

      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FormCancelButton(),
        FormSubmitButton(
          formKey: formKey,
          isEditing: false,
          onSubmit: () async {
            formKey.currentState!.save();
          },
        ),
      ],
    ),
  );
}
