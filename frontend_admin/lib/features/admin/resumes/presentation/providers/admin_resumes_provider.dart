import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_admin/features/admin/auth/presentation/providers/admin_auth_provider.dart';
import 'package:frontend_admin/features/admin/resumes/data/datasources/admin_resume_remote_datasource.dart';
import 'package:frontend_admin/features/admin/resumes/data/repositories/admin_resume_repository_impl.dart';
import 'package:frontend_admin/features/admin/resumes/domain/entities/admin_resume.dart';
import 'package:frontend_admin/features/admin/resumes/domain/repositories/admin_resume_repository.dart';

final adminResumeRemoteDataSourceProvider =
    Provider<AdminResumeRemoteDataSource>((ref) {
      final client = ref.watch(apiClientProvider);
      return AdminResumeRemoteDataSourceImpl(apiClient: client);
    });

final adminResumeRepositoryProvider = Provider<AdminResumeRepository>((ref) {
  final remote = ref.watch(adminResumeRemoteDataSourceProvider);
  return AdminResumeRepositoryImpl(remoteDataSource: remote);
});

class AdminResumesState {
  final bool isLoading;
  final List<AdminResume> resumes;
  final String? errorMessage;
  final String searchQuery;
  final String selectedTemplate;
  final String selectedScoreTier;

  const AdminResumesState({
    this.isLoading = false,
    this.resumes = const [],
    this.errorMessage,
    this.searchQuery = '',
    this.selectedTemplate = 'All',
    this.selectedScoreTier = 'All',
  });

  AdminResumesState copyWith({
    bool? isLoading,
    List<AdminResume>? resumes,
    String? errorMessage,
    String? searchQuery,
    String? selectedTemplate,
    String? selectedScoreTier,
  }) {
    return AdminResumesState(
      isLoading: isLoading ?? this.isLoading,
      resumes: resumes ?? this.resumes,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTemplate: selectedTemplate ?? this.selectedTemplate,
      selectedScoreTier: selectedScoreTier ?? this.selectedScoreTier,
    );
  }
}

class AdminResumesNotifier extends StateNotifier<AdminResumesState> {
  final AdminResumeRepository _repository;

  AdminResumesNotifier(this._repository) : super(const AdminResumesState()) {
    loadResumes();
  }

  Future<void> loadResumes() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final list = await _repository.getResumes(
        search: state.searchQuery,
        template: state.selectedTemplate,
        scoreTier: state.selectedScoreTier,
      );
      state = state.copyWith(isLoading: false, resumes: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    loadResumes();
  }

  void setTemplateFilter(String template) {
    state = state.copyWith(selectedTemplate: template);
    loadResumes();
  }

  void setScoreTierFilter(String tier) {
    state = state.copyWith(selectedScoreTier: tier);
    loadResumes();
  }

  Future<bool> deleteResume(String id) async {
    try {
      await _repository.deleteResume(id);
      await loadResumes();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }
}

final adminResumesProvider =
    StateNotifierProvider<AdminResumesNotifier, AdminResumesState>((ref) {
      final repo = ref.watch(adminResumeRepositoryProvider);
      return AdminResumesNotifier(repo);
    });
