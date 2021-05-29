import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const String accessTokenKey = 'access_token';
  static const String accessTokenExpirationDateTimeKey =
      'access_token_expiration_datetime';
  static const String refreshTokenKey = 'refresh_token';
  final FlutterSecureStorage flutterSecureStorage;
  SecureStorageService(this.flutterSecureStorage);
  Future<String> getAccessToken() {
    return flutterSecureStorage.read(key: accessTokenKey);
  }

  Future<void> saveAccessToken(String accessToken) {
    return flutterSecureStorage.write(key: accessTokenKey, value: accessToken);
  }

  Future<DateTime> getAccessTokenExpirationDateTime() async {
    final String iso8601ExpirationDate =
        await flutterSecureStorage.read(key: accessTokenExpirationDateTimeKey);
    // if (iso8601ExpirationDate == null) {
    //   return null;
    // }
    return DateTime.parse(iso8601ExpirationDate);
  }

  Future<void> saveAccessTokenExpiresIn(
      DateTime accessTokenExpirationDateTime) {
    return flutterSecureStorage.write(
        key: accessTokenExpirationDateTimeKey,
        value: accessTokenExpirationDateTime.toIso8601String());
  }

  Future<String> getRefreshToken() {
    return flutterSecureStorage.read(key: refreshTokenKey);
  }

  Future<void> saveRefreshToken(String refreshToken) {
    return flutterSecureStorage.write(
        key: refreshTokenKey, value: refreshToken);
  }

  Future<void> deleteAll() {
    return flutterSecureStorage.deleteAll();
  }
}
