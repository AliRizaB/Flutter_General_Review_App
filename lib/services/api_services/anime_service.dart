//
// ANILIST ANIME
//
import 'package:dio/dio.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/services/api_services/helper/clean_description.dart';
import 'package:flutter_general_reviewer/services/api_services/helper/parse_query_notation.dart';

Future<List<AppMedia>> searchAnimes({
  required Dio dio,
  required String query,
  required int categoryId,
  String langCode = 'en',
  int page = 1,
}) async {
  try {
    final (titleQuery, filter) = parseQueryNotation(query);

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

    final Map<String, dynamic> variables = {'search': titleQuery, 'page': page};

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

    final response = await dio.post(
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

      final desc = cleanDescription(item['description'] as String?);

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
