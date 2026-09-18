import 'package:frontend_admin/core/constants/api_constants.dart';
import 'package:frontend_admin/core/network/api_client.dart';
import 'package:frontend_admin/core/network/network_exception.dart';
import 'package:frontend_admin/features/admin/auth/data/models/admin_model.dart';

abstract class AdminAuthRemoteDataSource {
  Future<AdminModel> login(String email, String password);
  Future<void> logout();
}

class AdminAuthRemoteDataSourceImpl implements AdminAuthRemoteDataSource {
  final ApiClient apiClient;

  AdminAuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AdminModel> login(String email, String password) async {
    try {
      // Prepared for future Go + Gin REST API:
      final response = await apiClient.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      if (response.data != null && response.data['data'] != null) {
        return AdminModel.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
      }
      throw NetworkException(message: 'Invalid response from server');
    } catch (_) {
      // Mock Fallback for local frontend development
      if (email.trim() == 'admin@resumeforge.com' && password == 'Admin@123') {
        await Future.delayed(
          const Duration(milliseconds: 600),
        ); // Simulate network latency
        return AdminModel(
          id: 'adm_001',
          name: 'Alex Vance',
          email: 'admin@resumeforge.com',
          role: 'Super Admin',
          phone: '+1 (555) 019-2834',
          avatarUrl:
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
          createdAt: DateTime(2025, 1, 15),
        );
      } else {
        throw NetworkException(
          message:
              'Invalid email or password. Use admin@resumeforge.com / Admin@123',
        );
      }
    }
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.post(ApiConstants.logout);
    } catch (_) {
      // Fallback silently for mock
    }
  }
}
