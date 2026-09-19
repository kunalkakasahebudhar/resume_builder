import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/education.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';

final educationProvider = Provider<List<Education>>((ref) {
  final resume = ref.watch(activeResumeProvider);
  return resume?.educations ?? [];
});
