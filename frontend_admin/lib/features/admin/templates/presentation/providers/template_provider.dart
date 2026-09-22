import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_admin/features/admin/auth/presentation/providers/admin_auth_provider.dart';
import 'package:frontend_admin/features/admin/templates/data/datasources/template_remote_datasource.dart';
import 'package:frontend_admin/features/admin/templates/data/repositories/template_repository_impl.dart';
import 'package:frontend_admin/features/admin/templates/domain/entities/template.dart';
import 'package:frontend_admin/features/admin/templates/domain/repositories/template_repository.dart';

final templateRemoteDataSourceProvider = Provider<TemplateRemoteDataSource>((
  ref,
) {
  final client = ref.watch(apiClientProvider);
  return TemplateRemoteDataSourceImpl(apiClient: client);
});

final templateRepositoryProvider = Provider<TemplateRepository>((ref) {
  final remote = ref.watch(templateRemoteDataSourceProvider);
  return TemplateRepositoryImpl(remoteDataSource: remote);
});

class TemplatesState {
  final bool isLoading;
  final List<Template> templates;
  final String? errorMessage;
  final Template? selectedTemplate;
  final bool isActionLoading;

  const TemplatesState({
    this.isLoading = false,
    this.templates = const [],
    this.errorMessage,
    this.selectedTemplate,
    this.isActionLoading = false,
  });

  TemplatesState copyWith({
    bool? isLoading,
    List<Template>? templates,
    String? errorMessage,
    Template? selectedTemplate,
    bool? isActionLoading,
  }) {
    return TemplatesState(
      isLoading: isLoading ?? this.isLoading,
      templates: templates ?? this.templates,
      errorMessage: errorMessage,
      selectedTemplate: selectedTemplate ?? this.selectedTemplate,
      isActionLoading: isActionLoading ?? this.isActionLoading,
    );
  }
}

class TemplatesNotifier extends StateNotifier<TemplatesState> {
  final TemplateRepository _repository;

  TemplatesNotifier(this._repository) : super(const TemplatesState()) {
    loadTemplates();
  }

  Future<void> loadTemplates() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final list = await _repository.getTemplates();
      state = state.copyWith(isLoading: false, templates: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> loadTemplateById(String id) async {
    state = state.copyWith(isActionLoading: true);
    try {
      final tpl = await _repository.getTemplateById(id);
      state = state.copyWith(selectedTemplate: tpl, isActionLoading: false);
    } catch (e) {
      state = state.copyWith(
        isActionLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> saveTemplate(Template template, {bool isEdit = false}) async {
    state = state.copyWith(isActionLoading: true);
    try {
      if (isEdit) {
        await _repository.updateTemplate(template);
      } else {
        await _repository.createTemplate(template);
      }
      await loadTemplates();
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

  Future<bool> updateStatus(String id, String status) async {
    try {
      await _repository.updateTemplateStatus(id, status);
      await loadTemplates();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deleteTemplate(String id) async {
    try {
      await _repository.deleteTemplate(id);
      await loadTemplates();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }
}

final templatesProvider =
    StateNotifierProvider<TemplatesNotifier, TemplatesState>((ref) {
      final repo = ref.watch(templateRepositoryProvider);
      return TemplatesNotifier(repo);
    });
