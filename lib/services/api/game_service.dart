//
// IGDB (Twitch/Amazon) API
//
import 'package:dio/dio.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/services/api/helper/igdb_token.dart';
import 'package:flutter_general_reviewer/services/api/helper/parse_query_notation.dart';

Future<List<AppMedia>> searchGames({
  required Dio dio,
  required String query,
  required String clientId,
  required String clientSecret,
  required int categoryId,
  String langCode = 'en',
  int page = 1,
}) async {
  try {
    // 1. Direct validation check for empty credentials
    if (clientId.trim().isEmpty || clientSecret.trim().isEmpty) return [];

    // 2. Fetch or reuse OAuth token
    final String? token = await getIgdbAccessToken(
      dio: dio,
      clientId: clientId.trim(),
      clientSecret: clientSecret.trim(),
    );
    if (token == null) return [];

    final (titleQuery, yearFilter) = parseQueryNotation(query);

    const int pageSize = 10;
    final int offset = (page - 1) * pageSize;

    // 3. Build APICALipse query string
    final StringBuffer bodyBuilder = StringBuffer();
    bodyBuilder.write(
      'fields name, cover.url, first_release_date, aggregated_rating, total_rating, genres.name; ',
    );
    bodyBuilder.write('search "$titleQuery"; ');
    bodyBuilder.write('limit $pageSize; ');
    bodyBuilder.write('offset $offset; ');

    if (yearFilter != null && int.tryParse(yearFilter) != null) {
      final year = int.parse(yearFilter);
      final startUnix = DateTime.utc(year, 1, 1).millisecondsSinceEpoch ~/ 1000;
      final endUnix =
          DateTime.utc(year, 12, 31, 23, 59, 59).millisecondsSinceEpoch ~/ 1000;
      bodyBuilder.write(
        'where first_release_date >= $startUnix & first_release_date <= $endUnix; ',
      );
    }

    // 4. Send POST request to IGDB endpoint
    final response = await dio.post(
      'https://api.igdb.com/v4/games',
      options: Options(
        headers: {
          'Client-ID': clientId.trim(),
          'Authorization': 'Bearer $token',
          'Content-Type': 'text/plain',
        },
      ),
      data: bodyBuilder.toString(),
    );

    final List results = response.data ?? [];

    final isTr = langCode.toLowerCase() == 'tr';
    final lblReleased = isTr ? 'Yayınlanma' : 'Released';
    final lblRating = isTr ? 'Puan' : 'Rating';

    return results.map((item) {
      // High-res box art replacement (t_thumb -> t_cover_big)
      String? imagePath;
      if (item['cover'] != null && item['cover']['url'] != null) {
        final String rawUrl = item['cover']['url'];
        imagePath = 'https:${rawUrl.replaceAll('t_thumb', 't_cover_big')}';
      }

      // Release year conversion
      String releaseYear = 'N/A';
      if (item['first_release_date'] != null) {
        final int timestamp = item['first_release_date'];
        final date = DateTime.fromMillisecondsSinceEpoch(
          timestamp * 1000,
          isUtc: true,
        );
        releaseYear = date.year.toString();
      }

      // Score formatting
      String ratingStr = 'N/A';
      if (item['aggregated_rating'] != null) {
        ratingStr = (item['aggregated_rating'] as num).toStringAsFixed(1);
      } else if (item['total_rating'] != null) {
        ratingStr = (item['total_rating'] as num).toStringAsFixed(1);
      }

      // Genres
      final List genresList = item['genres'] ?? [];
      final String genres = genresList
          .map((g) => g['name'] ?? '')
          .where((gName) => gName.toString().isNotEmpty)
          .take(2)
          .join(', ');

      final StringBuffer descBuilder = StringBuffer();
      descBuilder.write('$lblReleased: $releaseYear');
      if (genres.isNotEmpty) descBuilder.write(' • $genres');
      descBuilder.write('\n$lblRating: $ratingStr');

      return AppMedia(
        name: item['name'] ?? '',
        description: descBuilder.toString(),
        rating: 1,
        imagePath: imagePath,
        categoryId: categoryId,
      );
    }).toList();
  } catch (e) {
    return [];
  }
}

  //
  // RAWG GAMES
  //
  // Future<List<AppMedia>> _searchGames(
  //   String query,
  //   String apiKey,
  //   int categoryId, {
  //   String langCode = 'en',
  //   int page = 1,
  // }) async {
  //   try {
  //     final (titleQuery, yearFilter) = _parseQueryNotation(query);
  //     final Map<String, dynamic> queryParams = {
  //       'key': apiKey,
  //       'search': titleQuery,
  //       'page_size': 10,
  //       'page': page,
  //     };

  //     // Filter games released in that specific year range (e.g. 2026-01-01 to 2026-12-31)
  //     if (yearFilter != null && int.tryParse(yearFilter) != null) {
  //       queryParams['dates'] = '$yearFilter-01-01,$yearFilter-12-31';
  //     }

  //     final response = await _dio.get(
  //       'https://api.rawg.io/api/games',
  //       queryParameters: queryParams,
  //     );

  //     final List results = response.data['results'] ?? [];

  //     final isTr = langCode.toLowerCase() == 'tr';
  //     final lblReleased = isTr ? 'Yayınlanma' : 'Released';
  //     final lblRating = isTr ? 'Puan' : 'Rating';

  //     return results.map((item) {
  //       final String released = item['released'] ?? 'N/A';
  //       final String releaseYear = released.split('-').first;
  //       final String ratingStr = item['rating']?.toString() ?? 'N/A';
  //       final int? metacritic = item['metacritic'];

  //       final List genresList = item['genres'] ?? [];
  //       final String genres = genresList
  //           .map((g) => g['name'])
  //           .take(2)
  //           .join(', ');

  //       final StringBuffer descBuilder = StringBuffer();
  //       descBuilder.write('$lblReleased: $releaseYear');
  //       if (genres.isNotEmpty) descBuilder.write(' • $genres');
  //       descBuilder.write('\n$lblRating: $ratingStr/5');
  //       if (metacritic != null) descBuilder.write(' (Metacritic: $metacritic)');

  //       return AppMedia(
  //         name: item['name'] ?? '',
  //         description: descBuilder.toString(),
  //         rating: 1,
  //         imagePath: item['background_image'],
  //         categoryId: categoryId,
  //       );
  //     }).toList();
  //   } catch (e) {
  //     return [];
  //   }
  // }