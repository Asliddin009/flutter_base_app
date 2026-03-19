import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'app_api.dart';
import 'app_config.dart';
import 'auth_interceptor.dart';
import 'auth_session.dart';

class DioAppApi implements AppApi {
  late final Dio _dio;

  DioAppApi({required AppConfig appConfig, required AuthSession authSession}) {
    final options = BaseOptions(
      baseUrl: appConfig.baseUrl,
      connectTimeout: appConfig.connectTimeout,
      receiveTimeout: appConfig.receiveTimeout,
      sendTimeout: appConfig.sendTimeout,
    );

    _dio = Dio(options);
    _setupInterceptors(authSession);
  }

  @override
  Dio get client => _dio;

  void _setupInterceptors(AuthSession authSession) {
    // Логирование в debug режиме
    if (kDebugMode) {
      _dio.interceptors.add(_createLoggerInterceptor());
    }

    // Retry interceptor для транзиентных ошибок
    _dio.interceptors.add(_createRetryInterceptor());

    // Auth interceptor должен быть последним, чтобы уловить все ошибки
    _dio.interceptors.add(AuthInterceptor(dio: _dio, authSession: authSession));
  }

  Interceptor _createLoggerInterceptor() {
    return LogInterceptor(
      requestHeader: true,
      responseHeader: true,
      responseBody: true,
      requestBody: true,
      error: true,
    );
  }

  Interceptor _createRetryInterceptor() {
    return RetryInterceptor(dio: _dio);
  }
}

class RetryInterceptor extends QueuedInterceptor {
  final Dio dio;
  static const int maxRetries = 3;
  static const List<int> retryStatusCodes = [408, 429, 500, 502, 503, 504];

  RetryInterceptor({required this.dio});

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final retryCount = (err.requestOptions.extra['retryCount'] ?? 0) as int;

    if (retryStatusCodes.contains(statusCode) && retryCount < maxRetries) {
      err.requestOptions.extra['retryCount'] = retryCount + 1;

      // Exponential backoff
      final delayMs = 100 * (retryCount + 1);
      await Future.delayed(Duration(milliseconds: delayMs));

      try {
        final response = await dio.fetch<dynamic>(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }

    return handler.next(err);
  }
}
