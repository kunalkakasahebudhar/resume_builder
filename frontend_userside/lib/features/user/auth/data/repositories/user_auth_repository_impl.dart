import 'package:frontend_userside/core/error/exceptions.dart';
import 'package:frontend_userside/core/error/failures.dart';
import 'package:frontend_userside/core/storage/local_storage.dart';
import 'package:frontend_userside/features/user/auth/data/datasources/user_auth_remote_datasource.dart';
import 'package:frontend_userside/features/user/auth/data/models/user_model.dart';
import 'package:frontend_userside/features/user/auth/domain/entities/user.dart';
import 'package:frontend_userside/features/user/auth/domain/repositories/user_auth_repository.dart';

class UserAuthRepositoryImpl implements UserAuthRepository {
  final UserAuthRemoteDataSource remoteDataSource;
  final LocalStorage localStorage;

  UserAuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localStorage,
  });

  Future<User> _handleAuthResponse(Map<String, dynamic> data) async {
    final token = data['access_token'] as String? ?? '';
    final userMap = data['user'] as Map<String, dynamic>? ?? {};
    final userModel = UserModel.fromJson({
      'id': userMap['id']?.toString() ?? '',
      'email': userMap['email'],
      'full_name': userMap['full_name'],
      'created_at': userMap['created_at'],
    });
    await localStorage.saveToken(token);
    await localStorage.saveUserData(userModel.toJsonString());
    return userModel;
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final data = await remoteDataSource.login(email, password);
      return await _handleAuthResponse(data);
    } on AuthException catch (e) {
      throw AuthFailure(message: e.message);
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }

  @override
  Future<User> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final data = await remoteDataSource.register(
        fullName: fullName,
        email: email,
        password: password,
      );
      return await _handleAuthResponse(data);
    } on AuthException catch (e) {
      throw AuthFailure(message: e.message);
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } finally {
      await localStorage.clearAuth();
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await remoteDataSource.forgotPassword(email);
    } on AuthException catch (e) {
      throw AuthFailure(message: e.message);
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.resetPassword(email: email, otp: otp, newPassword: newPassword);
    } on AuthException catch (e) {
      throw AuthFailure(message: e.message);
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final userJson = await localStorage.getUserData();
      final token = await localStorage.getToken();
      if (userJson != null && token != null && token.isNotEmpty) {
        return UserModel.fromJsonString(userJson);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
