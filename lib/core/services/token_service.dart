import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenServices {
  static final TokenServices _instance = TokenServices._internal();
  factory TokenServices() => _instance;
  TokenServices._internal();

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _keyAccess = "x-auth-token";

  String? _accessToken;

  String? get accessToken => _accessToken;

  /// LOAD TOKEN ON APP START
  Future<void> loadToken() async {
    _accessToken = await _storage.read(key: _keyAccess);
  }

  /// STORE TOKEN
  Future<void> storeTokens({required String accessToken}) async {
    _accessToken = accessToken;
    await _storage.write(key: _keyAccess, value: accessToken);
  }

  /// CLEAR TOKEN (LOGOUT)
  Future<void> clear() async {
    _accessToken = null;
    await _storage.deleteAll();
  }
}
