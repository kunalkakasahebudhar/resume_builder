import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/experience.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';

final experienceProvider = Provider<List<Experience>>((ref) {
  final resume = ref.watch(activeResumeProvider);
  return resume?.experiences ?? [];
});
