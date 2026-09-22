import 'package:frontend_userside/features/user/auth/domain/repositories/user_auth_repository.dart';

class ResetPasswordUseCase {
  final UserAuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<void> call({required String token, required String newPassword}) {
    return repository.resetPassword(token: token, newPassword: newPassword);
  }
}
