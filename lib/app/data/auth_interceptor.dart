import 'package:dio/dio.dart';
import 'auth_session.dart';

class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({required this.dio, required this.authSession});

  final Dio dio;
  final AuthSession authSession;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = authSession.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final is401 = err.response?.statusCode == 401;
    final alreadyRetried = err.requestOptions.extra['retried'] == true;

    if (!is401 || alreadyRetried) {
      return handler.next(err);
    }

    try {
      await authSession.refreshToken();
      final newToken = authSession.accessToken;

      if (newToken == null || newToken.isEmpty) {
        return handler.next(err);
      }

      final requestOptions = err.requestOptions;
      requestOptions.headers['Authorization'] = 'Bearer $newToken';
      requestOptions.extra['retried'] = true;

      final response = await dio.fetch(requestOptions);
      return handler.resolve(response);
    } catch (_) {
      return handler.next(err);
    }
  }
}
