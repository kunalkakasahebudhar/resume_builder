import 'package:frontend_userside/features/user/auth/domain/repositories/user_auth_repository.dart';

class ForgotPasswordUseCase {
  final UserAuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<void> call(String email) {
    return repository.forgotPassword(email);
  }
}
