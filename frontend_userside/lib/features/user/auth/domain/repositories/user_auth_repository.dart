import 'package:frontend_userside/features/user/auth/domain/entities/user.dart';

abstract class UserAuthRepository {
  Future<User> login(String email, String password);
  Future<User> register({
    required String fullName,
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<void> forgotPassword(String email);
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });
  Future<User?> getCurrentUser();
}
