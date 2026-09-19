import 'package:flutter/material.dart';
import 'package:frontend_userside/features/user/resume/presentation/pages/resume_builder_page.dart';

class SkillsPage extends StatelessWidget {
  final String? resumeId;

  const SkillsPage({super.key, this.resumeId});

  @override
  Widget build(BuildContext context) {
    return ResumeBuilderPage(resumeId: resumeId, initialSection: 'skills');
  }
}
