import 'package:dio/dio.dart';
import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/services/api/anime_service.dart';
import 'package:flutter_general_reviewer/services/api/book.service.dart';
import 'package:flutter_general_reviewer/services/api/game_service.dart';
import 'package:flutter_general_reviewer/services/api/movie_service.dart';
import 'package:flutter_general_reviewer/services/storage_service.dart';
import 'package:get/get.dart' hide Response;

class ApiService extends BaseController {
  final StorageService _storageService = Get.find<StorageService>();

  String get _currentLanguage => _storageService.selectedLanguageCode.value;
  late final Dio dio;

  @override
  void onInit() {
    super.onInit();
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json', 'Accept-Charset': 'utf-8'},
      ),
    );
  }

  Future<List<AppMedia>> searchMedia(
    String query,
    String? categoryKey,
    int categoryId,
    int page,
  ) async {
    if (categoryKey == null || query.trim().isEmpty) return [];

    final String? apiKey = _storageService.getValue<String>(categoryKey);

    try {
      if (categoryKey == StorageKeys.apiGame) {
        final String? clientId = _storageService.getValue<String>(
          StorageKeys.apiGameClientId,
        );
        final String? clientSecret = _storageService.getValue<String>(
          StorageKeys.apiGameClientSecret,
        );

        if (clientId == null ||
            clientSecret == null ||
            clientId.trim().isEmpty ||
            clientSecret.trim().isEmpty ||
            clientId.trim() == 'client_id' ||
            clientSecret.trim() == 'client_secret') {
          return [];
        }
        return await searchGames(
          dio: dio,
          query: query,
          clientId: clientId.trim(),
          clientSecret: clientSecret.trim(),
          categoryId: categoryId,
          langCode: _currentLanguage,
          page: page,
        );
      } else if (categoryKey == StorageKeys.apiMovieAndSeries) {
        if (apiKey == null || apiKey.isEmpty) return [];
        return await searchMoviesAndSeries(
          dio: dio,
          query: query,
          apiKey: apiKey,
          categoryId: categoryId,
          langCode: _currentLanguage,
          page: page,
        );
      } else if (categoryKey == StorageKeys.apiAnime) {
        return await searchAnimes(
          dio: dio,
          query: query,
          categoryId: categoryId,
          langCode: _currentLanguage,
          page: page,
        );
      } else if (categoryKey == StorageKeys.apiBook) {
        return await searchBooks(
          dio: dio,
          query: query,
          categoryId: categoryId,
          langCode: _currentLanguage,
          page: page,
        );
      }
    } on DioException catch (e) {
      showErrorSnackBar(
        message:
            'API Error (${e.type.name}, ${e.response?.statusCode}): ${e.message}',
      );
    } catch (e) {
      showErrorSnackBar(message: 'Unexpected search error');
    }
    return [];
  }
}
