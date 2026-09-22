import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_admin/features/admin/auth/presentation/providers/admin_auth_provider.dart';
import 'package:frontend_admin/features/admin/users/data/datasources/admin_user_remote_datasource.dart';
import 'package:frontend_admin/features/admin/users/data/repositories/admin_user_repository_impl.dart';
import 'package:frontend_admin/features/admin/users/domain/entities/admin_user.dart';
import 'package:frontend_admin/features/admin/users/domain/repositories/admin_user_repository.dart';

final adminUserRemoteDataSourceProvider = Provider<AdminUserRemoteDataSource>((
  ref,
) {
  final client = ref.watch(apiClientProvider);
  return AdminUserRemoteDataSourceImpl(apiClient: client);
});

final adminUserRepositoryProvider = Provider<AdminUserRepository>((ref) {
  final remoteDataSource = ref.watch(adminUserRemoteDataSourceProvider);
  return AdminUserRepositoryImpl(remoteDataSource: remoteDataSource);
});

class AdminUsersState {
  final bool isLoading;
  final List<AdminUser> users;
  final String? errorMessage;
  final String searchQuery;
  final String statusFilter;
  final AdminUser? selectedUser;
  final bool isActionLoading;

  const AdminUsersState({
    this.isLoading = false,
    this.users = const [],
    this.errorMessage,
    this.searchQuery = '',
    this.statusFilter = 'All',
    this.selectedUser,
    this.isActionLoading = false,
  });

  AdminUsersState copyWith({
    bool? isLoading,
    List<AdminUser>? users,
    String? errorMessage,
    String? searchQuery,
    String? statusFilter,
    AdminUser? selectedUser,
    bool? isActionLoading,
  }) {
    return AdminUsersState(
      isLoading: isLoading ?? this.isLoading,
      users: users ?? this.users,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      selectedUser: selectedUser ?? this.selectedUser,
      isActionLoading: isActionLoading ?? this.isActionLoading,
    );
  }
}

class AdminUsersNotifier extends StateNotifier<AdminUsersState> {
  final AdminUserRepository _repository;

  AdminUsersNotifier(this._repository) : super(const AdminUsersState()) {
    loadUsers();
  }

  Future<void> loadUsers() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final users = await _repository.getUsers(
        search: state.searchQuery,
        status: state.statusFilter,
      );
      state = state.copyWith(isLoading: false, users: users);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    loadUsers();
  }

  void setStatusFilter(String filter) {
    state = state.copyWith(statusFilter: filter);
    loadUsers();
  }

  Future<void> loadUserDetails(String id) async {
    state = state.copyWith(isActionLoading: true);
    try {
      final user = await _repository.getUserById(id);
      state = state.copyWith(selectedUser: user, isActionLoading: false);
    } catch (e) {
      state = state.copyWith(
        isActionLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> updateUserStatus(String id, String newStatus) async {
    state = state.copyWith(isActionLoading: true);
    try {
      await _repository.updateUserStatus(id, newStatus);
      if (state.selectedUser?.id == id) {
        state = state.copyWith(
          selectedUser: state.selectedUser?.copyWith(status: newStatus),
        );
      }
      await loadUsers();
      state = state.copyWith(isActionLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isActionLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> deleteUser(String id) async {
    state = state.copyWith(isActionLoading: true);
    try {
      await _repository.deleteUser(id);
      await loadUsers();
      state = state.copyWith(isActionLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isActionLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}

final adminUsersProvider =
    StateNotifierProvider<AdminUsersNotifier, AdminUsersState>((ref) {
      final repo = ref.watch(adminUserRepositoryProvider);
      return AdminUsersNotifier(repo);
    });
