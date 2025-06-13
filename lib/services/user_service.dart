import '../models/userDB.dart';

abstract class UserService{
  Future<void> addUser(UserDB user);
  Future<String?> getEmailUser(String userId);
}