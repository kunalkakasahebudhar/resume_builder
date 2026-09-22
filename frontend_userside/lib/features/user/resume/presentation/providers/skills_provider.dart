import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/skill.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';

final skillsProvider = Provider<List<Skill>>((ref) {
  final resume = ref.watch(activeResumeProvider);
  return resume?.skills ?? [];
});
