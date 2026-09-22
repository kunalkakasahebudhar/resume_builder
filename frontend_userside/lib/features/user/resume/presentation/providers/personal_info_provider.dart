import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/features/user/profile/domain/entities/profile.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';

final personalInfoProvider = Provider<Profile?>((ref) {
  final resume = ref.watch(activeResumeProvider);
  return resume?.personalInfo;
});
