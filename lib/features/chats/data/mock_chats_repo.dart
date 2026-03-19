import 'package:flutter_base_app/features/chats/domain/i_chats_repo.dart';

final class MockChatsRepo implements IChatsRepo {
  @override
  String get name => 'MockChatsRepo';
}
