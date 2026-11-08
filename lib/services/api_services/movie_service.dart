//
// OMDB MOVIES & SERIES
//
import 'package:dio/dio.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/services/api_services/helper/parse_query_notation.dart';

Future<List<AppMedia>> searchMoviesAndSeries({
  required Dio dio,
  required String query,
  required String apiKey,
  required int categoryId,
  String langCode = 'en',
  int page = 1,
}) async {
  try {
    final (titleQuery, yearFilter) = parseQueryNotation(query);
    final Map<String, dynamic> queryParams = {
      'apikey': apiKey,
      's': titleQuery,
      'page': page,
    };

    if (yearFilter != null && int.tryParse(yearFilter) != null) {
      queryParams['y'] = yearFilter;
    }

    final response = await dio.get(
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

        final detailResponse = await dio.get(
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
        final validPoster = (poster != null && poster != 'N/A') ? poster : null;

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
