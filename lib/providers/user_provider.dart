import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/services/service_impl/user_service_impl.dart';
import 'package:shoes_store_app/services/user_service.dart';

import '../models/userDB.dart';
import '../services/user_dao.dart';

final userDaoProvider = ChangeNotifierProvider<UserDao>((ref) {
  return UserDao(ref);
});


final userServiceProvider = Provider<UserService>((ref){
  return UserServiceImpl();
});

final addUserProvider = FutureProvider.family<void,UserDB>((ref,userDb)async{
  final service = ref.watch(userServiceProvider);
  await service.addUser(userDb);
});

final getEmailProvider = FutureProvider.family<String?,String>((ref,userId){
  final service = ref.watch(userServiceProvider);
  return service.getEmailUser(userId);
});