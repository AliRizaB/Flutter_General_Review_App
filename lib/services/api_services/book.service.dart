//
// OPEN LIBRARY BOOKS
//
import 'package:dio/dio.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/services/api_services/helper/parse_query_notation.dart';

Future<List<AppMedia>> searchBooks({
  required Dio dio,
  required String query,
  required int categoryId,
  String langCode = 'en',
  int page = 1,
}) async {
  try {
    final (titleQuery, authorFilter) = parseQueryNotation(query);
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

    final response = await dio.get(
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
