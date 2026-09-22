import 'package:frontend_admin/features/admin/auth/domain/entities/admin.dart';
import 'package:frontend_admin/features/admin/auth/domain/repositories/admin_auth_repository.dart';

class AdminLogin {
  final AdminAuthRepository repository;

  AdminLogin(this.repository);

  Future<Admin> call(String email, String password, {bool rememberMe = false}) {
    return repository.login(email, password, rememberMe: rememberMe);
  }
}
