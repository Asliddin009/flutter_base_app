abstract interface class AppConfig {
  String get baseUrl;
  Duration get connectTimeout;
  Duration get receiveTimeout;
  Duration get sendTimeout;
}

final class AppConfigImpl implements AppConfig {
  @override
  final String baseUrl;

  @override
  final Duration connectTimeout;

  @override
  final Duration receiveTimeout;

  @override
  final Duration sendTimeout;

  const AppConfigImpl({
    required this.baseUrl,
    this.connectTimeout = const Duration(milliseconds: 15000),
    this.receiveTimeout = const Duration(milliseconds: 15000),
    this.sendTimeout = const Duration(milliseconds: 15000),
  });
}
