import 'package:flutter_base_app/app/app_const.dart';
import 'package:flutter_base_app/features/auth/domain/tokens.dart';
import 'package:flutter_base_app/services/secure_storage/i_secure_storage.dart';

import 'auth_session.dart';

class AuthSessionImpl implements AuthSession {
  final ISecureStorage secureStorage;

  String? _cachedAccessToken;
  bool _isRefreshing = false;

  AuthSessionImpl({required this.secureStorage});

  @override
  String? get accessToken => _cachedAccessToken;

  Future<void> init() async {
    try {
      final data = await secureStorage.read(AppConst.storageTokensKey);
      final tokens = Tokens.fromJson(data);
      _cachedAccessToken = tokens.accessToken;
    } catch (_) {
      // Tokens not found or invalid
    }
  }

  @override
  Future<void> refreshToken() async {
    if (_isRefreshing) return;
    _isRefreshing = true;

    try {} finally {
      _isRefreshing = false;
    }
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    _cachedAccessToken = accessToken;
    final tokens = Tokens(accessToken: accessToken, refreshToken: refreshToken);
    await secureStorage.write(AppConst.storageTokensKey, tokens.toJson());
  }

  Future<void> clearTokens() async {
    _cachedAccessToken = null;
    await secureStorage.delete(AppConst.storageTokensKey);
  }
}
