import 'package:frontend_userside/core/error/exceptions.dart';
import 'package:frontend_userside/core/network/dio_client.dart';
import 'package:frontend_userside/features/user/auth/data/models/user_model.dart';

abstract class UserAuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register({
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
  final DioClient? dioClient;

  UserAuthRemoteDataSourceImpl({this.dioClient});

  // Mock User Data for Phase 1
  static const String demoEmail = 'user@resumeforge.com';
  static const String demoPassword = 'User@123';

  @override
  Future<UserModel> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    final normalizedEmail = email.trim().toLowerCase();

    // Accept demo credentials or any validly formatted test input for seamless development
    if (normalizedEmail == demoEmail.toLowerCase()) {
      if (password == demoPassword) {
        return UserModel(
          id: 'usr_01HXYZ789',
          email: demoEmail,
          fullName: 'Alex Morgan',
          avatarUrl: null,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        );
      } else {
        throw const AuthException(
          message: 'Invalid password. Hint: $demoPassword',
        );
      }
    } else if (password.length >= 6) {
      // Allow flexible test logins
      return UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        email: normalizedEmail,
        fullName: normalizedEmail.split('@').first,
        avatarUrl: null,
        createdAt: DateTime.now(),
      );
    } else {
      throw const AuthException(message: 'Invalid email or password.');
    }
  }

  @override
  Future<UserModel> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (email.trim().isEmpty || password.length < 6) {
      throw const AuthException(message: 'Invalid registration details');
    }

    return UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      email: email.trim(),
      fullName: fullName.trim(),
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<void> forgotPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (email.trim().isEmpty) {
      throw const AuthException(message: 'Please enter a valid email');
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (newPassword.length < 6) {
      throw const AuthException(
        message: 'Password must be at least 6 characters',
      );
    }
  }
}
