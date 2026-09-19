import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/features/user/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_userside/features/user/profile/domain/entities/profile.dart';
import 'package:frontend_userside/features/user/resume/data/datasources/resume_remote_datasource.dart';
import 'package:frontend_userside/features/user/resume/data/repositories/resume_repository_impl.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/achievement.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/certification.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/education.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/experience.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/language.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/project.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/resume.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/skill.dart';
import 'package:frontend_userside/features/user/resume/domain/repositories/resume_repository.dart';

final resumeRemoteDataSourceProvider = Provider<ResumeRemoteDataSource>((ref) {
  return ResumeRemoteDataSourceImpl(dioClient: ref.watch(dioClientProvider));
});

final resumeRepositoryProvider = Provider<ResumeRepository>((ref) {
  return ResumeRepositoryImpl(
    remoteDataSource: ref.watch(resumeRemoteDataSourceProvider),
  );
});

// Resumes List State
class ResumesListState {
  final List<Resume> resumes;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String statusFilter; // 'all', 'draft', 'completed'
  final String sortBy; // 'recent', 'name', 'score'

  const ResumesListState({
    this.resumes = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.statusFilter = 'all',
    this.sortBy = 'recent',
  });

  List<Resume> get filteredResumes {
    var list = resumes.where((r) {
      final matchesSearch =
          r.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          r.personalInfo.fullName.toLowerCase().contains(
            searchQuery.toLowerCase(),
          );
      final matchesStatus =
          statusFilter == 'all' ||
          (statusFilter == 'draft' && r.status == ResumeStatus.draft) ||
          (statusFilter == 'completed' && r.status == ResumeStatus.completed);
      return matchesSearch && matchesStatus;
    }).toList();

    if (sortBy == 'name') {
      list.sort(
        (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      );
    } else if (sortBy == 'score') {
      list.sort((a, b) => b.atsScore.compareTo(a.atsScore));
    } else {
      list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }

    return list;
  }

  ResumesListState copyWith({
    List<Resume>? resumes,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? statusFilter,
    String? sortBy,
  }) {
    return ResumesListState(
      resumes: resumes ?? this.resumes,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

class ResumesListNotifier extends StateNotifier<ResumesListState> {
  final ResumeRepository _repository;

  ResumesListNotifier(this._repository) : super(const ResumesListState()) {
    loadResumes();
  }

  Future<void> loadResumes() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final list = await _repository.getResumes();
      state = state.copyWith(resumes: list, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load resumes');
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setStatusFilter(String filter) {
    state = state.copyWith(statusFilter: filter);
  }

  void setSortBy(String sort) {
    state = state.copyWith(sortBy: sort);
  }

  Future<Resume?> createResume(String title, {String? templateId}) async {
    try {
      final newResume = await _repository.createResume(
        title: title,
        templateId: templateId,
      );
      state = state.copyWith(resumes: [newResume, ...state.resumes]);
      return newResume;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteResume(String id) async {
    try {
      await _repository.deleteResume(id);
      state = state.copyWith(
        resumes: state.resumes.where((r) => r.id != id).toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Resume?> duplicateResume(String id) async {
    try {
      final dup = await _repository.duplicateResume(id);
      state = state.copyWith(resumes: [dup, ...state.resumes]);
      return dup;
    } catch (e) {
      return null;
    }
  }

  Future<bool> renameResume(String id, String newTitle) async {
    try {
      final updated = await _repository.renameResume(id, newTitle);
      state = state.copyWith(
        resumes: state.resumes.map((r) => r.id == id ? updated : r).toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}

final resumesListProvider =
    StateNotifierProvider<ResumesListNotifier, ResumesListState>((ref) {
      return ResumesListNotifier(ref.watch(resumeRepositoryProvider));
    });

// Active Resume in Builder State
class ActiveResumeNotifier extends StateNotifier<Resume?> {
  final ResumeRepository _repository;

  ActiveResumeNotifier(this._repository) : super(null);

  Future<void> loadResume(String id) async {
    try {
      final resume = await _repository.getResumeById(id);
      state = resume;
    } catch (_) {}
  }

  void setResume(Resume resume) {
    state = resume;
  }

  void updatePersonalInfo(Profile profile) {
    if (state == null) return;
    state = state!.copyWith(personalInfo: profile);
  }

  void updateSummary(String summary) {
    if (state == null) return;
    state = state!.copyWith(summary: summary);
  }

  void updateEducations(List<Education> educations) {
    if (state == null) return;
    state = state!.copyWith(educations: educations);
  }

  void updateSkills(List<Skill> skills) {
    if (state == null) return;
    state = state!.copyWith(skills: skills);
  }

  void updateExperiences(List<Experience> experiences) {
    if (state == null) return;
    state = state!.copyWith(experiences: experiences);
  }

  void updateProjects(List<Project> projects) {
    if (state == null) return;
    state = state!.copyWith(projects: projects);
  }

  void updateCertifications(List<Certification> certifications) {
    if (state == null) return;
    state = state!.copyWith(certifications: certifications);
  }

  void updateAchievements(List<Achievement> achievements) {
    if (state == null) return;
    state = state!.copyWith(achievements: achievements);
  }

  void updateLanguages(List<Language> languages) {
    if (state == null) return;
    state = state!.copyWith(languages: languages);
  }

  void setTemplateId(String templateId) {
    if (state == null) return;
    state = state!.copyWith(templateId: templateId);
  }

  Future<void> saveActiveResume() async {
    if (state != null) {
      await _repository.updateResume(state!);
    }
  }
}

final activeResumeProvider =
    StateNotifierProvider<ActiveResumeNotifier, Resume?>((ref) {
      return ActiveResumeNotifier(ref.watch(resumeRepositoryProvider));
    });
