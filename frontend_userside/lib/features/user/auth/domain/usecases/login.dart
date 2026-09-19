import 'package:frontend_userside/features/user/auth/domain/entities/user.dart';
import 'package:frontend_userside/features/user/auth/domain/repositories/user_auth_repository.dart';

class LoginUseCase {
  final UserAuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call(String email, String password) {
    return repository.login(email, password);
  }
}
