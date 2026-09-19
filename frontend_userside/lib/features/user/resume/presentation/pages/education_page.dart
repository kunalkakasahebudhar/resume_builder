import 'package:flutter/material.dart';
import 'package:frontend_userside/features/user/resume/presentation/pages/resume_builder_page.dart';

class EducationPage extends StatelessWidget {
  final String? resumeId;

  const EducationPage({super.key, this.resumeId});

  @override
  Widget build(BuildContext context) {
    return ResumeBuilderPage(resumeId: resumeId, initialSection: 'education');
  }
}
