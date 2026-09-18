import 'package:frontend_admin/core/storage/local_storage.dart';
import 'package:frontend_admin/features/admin/auth/domain/entities/admin.dart';
import 'package:frontend_admin/features/admin/auth/domain/repositories/admin_auth_repository.dart';
import 'package:frontend_admin/features/admin/auth/data/datasources/admin_auth_remote_datasource.dart';
import 'package:frontend_admin/features/admin/auth/data/models/admin_model.dart';

class AdminAuthRepositoryImpl implements AdminAuthRepository {
  final AdminAuthRemoteDataSource remoteDataSource;
  final LocalStorage localStorage;

  AdminAuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localStorage,
  });

  @override
  Future<Admin> login(
    String email,
    String password, {
    bool rememberMe = false,
  }) async {
    final adminModel = await remoteDataSource.login(email, password);
    await localStorage.saveToken('rf_mock_token_adm_001');
    await localStorage.saveAdminData(adminModel.toJsonString());
    await localStorage.saveRememberMe(rememberMe);
    return adminModel;
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
    await localStorage.clearAuth();
  }

  @override
  Future<Admin?> getCurrentAdmin() async {
    final data = await localStorage.getAdminData();
    if (data != null && data.isNotEmpty) {
      try {
        return AdminModel.fromJsonString(data);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await localStorage.getToken();
    return token != null && token.isNotEmpty;
  }
}
