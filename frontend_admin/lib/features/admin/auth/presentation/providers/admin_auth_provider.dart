import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_admin/core/network/api_client.dart';
import 'package:frontend_admin/core/network/network_exception.dart';
import 'package:frontend_admin/core/storage/local_storage.dart';
import 'package:frontend_admin/features/admin/auth/data/datasources/admin_auth_remote_datasource.dart';
import 'package:frontend_admin/features/admin/auth/data/repositories/admin_auth_repository_impl.dart';
import 'package:frontend_admin/features/admin/auth/domain/entities/admin.dart';
import 'package:frontend_admin/features/admin/auth/domain/repositories/admin_auth_repository.dart';
import 'package:frontend_admin/features/admin/auth/domain/usecases/admin_login.dart';
import 'package:frontend_admin/features/admin/auth/domain/usecases/admin_logout.dart';

// Providers for dependencies
final localStorageProvider = Provider<LocalStorage>((ref) => LocalStorage());

final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.watch(localStorageProvider);
  return ApiClient(localStorage: storage);
});

final adminAuthRemoteDataSourceProvider = Provider<AdminAuthRemoteDataSource>((
  ref,
) {
  final client = ref.watch(apiClientProvider);
  return AdminAuthRemoteDataSourceImpl(apiClient: client);
});

final adminAuthRepositoryProvider = Provider<AdminAuthRepository>((ref) {
  final remoteDataSource = ref.watch(adminAuthRemoteDataSourceProvider);
  final localStorage = ref.watch(localStorageProvider);
  return AdminAuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localStorage: localStorage,
  );
});

final adminLoginUseCaseProvider = Provider<AdminLogin>((ref) {
  final repo = ref.watch(adminAuthRepositoryProvider);
  return AdminLogin(repo);
});

final adminLogoutUseCaseProvider = Provider<AdminLogout>((ref) {
  final repo = ref.watch(adminAuthRepositoryProvider);
  return AdminLogout(repo);
});

// Auth State
class AdminAuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final Admin? admin;
  final String? errorMessage;
  final bool isInitialized;

  const AdminAuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.admin,
    this.errorMessage,
    this.isInitialized = false,
  });

  AdminAuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    Admin? admin,
    String? errorMessage,
    bool? isInitialized,
  }) {
    return AdminAuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      admin: admin ?? this.admin,
      errorMessage: errorMessage,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

class AdminAuthNotifier extends StateNotifier<AdminAuthState> {
  final AdminLogin _loginUseCase;
  final AdminLogout _logoutUseCase;
  final AdminAuthRepository _repository;

  AdminAuthNotifier({
    required AdminLogin loginUseCase,
    required AdminLogout logoutUseCase,
    required AdminAuthRepository repository,
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       _repository = repository,
       super(const AdminAuthState()) {
    checkInitialAuth();
  }

  Future<void> checkInitialAuth() async {
    state = state.copyWith(isLoading: true);
    final isAuth = await _repository.isAuthenticated();
    if (isAuth) {
      final admin = await _repository.getCurrentAdmin();
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        admin: admin,
        isInitialized: true,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        admin: null,
        isInitialized: true,
      );
    }
  }

  Future<bool> login(
    String email,
    String password, {
    bool rememberMe = false,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final admin = await _loginUseCase(
        email,
        password,
        rememberMe: rememberMe,
      );
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        admin: admin,
        errorMessage: null,
      );
      return true;
    } on NetworkException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _logoutUseCase();
    state = const AdminAuthState(isInitialized: true);
  }
}

final adminAuthProvider =
    StateNotifierProvider<AdminAuthNotifier, AdminAuthState>((ref) {
      final loginUseCase = ref.watch(adminLoginUseCaseProvider);
      final logoutUseCase = ref.watch(adminLogoutUseCaseProvider);
      final repository = ref.watch(adminAuthRepositoryProvider);

      return AdminAuthNotifier(
        loginUseCase: loginUseCase,
        logoutUseCase: logoutUseCase,
        repository: repository,
      );
    });
