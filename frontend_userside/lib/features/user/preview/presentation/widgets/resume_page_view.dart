import 'package:flutter/material.dart';
import 'package:frontend_userside/features/user/preview/presentation/widgets/resume_renderer.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/resume.dart';

class ResumePageView extends StatelessWidget {
  final Resume resume;
  final double scale;

  const ResumePageView({super.key, required this.resume, this.scale = 0.9});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Center(
        child: ResumeRenderer(resume: resume, scale: scale),
      ),
    );
  }
}
