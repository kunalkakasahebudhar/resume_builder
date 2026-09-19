import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/project.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';

final projectsProvider = Provider<List<Project>>((ref) {
  final resume = ref.watch(activeResumeProvider);
  return resume?.projects ?? [];
});
