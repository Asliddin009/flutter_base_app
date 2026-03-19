import 'package:flutter_base_app/features/auth/domain/i_auth_repo.dart';

final class ProdAuthRepo implements IAuthRepo {
  @override
  String get name => 'ProdAuthRepo';

  @override
  Future<(String, String)> sendSms(String phone, String code) {
    throw UnimplementedError();
  }

  @override
  Future<String> signInSms(String phone) {
    throw UnimplementedError();
  }
}
