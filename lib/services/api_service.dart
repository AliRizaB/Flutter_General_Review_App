import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/services/storage_service.dart';
import 'package:get/get.dart';

class ApiService extends BaseController {
  final StorageService _storageService = Get.find<StorageService>();

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
        'Accept': 'application/json',
      },
    ),
  );

  Future<List<AppMedia>> searchMedia(
    String query,
    String? categoryKey,
    int categoryId,
  ) async {
    if (categoryKey == null || query.trim().isEmpty) return [];

    final String? apiKey = _storageService.getValue(categoryKey);

    try {
      if (categoryKey == StorageKeys.apiGame) {
        if (apiKey == null || apiKey.isEmpty) return [];
        return await _searchGames(query, apiKey, categoryId);
      } else if (categoryKey == StorageKeys.apiMovie) {
        if (apiKey == null || apiKey.isEmpty) return [];
        return await _searchMovies(query, apiKey, categoryId);
      } else if (categoryKey == StorageKeys.apiSeries) {
        if (apiKey == null || apiKey.isEmpty) return [];
        return await _searchSeries(query, apiKey, categoryId);
      } else if (categoryKey == StorageKeys.apiAnime) {
        return await _searchAnimes(query, categoryId);
      } else if (categoryKey == StorageKeys.apiBook) {
        return await _searchBooks(query, apiKey, categoryId);
      }
    } on DioException catch (e) {
      debugPrint('type: ${e.type}');
      debugPrint('error: ${e.error}');
      debugPrint('message: ${e.message}');
      debugPrint('status: ${e.response?.statusCode}');
      showErrorSnackBar(message: 'API Search Error: ${e.toString()}');
    }
    return [];
  }

  Future<List<AppMedia>> _searchGames(
    String query,
    String apiKey,
    int categoryId,
  ) async {
    final response = await _dio.get(
      'https://api.rawg.io/api/games',
      queryParameters: {'key': apiKey, 'search': query},
    );
    final List results = response.data['results'] ?? [];
    return results
        .map(
          (item) => AppMedia(
            name: item['name'] ?? '',
            description: item['slug'] ?? '',
            rating: 1,
            imagePath: item['background_image'],
            categoryId: categoryId,
          ),
        )
        .toList();
  }

  Future<List<AppMedia>> _searchMovies(
    String query,
    String apiKey,
    int categoryId,
  ) async {
    final response = await _dio.get(
      'https://api.themoviedb.org/3/search/movie',
      queryParameters: {'api_key': apiKey, 'query': query},
    );

    final List results = response.data['results'] ?? [];
    return results.map((item) {
      final posterPath = item['poster_path'];
      final fullImageUrl = posterPath != null
          ? 'https://image.tmdb.org/t/p/w500$posterPath'
          : null;

      return AppMedia(
        name: item['title'] ?? '',
        description: item['overview'] ?? '',
        rating: 1,
        imagePath: fullImageUrl,
        categoryId: categoryId,
      );
    }).toList();
  }

  Future<List<AppMedia>> _searchSeries(
    String query,
    String apiKey,
    int categoryId,
  ) async {
    final response = await _dio.get(
      'https://api.themoviedb.org/3/search/tv',
      queryParameters: {'api_key': apiKey, 'query': query},
    );
    final List results = response.data['results'] ?? [];
    return results.map((item) {
      final posterPath = item['poster_path'];
      final fullImageUrl = posterPath != null
          ? 'https://image.tmdb.org/t/p/w500$posterPath'
          : null;

      return AppMedia(
        name: item['name'] ?? '',
        description: item['overview'],
        rating: 1,
        imagePath: fullImageUrl,
        categoryId: categoryId,
      );
    }).toList();
  }

  Future<List<AppMedia>> _searchAnimes(String query, int categoryId) async {
    const gql = r'''
    query ($search: String, $perPage: Int) {
      Page(page: 1, perPage: $perPage) {
        media(search: $search, type: ANIME, sort: SEARCH_MATCH) {
          title { romaji english }
          description(asHtml: false)
          coverImage { large }
        }
      }
    }
  ''';

    final response = await _dio.post(
      'https://graphql.anilist.co',
      data: {
        'query': gql,
        'variables': {'search': query, 'perPage': 8},
      },
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    final List results = response.data['data']?['Page']?['media'] ?? [];
    return results.map((item) {
      final title = item['title'] ?? {};
      // AniList descriptions can still contain <br> tags, so strip them
      final desc = _cleanDescription(item['description'] as String?);
      return AppMedia(
        name: title['english'] ?? title['romaji'] ?? '',
        description: desc,
        rating: 1,
        imagePath: item['coverImage']?['large'],
        categoryId: categoryId,
      );
    }).toList();
  }

  String? _cleanDescription(String? raw, {int maxLength = 250}) {
    if (raw == null) return null;

    final text = raw
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#039;', "'")
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();

    if (text.length <= maxLength) return text;

    // Cut at the last full word and add an ellipsis (still within maxLength)
    final cut = text.substring(0, maxLength - 1);
    final lastSpace = cut.lastIndexOf(' ');
    return '${cut.substring(0, lastSpace > 0 ? lastSpace : cut.length)}…';
  }

  Future<List<AppMedia>> _searchBooks(
    String query,
    String? apiKey,
    int categoryId,
  ) async {
    final Map<String, String> queryParams = {'q': query};
    if (apiKey != null && apiKey.trim().isNotEmpty) {
      queryParams['key'] = apiKey;
    }

    final response = await _dio.get(
      'https://www.googleapis.com/books/v1/volumes',
      queryParameters: queryParams,
    );

    final List results = response.data['items'] ?? [];

    return results.map((item) {
      final volumeInfo = item['volumeInfo'] ?? {};
      final imageLinks = volumeInfo['imageLinks'] ?? {};

      String? thumbnail = imageLinks['thumbnail'];

      if (thumbnail != null && thumbnail.startsWith('http://')) {
        thumbnail = thumbnail.replaceFirst('http://', 'https://');
      }

      return AppMedia(
        name: volumeInfo['title'] ?? '',
        description: volumeInfo['description'],
        rating: 1,
        imagePath: thumbnail,
        categoryId: categoryId,
      );
    }).toList();
  }
}
