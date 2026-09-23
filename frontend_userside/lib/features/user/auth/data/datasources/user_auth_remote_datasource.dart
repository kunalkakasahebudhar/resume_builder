import 'package:frontend_userside/config/backend_config.dart';
import 'package:frontend_userside/core/error/exceptions.dart';
import 'package:frontend_userside/core/network/dio_client.dart';
import 'package:frontend_userside/features/user/auth/data/models/user_model.dart';

abstract class UserAuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<void> forgotPassword(String email);
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });
}

class UserAuthRemoteDataSourceImpl implements UserAuthRemoteDataSource {
  final DioClient dioClient;

  UserAuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dioClient.post(
        BackendConfig.login,
        data: {'email': email, 'password': password},
      );
      final data = response.data as Map<String, dynamic>;
      return data['data'] as Map<String, dynamic>;
    } on ServerException catch (e) {
      throw AuthException(message: e.message);
    }
  }

  @override
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.post(
        BackendConfig.register,
        data: {'full_name': fullName, 'email': email, 'password': password},
      );
      final data = response.data as Map<String, dynamic>;
      return data['data'] as Map<String, dynamic>;
    } on ServerException catch (e) {
      throw AuthException(message: e.message);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dioClient.post(BackendConfig.logout);
    } catch (_) {}
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await dioClient.post(
        BackendConfig.forgotPassword,
        data: {'email': email},
      );
    } on ServerException catch (e) {
      throw AuthException(message: e.message);
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await dioClient.post(
        BackendConfig.resetPassword,
        data: {'token': token, 'new_password': newPassword},
      );
    } on ServerException catch (e) {
      throw AuthException(message: e.message);
    }
  }
}
