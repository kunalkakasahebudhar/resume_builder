import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';

final summaryProvider = Provider<String>((ref) {
  final resume = ref.watch(activeResumeProvider);
  return resume?.summary ?? '';
});
