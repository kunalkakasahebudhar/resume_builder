import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/achievement.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';

final achievementsProvider = Provider<List<Achievement>>((ref) {
  final resume = ref.watch(activeResumeProvider);
  return resume?.achievements ?? [];
});
