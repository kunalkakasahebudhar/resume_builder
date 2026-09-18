import 'package:frontend_admin/features/admin/users/domain/entities/admin_user.dart';

abstract class AdminUserRepository {
  Future<List<AdminUser>> getUsers({
    String? search,
    String? status,
    String? sortBy,
    bool ascending = true,
  });
  Future<AdminUser?> getUserById(String id);
  Future<void> updateUserStatus(String id, String status);
  Future<void> deleteUser(String id);
}
