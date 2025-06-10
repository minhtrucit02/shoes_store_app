import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/user_dao.dart';

final userDaoProvider = ChangeNotifierProvider<UserDao>((ref) {
  return UserDao();
});