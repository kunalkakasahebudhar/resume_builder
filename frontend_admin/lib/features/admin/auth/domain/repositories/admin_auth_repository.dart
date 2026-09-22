import 'package:frontend_admin/features/admin/auth/domain/entities/admin.dart';

abstract class AdminAuthRepository {
  Future<Admin> login(String email, String password, {bool rememberMe = false});
  Future<void> logout();
  Future<Admin?> getCurrentAdmin();
  Future<bool> isAuthenticated();
}
