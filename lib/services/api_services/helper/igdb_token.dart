import 'package:dio/dio.dart';

String? _igdbAccessToken;
DateTime? _igdbTokenExpiry;

Future<String?> getIgdbAccessToken({
  required Dio dio,
  required String clientId,
  required String clientSecret,
}) async {
  // Return cached token if it's still valid
  if (_igdbAccessToken != null &&
      _igdbTokenExpiry != null &&
      DateTime.now().isBefore(_igdbTokenExpiry!)) {
    return _igdbAccessToken;
  }

  try {
    final response = await dio.post(
      'https://id.twitch.tv/oauth2/token',
      queryParameters: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'grant_type': 'client_credentials',
      },
    );

    _igdbAccessToken = response.data['access_token'];
    final int expiresIn = response.data['expires_in'] ?? 5000000;

    // Set expiry buffer (subtracting 5 minutes for safety)
    _igdbTokenExpiry = DateTime.now().add(Duration(seconds: expiresIn - 300));

    return _igdbAccessToken;
  } catch (e) {
    return null;
  }
}
