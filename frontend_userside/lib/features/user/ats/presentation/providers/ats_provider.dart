import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/features/user/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_userside/features/user/ats/data/datasources/ats_remote_datasource.dart';
import 'package:frontend_userside/features/user/ats/data/repositories/ats_repository_impl.dart';
import 'package:frontend_userside/features/user/ats/domain/entities/ats_analysis.dart';
import 'package:frontend_userside/features/user/ats/domain/repositories/ats_repository.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';

final atsRemoteDataSourceProvider = Provider<AtsRemoteDataSource>((ref) {
  return AtsRemoteDataSourceImpl(dioClient: ref.watch(dioClientProvider));
});

final atsRepositoryProvider = Provider<AtsRepository>((ref) {
  return AtsRepositoryImpl(
    remoteDataSource: ref.watch(atsRemoteDataSourceProvider),
  );
});

class AtsState {
  final AtsAnalysis? analysis;
  final bool isAnalyzing;
  final String? error;

  const AtsState({this.analysis, this.isAnalyzing = false, this.error});

  AtsState copyWith({AtsAnalysis? analysis, bool? isAnalyzing, String? error}) {
    return AtsState(
      analysis: analysis ?? this.analysis,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      error: error,
    );
  }
}

class AtsNotifier extends StateNotifier<AtsState> {
  final AtsRepository _repository;

  AtsNotifier(this._repository) : super(const AtsState());

  Future<void> runAnalysis(String resumeId) async {
    state = state.copyWith(isAnalyzing: true, error: null);
    try {
      final result = await _repository.analyzeResume(resumeId);
      state = state.copyWith(analysis: result, isAnalyzing: false);
    } catch (e) {
      state = state.copyWith(
        isAnalyzing: false,
        error: 'Failed to analyze resume',
      );
    }
  }
}

final atsProvider = StateNotifierProvider<AtsNotifier, AtsState>((ref) {
  final notifier = AtsNotifier(ref.watch(atsRepositoryProvider));
  final activeResume = ref.watch(activeResumeProvider);
  if (activeResume != null) {
    notifier.runAnalysis(activeResume.id);
  }
  return notifier;
});
