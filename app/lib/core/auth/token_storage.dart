// lib/core/auth/token_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

/// Secure storage wrapper for the Django JWT access and refresh tokens.
class TokenStorage {
  TokenStorage._();

  static final _storage = FlutterSecureStorage(
    aOptions: const AndroidOptions(encryptedSharedPreferences: true),
    iOptions: const IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // ── Access Token ────────────────────────────────────────────────────────────

  static Future<void> saveAccessToken(String token) =>
      _storage.write(key: AppConstants.keyDjangoAccessToken, value: token);

  static Future<String?> getAccessToken() =>
      _storage.read(key: AppConstants.keyDjangoAccessToken);

  static Future<void> deleteAccessToken() =>
      _storage.delete(key: AppConstants.keyDjangoAccessToken);

  // ── Refresh Token ───────────────────────────────────────────────────────────

  static Future<void> saveRefreshToken(String token) =>
      _storage.write(key: AppConstants.keyDjangoRefreshToken, value: token);

  static Future<String?> getRefreshToken() =>
      _storage.read(key: AppConstants.keyDjangoRefreshToken);

  static Future<void> deleteRefreshToken() =>
      _storage.delete(key: AppConstants.keyDjangoRefreshToken);

  // ── Save Both ───────────────────────────────────────────────────────────────

  static Future<void> saveTokenPair({
    required String access,
    required String refresh,
  }) async {
    await Future.wait([
      saveAccessToken(access),
      saveRefreshToken(refresh),
    ]);
  }

  // ── Clear All (on sign-out) ─────────────────────────────────────────────────

  static Future<void> clearAll() async {
    await Future.wait([
      deleteAccessToken(),
      deleteRefreshToken(),
    ]);
  }

  /// Returns true if a valid access token is present (does not validate expiry).
  static Future<bool> hasAccessToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
