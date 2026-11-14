(String mainQuery, String? filter) parseQueryNotation(String rawQuery) {
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
