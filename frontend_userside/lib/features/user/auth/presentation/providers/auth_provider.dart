import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/error/failures.dart';
import 'package:frontend_userside/core/network/dio_client.dart';
import 'package:frontend_userside/core/storage/local_storage.dart';
import 'package:frontend_userside/features/user/auth/data/datasources/user_auth_remote_datasource.dart';
import 'package:frontend_userside/features/user/auth/data/repositories/user_auth_repository_impl.dart';
import 'package:frontend_userside/features/user/auth/domain/entities/user.dart';
import 'package:frontend_userside/features/user/auth/domain/repositories/user_auth_repository.dart';
import 'package:frontend_userside/features/user/auth/domain/usecases/forgot_password.dart';
import 'package:frontend_userside/features/user/auth/domain/usecases/login.dart';
import 'package:frontend_userside/features/user/auth/domain/usecases/logout.dart';
import 'package:frontend_userside/features/user/auth/domain/usecases/register.dart';
import 'package:frontend_userside/features/user/auth/domain/usecases/reset_password.dart';

// Storage & Client Providers
final localStorageProvider = Provider<LocalStorage>((ref) => LocalStorage());
final dioClientProvider = Provider<DioClient>(
  (ref) => DioClient(localStorage: ref.watch(localStorageProvider)),
);

// Auth Dependency Providers
final userAuthRemoteDataSourceProvider = Provider<UserAuthRemoteDataSource>((ref) {
  return UserAuthRemoteDataSourceImpl(dioClient: ref.watch(dioClientProvider));
});

final userAuthRepositoryProvider = Provider<UserAuthRepository>((ref) {
  return UserAuthRepositoryImpl(
    remoteDataSource: ref.watch(userAuthRemoteDataSourceProvider),
    localStorage: ref.watch(localStorageProvider),
  );
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(userAuthRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.watch(userAuthRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(userAuthRepositoryProvider));
});

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>((ref) {
  return ForgotPasswordUseCase(ref.watch(userAuthRepositoryProvider));
});

final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  return ResetPasswordUseCase(ref.watch(userAuthRepositoryProvider));
});

// Auth State
class AuthState {
  final User? user;
  final bool isLoading;
  final bool isInitialized;
  final String? errorMessage;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.isInitialized = false,
    this.errorMessage,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    User? user,
    bool? isLoading,
    bool? isInitialized,
    String? errorMessage,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final UserAuthRepository _repository;
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  AuthNotifier({
    required UserAuthRepository repository,
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
  }) : _repository = repository,
       _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       _forgotPasswordUseCase = forgotPasswordUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       super(const AuthState()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      final user = await _repository.getCurrentUser();
      state = state.copyWith(user: user, isInitialized: true);
    } catch (_) {
      state = state.copyWith(isInitialized: true, clearUser: true);
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _loginUseCase(email, password);
      state = state.copyWith(user: user, isLoading: false, clearError: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is Failure ? e.message : e.toString(),
      );
      return false;
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _registerUseCase(
        fullName: fullName,
        email: email,
        password: password,
      );
      state = state.copyWith(user: user, isLoading: false, clearError: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is Failure ? e.message : e.toString(),
      );
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await _logoutUseCase();
    } finally {
      state = const AuthState(isInitialized: true);
    }
  }

  Future<bool> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _forgotPasswordUseCase(email);
      state = state.copyWith(isLoading: false, clearError: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is Failure ? e.message : e.toString(),
      );
      return false;
    }
  }

  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _resetPasswordUseCase(email: email, otp: otp, newPassword: newPassword);
      state = state.copyWith(isLoading: false, clearError: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is Failure ? e.message : e.toString(),
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    repository: ref.watch(userAuthRepositoryProvider),
    loginUseCase: ref.watch(loginUseCaseProvider),
    registerUseCase: ref.watch(registerUseCaseProvider),
    logoutUseCase: ref.watch(logoutUseCaseProvider),
    forgotPasswordUseCase: ref.watch(forgotPasswordUseCaseProvider),
    resetPasswordUseCase: ref.watch(resetPasswordUseCaseProvider),
  );
});
