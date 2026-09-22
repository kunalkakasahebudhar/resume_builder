import 'package:frontend_userside/features/user/auth/domain/repositories/user_auth_repository.dart';

class LogoutUseCase {
  final UserAuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}
