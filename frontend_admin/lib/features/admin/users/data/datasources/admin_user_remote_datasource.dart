import 'package:frontend_admin/core/constants/api_constants.dart';
import 'package:frontend_admin/core/network/api_client.dart';
import 'package:frontend_admin/features/admin/users/data/models/admin_user_model.dart';

abstract class AdminUserRemoteDataSource {
  Future<List<AdminUserModel>> getUsers();
  Future<AdminUserModel> getUserById(String id);
  Future<void> updateUserStatus(String id, String status);
  Future<void> deleteUser(String id);
}

class AdminUserRemoteDataSourceImpl implements AdminUserRemoteDataSource {
  final ApiClient apiClient;

  // Realistic In-Memory Mock Data Store
  final List<AdminUserModel> _mockUsers = [
    AdminUserModel(
      id: 'usr_101',
      name: 'Rohan Sharma',
      email: 'rohan.sharma@example.com',
      phone: '+91 98201 12345',
      linkedIn: 'https://linkedin.com/in/rohansharma',
      github: 'https://github.com/rohansharma',
      portfolio: 'https://rohansharma.dev',
      resumesCount: 3,
      status: 'Active',
      createdAt: DateTime(2026, 8, 12, 14, 30),
      lastActive: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    AdminUserModel(
      id: 'usr_102',
      name: 'Priya Patel',
      email: 'priya.patel@example.com',
      phone: '+91 98765 43210',
      linkedIn: 'https://linkedin.com/in/priyapatel',
      github: 'https://github.com/priyapatel',
      portfolio: 'https://priyapatel.design',
      resumesCount: 2,
      status: 'Active',
      createdAt: DateTime(2026, 7, 24, 10, 15),
      lastActive: DateTime.now().subtract(const Duration(minutes: 42)),
    ),
    AdminUserModel(
      id: 'usr_103',
      name: 'Vikram Singh',
      email: 'vikram.singh@example.com',
      phone: '+91 99112 33445',
      linkedIn: 'https://linkedin.com/in/vikramsingh',
      github: 'https://github.com/vikramsingh',
      portfolio: null,
      resumesCount: 1,
      status: 'Inactive',
      createdAt: DateTime(2026, 6, 11, 16, 20),
      lastActive: DateTime.now().subtract(const Duration(days: 3)),
    ),
    AdminUserModel(
      id: 'usr_104',
      name: 'Ananya Roy',
      email: 'ananya.roy@example.com',
      phone: '+91 97123 45678',
      linkedIn: 'https://linkedin.com/in/ananyaroy',
      github: 'https://github.com/ananyaroy',
      portfolio: 'https://ananya.tech',
      resumesCount: 4,
      status: 'Active',
      createdAt: DateTime(2026, 5, 18, 9, 0),
      lastActive: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    AdminUserModel(
      id: 'usr_105',
      name: 'Sameer Joshi',
      email: 'sameer.j@example.com',
      phone: '+91 96543 21098',
      linkedIn: 'https://linkedin.com/in/sameerjoshi',
      github: 'https://github.com/sameerj',
      portfolio: null,
      resumesCount: 2,
      status: 'Active',
      createdAt: DateTime(2026, 5, 2, 11, 45),
      lastActive: DateTime.now().subtract(const Duration(days: 1)),
    ),
    AdminUserModel(
      id: 'usr_106',
      name: 'Kavita Menon',
      email: 'kavita.m@example.com',
      phone: '+91 94321 09876',
      linkedIn: 'https://linkedin.com/in/kavitamenon',
      github: null,
      portfolio: null,
      resumesCount: 1,
      status: 'Suspended',
      createdAt: DateTime(2026, 4, 15, 13, 0),
      lastActive: DateTime.now().subtract(const Duration(days: 14)),
    ),
  ];

  AdminUserRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<AdminUserModel>> getUsers() async {
    try {
      final res = await apiClient.get(ApiConstants.users);
      if (res.data != null && res.data['data'] != null) {
        final list = res.data['data'] as List;
        return list
            .map((e) => AdminUserModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return _mockUsers;
    } catch (_) {
      // Return realistic mock users
      return List.from(_mockUsers);
    }
  }

  @override
  Future<AdminUserModel> getUserById(String id) async {
    try {
      final res = await apiClient.get(ApiConstants.userDetails(id));
      if (res.data != null && res.data['data'] != null) {
        return AdminUserModel.fromJson(
          res.data['data'] as Map<String, dynamic>,
        );
      }
      return _mockUsers.firstWhere((u) => u.id == id);
    } catch (_) {
      return _mockUsers.firstWhere(
        (u) => u.id == id,
        orElse: () => _mockUsers.first,
      );
    }
  }

  @override
  Future<void> updateUserStatus(String id, String status) async {
    try {
      await apiClient.put(
        ApiConstants.userStatus(id),
        data: {'status': status},
      );
    } catch (_) {
      final index = _mockUsers.indexWhere((u) => u.id == id);
      if (index != -1) {
        final user = _mockUsers[index];
        _mockUsers[index] = AdminUserModel(
          id: user.id,
          name: user.name,
          email: user.email,
          phone: user.phone,
          linkedIn: user.linkedIn,
          github: user.github,
          portfolio: user.portfolio,
          resumesCount: user.resumesCount,
          status: status,
          createdAt: user.createdAt,
          lastActive: user.lastActive,
        );
      }
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      await apiClient.delete(ApiConstants.userDetails(id));
    } catch (_) {
      _mockUsers.removeWhere((u) => u.id == id);
    }
  }
}
