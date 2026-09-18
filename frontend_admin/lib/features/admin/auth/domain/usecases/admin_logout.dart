import 'package:frontend_admin/features/admin/auth/domain/repositories/admin_auth_repository.dart';

class AdminLogout {
  final AdminAuthRepository repository;

  AdminLogout(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}
