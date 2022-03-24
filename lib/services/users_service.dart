import 'package:collection/collection.dart';

import '../classes/user.dart';

class UsersService {
  final _users = <User>[
    User(email: 'test@email.com', firstName: 'Test1')..setPassword('password')
  ];

  Future<User?> findUserByEmail({required String email}) async =>
      _users.firstWhereOrNull((user) => user.email == email);
}
