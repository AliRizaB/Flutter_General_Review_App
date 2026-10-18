import 'package:dio/dio.dart';
import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/services/storage_service.dart';
import 'package:get/get.dart' hide Response;
import 'dart:convert';

class ApiService extends BaseController {
  final StorageService _storageService = Get.find<StorageService>();

  // String get _currentLanguage =>
  //     _storageService.getValue(StorageKeys.languageCode) ?? 'en';
  late final Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json; charset=utf-8',
          'Accept-Charset': 'utf-8',
        },
      ),
    );

    _dio.interceptors.add(Utf8Interceptor());
  }

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
      } else if (categoryKey == StorageKeys.apiMovieAndSeries) {
        if (apiKey == null || apiKey.isEmpty) return [];
        return await _searchMoviesAndSeries(query, apiKey, categoryId);
      } else if (categoryKey == StorageKeys.apiAnime) {
        return await _searchAnimes(query, categoryId);
      } else if (categoryKey == StorageKeys.apiBook) {
        return await _searchBooks(query, categoryId);
      }
    } on DioException catch (e) {
      showErrorSnackBar(
        message: 'API Error (${e.response?.statusCode}): ${e.message}',
      );
    } catch (e) {
      showErrorSnackBar(message: 'Unexpected search error');
    }
    return [];
  }

  //
  // RAWG GAMES
  //
  Future<List<AppMedia>> _searchGames(
    String query,
    String apiKey,
    int categoryId,
  ) async {
    final response = await _dio.get(
      'https://api.rawg.io/api/games',
      queryParameters: {'key': apiKey, 'search': query, 'page_size': 10},
    );

    final List results = response.data['results'] ?? [];

    return results.map((item) {
      final String? ratingStr = item['rating']?.toString();
      final String released = item['released'] ?? 'N/A';

      return AppMedia(
        name: item['name'] ?? '',
        description: 'Released: $released • Rating: ${ratingStr ?? 'N/A'}',
        rating: 1,
        imagePath: item['background_image'],
        categoryId: categoryId,
      );
    }).toList();
  }

  //
  // OMDB MOVIES & SERIES
  //
  Future<List<AppMedia>> _searchMoviesAndSeries(
    String query,
    String apiKey,
    int categoryId,
  ) async {
    final response = await _dio.get(
      'https://www.omdbapi.com/',
      queryParameters: {'apikey': apiKey, 's': query},
    );

    if (response.data['Response'] == 'False') {
      return [];
    }

    final List results = response.data['Search'] ?? [];

    return results.map((item) {
      final poster = item['Poster'];
      final validPoster = (poster != null && poster != 'N/A') ? poster : null;

      return AppMedia(
        name: item['Title'] ?? '',
        description: '${item['Type']?.toUpperCase()} • ${item['Year']}',
        rating: 1,
        imagePath: validPoster,
        categoryId: categoryId,
      );
    }).toList();
  }

  //
  // ANILIST ANIME
  //
  Future<List<AppMedia>> _searchAnimes(
    String query,
    int categoryId, {
    String langCode = 'en',
  }) async {
    const gql = r'''
    query ($search: String, $perPage: Int) {
      Page(page: 1, perPage: $perPage) {
        media(search: $search, type: ANIME, sort: SEARCH_MATCH) {
          title { romaji english native }
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
      final titleObj = item['title'] ?? {};
      final title = langCode == 'ja'
          ? (titleObj['native'] ?? titleObj['romaji'] ?? titleObj['english'])
          : (titleObj['english'] ?? titleObj['romaji'] ?? titleObj['native']);

      final desc = _cleanDescription(item['description'] as String?);

      return AppMedia(
        name: title ?? 'Untitled Anime',
        description: desc ?? 'No description available.',
        rating: 1,
        imagePath: item['coverImage']?['large'],
        categoryId: categoryId,
      );
    }).toList();
  }

  //
  // OPEN LIBRARY
  //
  Future<List<AppMedia>> _searchBooks(
    String query,
    int categoryId, {
    String langCode = 'en',
  }) async {
    final ollang = _mapToOpenLibraryLang(langCode);

    final response = await _dio.get(
      'https://openlibrary.org/search.json',
      queryParameters: {
        'q': query,
        'limit': 10,
        'fields': 'title,author_name,cover_i,first_publish_year',
        'language': ollang,
      },
    );

    final List docs = response.data['docs'] ?? [];

    return docs.map((doc) {
      final coverId = doc['cover_i'];
      final coverUrl = coverId != null
          ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
          : null;

      final authorsList = doc['author_name'] as List?;
      final authorText = authorsList != null
          ? authorsList.join(', ')
          : 'Unknown Author';
      final year = doc['first_publish_year']?.toString() ?? 'N/A';

      return AppMedia(
        name: doc['title'] ?? 'Untitled Book',
        description: 'By $authorText ($year)',
        rating: 1,
        imagePath: coverUrl,
        categoryId: categoryId,
      );
    }).toList();
  }

  String _mapToOpenLibraryLang(String code) {
    switch (code.toLowerCase()) {
      case 'tr':
        return 'tur';
      // case 'es':
      //   return 'spa';
      // case 'fr':
      //   return 'fre';
      // case 'de':
      //   return 'ger';
      // case 'ja':
      //   return 'jpn';
      // case 'zh':
      //   return 'chi';
      // case 'it':
      //   return 'ita';
      // case 'ru':
      //   return 'rus';
      case 'en':
      default:
        return 'eng';
    }
  }

  String? _cleanDescription(String? raw, {int maxLength = 200}) {
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

    final cut = text.substring(0, maxLength - 1);
    final lastSpace = cut.lastIndexOf(' ');
    return '${cut.substring(0, lastSpace > 0 ? lastSpace : cut.length)}…';
  }
}

// Interceptor
class Utf8Interceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // If the response body is raw String data, force UTF-8 decoding
    if (response.data is String) {
      try {
        final String rawBody = response.data as String;
        response.data = jsonDecode(utf8.decode(rawBody.codeUnits));
      } catch (_) {
        // If already parsed or valid JSON, let Dio continue naturally
      }
    }
    super.onResponse(response, handler);
  }
}
