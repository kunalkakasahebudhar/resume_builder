import 'package:frontend_admin/features/admin/users/domain/entities/admin_user.dart';
import 'package:frontend_admin/features/admin/users/domain/repositories/admin_user_repository.dart';
import 'package:frontend_admin/features/admin/users/data/datasources/admin_user_remote_datasource.dart';

class AdminUserRepositoryImpl implements AdminUserRepository {
  final AdminUserRemoteDataSource remoteDataSource;

  AdminUserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AdminUser>> getUsers({
    String? search,
    String? status,
    String? sortBy,
    bool ascending = true,
  }) async {
    final users = await remoteDataSource.getUsers();
    var filtered = List<AdminUser>.from(users);

    if (search != null && search.trim().isNotEmpty) {
      final q = search.trim().toLowerCase();
      filtered = filtered.where((u) {
        return u.name.toLowerCase().contains(q) ||
            u.email.toLowerCase().contains(q);
      }).toList();
    }

    if (status != null && status != 'All') {
      filtered = filtered
          .where((u) => u.status.toLowerCase() == status.toLowerCase())
          .toList();
    }

    if (sortBy != null) {
      if (sortBy == 'name') {
        filtered.sort(
          (a, b) =>
              ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name),
        );
      } else if (sortBy == 'joined') {
        filtered.sort(
          (a, b) => ascending
              ? a.createdAt.compareTo(b.createdAt)
              : b.createdAt.compareTo(a.createdAt),
        );
      } else if (sortBy == 'resumes') {
        filtered.sort(
          (a, b) => ascending
              ? a.resumesCount.compareTo(b.resumesCount)
              : b.resumesCount.compareTo(a.resumesCount),
        );
      }
    }

    return filtered;
  }

  @override
  Future<AdminUser?> getUserById(String id) {
    return remoteDataSource.getUserById(id);
  }

  @override
  Future<void> updateUserStatus(String id, String status) {
    return remoteDataSource.updateUserStatus(id, status);
  }

  @override
  Future<void> deleteUser(String id) {
    return remoteDataSource.deleteUser(id);
  }
}
