import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/language.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';

final languagesProvider = Provider<List<Language>>((ref) {
  final resume = ref.watch(activeResumeProvider);
  return resume?.languages ?? [];
});
