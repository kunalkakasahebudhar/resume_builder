import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/certification.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';

final certificationsProvider = Provider<List<Certification>>((ref) {
  final resume = ref.watch(activeResumeProvider);
  return resume?.certifications ?? [];
});
