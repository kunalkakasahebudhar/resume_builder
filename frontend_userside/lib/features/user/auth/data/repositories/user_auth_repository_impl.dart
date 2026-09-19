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

  @override
  Future<User> login(String email, String password) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      await localStorage.saveToken('mock_jwt_token_${userModel.id}');
      await localStorage.saveUserData(userModel.toJsonString());
      return userModel;
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
      final userModel = await remoteDataSource.register(
        fullName: fullName,
        email: email,
        password: password,
      );
      await localStorage.saveToken('mock_jwt_token_${userModel.id}');
      await localStorage.saveUserData(userModel.toJsonString());
      return userModel;
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
      await localStorage.clearAuth();
    } catch (e) {
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
    required String token,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.resetPassword(
        token: token,
        newPassword: newPassword,
      );
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
    } catch (e) {
      return null;
    }
  }
}
