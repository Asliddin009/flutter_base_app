import 'package:flutter_base_app/app/app_env.dart';
import 'package:flutter_base_app/app/data/app_api.dart';
import 'package:flutter_base_app/app/data/app_config.dart';
import 'package:flutter_base_app/app/data/auth_session.dart';
import 'package:flutter_base_app/app/data/auth_session_impl.dart';
import 'package:flutter_base_app/app/data/dio_app_api.dart';
import 'package:flutter_base_app/features/auth/data/mock_auth_repo.dart';
import 'package:flutter_base_app/features/auth/data/prod_auth_repo.dart';
import 'package:flutter_base_app/features/auth/domain/i_auth_repo.dart';
import 'package:flutter_base_app/features/chats/data/mock_chats_repo.dart';
import 'package:flutter_base_app/features/chats/data/prod_chats_repo.dart';
import 'package:flutter_base_app/features/chats/domain/i_chats_repo.dart';
import 'package:flutter_base_app/services/secure_storage/i_secure_storage.dart';
import 'package:flutter_base_app/services/secure_storage/secure_storage.dart';

typedef OnError =
    void Function(String name, Object error, StackTrace? stackTrace);
typedef OnProgress = void Function(String name);

final class AppDepends {
  late final AppApi appApi;
  late final IAuthRepo authRepo;
  late final IChatsRepo chatsRepo;
  late final ISecureStorage secureStorage;
  late final AuthSession _authSession;

  final AppEnv env;

  AppDepends(this.env);

  Future<void> init({
    required OnError onError,
    required OnProgress onProgress,
  }) async {
    try {
      secureStorage = SecureStorage();
      onProgress(secureStorage.name);
    } on Object catch (error, stackTrace) {
      onError('secureStorage', error, stackTrace);
    }

    try {
      _authSession = AuthSessionImpl(secureStorage: secureStorage);
      await (_authSession as AuthSessionImpl).init();
      onProgress('authSession');
    } on Object catch (error, stackTrace) {
      onError('authSession', error, stackTrace);
    }

    try {
      final config = _createAppConfig();
      appApi = DioAppApi(appConfig: config, authSession: _authSession);
      onProgress('appApi');
    } on Object catch (error, stackTrace) {
      onError('appApi', error, stackTrace);
    }

    try {
      authRepo = switch (env) {
        AppEnv.test => MockAuthRepo(),
        AppEnv.prod => ProdAuthRepo(),
      };
      onProgress(authRepo.name);
    } on Object catch (error, stackTrace) {
      onError('authRepo', error, stackTrace);
    }

    try {
      chatsRepo = switch (env) {
        AppEnv.test => MockChatsRepo(),
        AppEnv.prod => ProdChatsRepo(),
      };
      onProgress(chatsRepo.name);
    } on Object catch (error, stackTrace) {
      onError('chatsRepo', error, stackTrace);
    }
  }

  AppConfig _createAppConfig() {
    return AppConfigImpl(
      baseUrl: env == AppEnv.prod
          ? 'https://api.example.com'
          : 'https://staging-api.example.com',
    );
  }
}
