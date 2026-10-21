import 'package:dio/dio.dart';
import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/services/storage_service.dart';
import 'package:get/get.dart' hide Response;

class ApiService extends BaseController {
  final StorageService _storageService = Get.find<StorageService>();

  String get _currentLanguage => _storageService.selectedLanguageCode.value;
  late final Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _dio = Dio(
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
        if (apiKey == null || apiKey.isEmpty) return [];
        return await _searchGames(
          query,
          apiKey,
          categoryId,
          langCode: _currentLanguage,
          page: page,
        );
      } else if (categoryKey == StorageKeys.apiMovieAndSeries) {
        if (apiKey == null || apiKey.isEmpty) return [];
        return await _searchMoviesAndSeries(
          query,
          apiKey,
          categoryId,
          langCode: _currentLanguage,
          page: page,
        );
      } else if (categoryKey == StorageKeys.apiAnime) {
        return await _searchAnimes(
          query,
          categoryId,
          langCode: _currentLanguage,
          page: page,
        );
      } else if (categoryKey == StorageKeys.apiBook) {
        return await _searchBooks(
          query,
          categoryId,
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

  //
  // RAWG GAMES
  //
  Future<List<AppMedia>> _searchGames(
    String query,
    String apiKey,
    int categoryId, {
    String langCode = 'en',
    int page = 1,
  }) async {
    try {
      final (titleQuery, yearFilter) = _parseQueryNotation(query);
      final Map<String, dynamic> queryParams = {
        'key': apiKey,
        'search': titleQuery,
        'page_size': 10,
        'page': page,
      };

      // Filter games released in that specific year range (e.g. 2026-01-01 to 2026-12-31)
      if (yearFilter != null && int.tryParse(yearFilter) != null) {
        queryParams['dates'] = '$yearFilter-01-01,$yearFilter-12-31';
      }

      final response = await _dio.get(
        'https://api.rawg.io/api/games',
        queryParameters: queryParams,
      );

      final List results = response.data['results'] ?? [];

      final isTr = langCode.toLowerCase() == 'tr';
      final lblReleased = isTr ? 'Yayınlanma' : 'Released';
      final lblRating = isTr ? 'Puan' : 'Rating';

      return results.map((item) {
        final String released = item['released'] ?? 'N/A';
        final String releaseYear = released.split('-').first;
        final String ratingStr = item['rating']?.toString() ?? 'N/A';
        final int? metacritic = item['metacritic'];

        final List genresList = item['genres'] ?? [];
        final String genres = genresList
            .map((g) => g['name'])
            .take(2)
            .join(', ');

        final StringBuffer descBuilder = StringBuffer();
        descBuilder.write('$lblReleased: $releaseYear');
        if (genres.isNotEmpty) descBuilder.write(' • $genres');
        descBuilder.write('\n$lblRating: $ratingStr/5');
        if (metacritic != null) descBuilder.write(' (Metacritic: $metacritic)');

        return AppMedia(
          name: item['name'] ?? '',
          description: descBuilder.toString(),
          rating: 1,
          imagePath: item['background_image'],
          categoryId: categoryId,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  //
  // OMDB MOVIES & SERIES
  //
  Future<List<AppMedia>> _searchMoviesAndSeries(
    String query,
    String apiKey,
    int categoryId, {
    String langCode = 'en',
    int page = 1,
  }) async {
    try {
      final (titleQuery, yearFilter) = _parseQueryNotation(query);
      final Map<String, dynamic> queryParams = {
        'apikey': apiKey,
        's': titleQuery,
        'page': page,
      };

      if (yearFilter != null && int.tryParse(yearFilter) != null) {
        queryParams['y'] = yearFilter;
      }

      final response = await _dio.get(
        'https://www.omdbapi.com/',
        queryParameters: queryParams,
      );

      if (response.data['Response'] == 'False') {
        return [];
      }

      final List results = response.data['Search'] ?? [];

      final isTr = langCode.toLowerCase() == 'tr';
      final lblDir = isTr ? 'Yön' : 'Dir';
      final lblGenre = isTr ? 'Tür' : 'Genre';

      final detailedMediaList = await Future.wait(
        results.take(5).map((item) async {
          final String? imdbId = item['imdbID'];

          if (imdbId == null) {
            return AppMedia(
              name: item['Title'] ?? '',
              description: '${item['Type']?.toUpperCase()} • ${item['Year']}',
              rating: 1,
              imagePath: item['Poster'] != 'N/A' ? item['Poster'] : null,
              categoryId: categoryId,
            );
          }

          final detailResponse = await _dio.get(
            'https://www.omdbapi.com/',
            queryParameters: {'apikey': apiKey, 'i': imdbId, 'plot': 'short'},
          );

          final detailData = detailResponse.data;
          final String director = detailData['Director'] ?? 'N/A';
          final String year = detailData['Year'] ?? item['Year'] ?? '';
          final String type = (detailData['Type'] ?? item['Type'] ?? '')
              .toUpperCase();
          final String genre = detailData['Genre'] ?? '';
          final String plot = detailData['Plot'] ?? '';

          final poster = item['Poster'];
          final validPoster = (poster != null && poster != 'N/A')
              ? poster
              : null;

          final StringBuffer descBuilder = StringBuffer();
          descBuilder.write('$type • $year');
          if (director != 'N/A') descBuilder.write(' • $lblDir: $director');
          if (genre.isNotEmpty) descBuilder.write('\n$lblGenre: $genre');
          if (plot.isNotEmpty && plot != 'N/A') descBuilder.write('\n$plot');

          return AppMedia(
            name: detailData['Title'] ?? item['Title'] ?? '',
            description: descBuilder.toString(),
            rating: 1,
            imagePath: validPoster,
            categoryId: categoryId,
          );
        }),
      );

      return detailedMediaList;
    } catch (e) {
      return [];
    }
  }

  //
  // ANILIST ANIME
  //
  Future<List<AppMedia>> _searchAnimes(
    String query,
    int categoryId, {
    String langCode = 'en',
    int page = 1,
  }) async {
    try {
      final (titleQuery, filter) = _parseQueryNotation(query);

      const gql = r'''
        query ($search: String, $page: Int, $year: Int, $format: MediaFormat) {
        Page(page: $page, perPage: 10) {
        media(search: $search, seasonYear: $year, format: $format, type: ANIME, sort: SEARCH_MATCH) {
            title { romaji english native }
            description(asHtml: false)
            coverImage { large }
            startDate { year }
            format
        }
      }
    }
    ''';

      final Map<String, dynamic> variables = {
        'search': titleQuery,
        'page': page,
      };

      if (filter != null) {
        final parsedYear = int.tryParse(filter);
        if (parsedYear != null) {
          variables['year'] = parsedYear;
        } else if ([
          'TV',
          'MOVIE',
          'OVA',
          'SPECIAL',
        ].contains(filter.toUpperCase())) {
          variables['format'] = filter.toUpperCase();
        }
      }

      final response = await _dio.post(
        'https://graphql.anilist.co',
        data: {'query': gql, 'variables': variables},
      );

      final List results = response.data['data']?['Page']?['media'] ?? [];

      return results.map((item) {
        final titleObj = item['title'] ?? {};
        final title =
            titleObj['english'] ??
            titleObj['romaji'] ??
            titleObj['native'] ??
            'Untitled Anime';

        final desc = _cleanDescription(item['description'] as String?);

        return AppMedia(
          name: title ?? 'Untitled Anime',
          description: desc ?? 'No description available.',
          rating: 1,
          imagePath: item['coverImage']?['large'],
          categoryId: categoryId,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  //
  // OPEN LIBRARY BOOKS
  //
  Future<List<AppMedia>> _searchBooks(
    String query,
    int categoryId, {
    String langCode = 'en',
    int page = 1,
  }) async {
    try {
      final (titleQuery, authorFilter) = _parseQueryNotation(query);
      final Map<String, dynamic> queryParams = {
        'limit': 10,
        'page': page,
        'fields':
            'title,author_name,cover_i,first_publish_year,publisher,subject,number_of_pages_median',
      };

      if (authorFilter != null) {
        queryParams['q'] = 'title:"$titleQuery" author:"$authorFilter"';
      } else {
        queryParams['q'] = titleQuery;
      }

      final response = await _dio.get(
        'https://openlibrary.org/search.json',
        queryParameters: queryParams,
      );

      final List results = response.data['docs'] ?? [];

      final isTr = langCode.toLowerCase() == 'tr';
      final lblBy = isTr ? 'Yazar:' : 'By';
      final lblGenre = isTr ? 'Tür' : 'Genre';
      final lblPages = isTr ? 'Sayfa' : 'Pages';

      return results.map((doc) {
        final coverId = doc['cover_i'];
        final coverUrl = coverId != null
            ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
            : null;

        final authorsList = doc['author_name'] as List?;
        final authorText = authorsList != null
            ? authorsList.join(', ')
            : (isTr ? 'Bilinmeyen Yazar' : 'Unknown Author');

        final year = doc['first_publish_year']?.toString() ?? 'N/A';

        final publishersList = doc['publisher'] as List?;
        final publisher = (publishersList != null && publishersList.isNotEmpty)
            ? publishersList.first.toString()
            : '';

        final subjectsList = doc['subject'] as List?;
        final genres = (subjectsList != null && subjectsList.isNotEmpty)
            ? subjectsList.cast<String>().take(2).join(', ')
            : '';

        final int? pageCount = doc['number_of_pages_median'];

        final StringBuffer descBuilder = StringBuffer();
        descBuilder.write('$lblBy $authorText ($year)');
        if (publisher.isNotEmpty) descBuilder.write(' • $publisher');
        if (genres.isNotEmpty) descBuilder.write('\n$lblGenre: $genres');
        if (pageCount != null) descBuilder.write('\n$lblPages: ~$pageCount');

        return AppMedia(
          name: doc['title'] ?? 'Untitled Book',
          description: descBuilder.toString(),
          rating: 1,
          imagePath: coverUrl,
          categoryId: categoryId,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  (String mainQuery, String? filter) _parseQueryNotation(String rawQuery) {
    // Get the last ',' comma's index so this will help with the title's with the commas
    final lastCommaIndex = rawQuery.lastIndexOf(',');

    // If there is no ',' then do not query it and just give the rawQuery
    if (lastCommaIndex == -1) {
      return (rawQuery.trim(), null);
    }

    final mainQuery = rawQuery.substring(0, lastCommaIndex).trim();
    final filter = rawQuery.substring(lastCommaIndex + 1).trim();
    return (mainQuery, filter.isEmpty ? null : filter);
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
