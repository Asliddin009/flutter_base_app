abstract class AuthSession {
  String? get accessToken;
  Future<void> refreshToken();
}