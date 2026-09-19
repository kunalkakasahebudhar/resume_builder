import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/features/user/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_userside/features/user/templates/data/datasources/template_remote_datasource.dart';
import 'package:frontend_userside/features/user/templates/data/repositories/template_repository_impl.dart';
import 'package:frontend_userside/features/user/templates/domain/entities/resume_template.dart';
import 'package:frontend_userside/features/user/templates/domain/repositories/template_repository.dart';

final templateRemoteDataSourceProvider = Provider<TemplateRemoteDataSource>((
  ref,
) {
  return TemplateRemoteDataSourceImpl(dioClient: ref.watch(dioClientProvider));
});

final templateRepositoryProvider = Provider<TemplateRepository>((ref) {
  return TemplateRepositoryImpl(
    remoteDataSource: ref.watch(templateRemoteDataSourceProvider),
  );
});

class TemplatesState {
  final List<ResumeTemplate> templates;
  final bool isLoading;
  final String? error;
  final String selectedCategory; // 'All', 'ATS Classic', etc.

  const TemplatesState({
    this.templates = const [],
    this.isLoading = false,
    this.error,
    this.selectedCategory = 'All',
  });

  List<ResumeTemplate> get filteredTemplates {
    if (selectedCategory == 'All') return templates;
    return templates.where((t) => t.category == selectedCategory).toList();
  }

  TemplatesState copyWith({
    List<ResumeTemplate>? templates,
    bool? isLoading,
    String? error,
    String? selectedCategory,
  }) {
    return TemplatesState(
      templates: templates ?? this.templates,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class TemplatesNotifier extends StateNotifier<TemplatesState> {
  final TemplateRepository _repository;

  TemplatesNotifier(this._repository) : super(const TemplatesState()) {
    loadTemplates();
  }

  Future<void> loadTemplates() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final templates = await _repository.getTemplates();
      state = state.copyWith(templates: templates, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load templates',
      );
    }
  }

  void setSelectedCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }
}

final templatesProvider =
    StateNotifierProvider<TemplatesNotifier, TemplatesState>((ref) {
      return TemplatesNotifier(ref.watch(templateRepositoryProvider));
    });
