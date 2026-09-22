import 'package:flutter/material.dart';
import 'package:frontend_userside/features/user/resume/presentation/pages/resume_builder_page.dart';

class SummaryPage extends StatelessWidget {
  final String? resumeId;

  const SummaryPage({super.key, this.resumeId});

  @override
  Widget build(BuildContext context) {
    return ResumeBuilderPage(resumeId: resumeId, initialSection: 'summary');
  }
}
