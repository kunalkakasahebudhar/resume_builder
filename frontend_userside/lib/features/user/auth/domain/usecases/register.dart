import 'package:frontend_userside/features/user/auth/domain/entities/user.dart';
import 'package:frontend_userside/features/user/auth/domain/repositories/user_auth_repository.dart';

class RegisterUseCase {
  final UserAuthRepository repository;

  RegisterUseCase(this.repository);

  Future<User> call({
    required String fullName,
    required String email,
    required String password,
  }) {
    return repository.register(
      fullName: fullName,
      email: email,
      password: password,
    );
  }
}
