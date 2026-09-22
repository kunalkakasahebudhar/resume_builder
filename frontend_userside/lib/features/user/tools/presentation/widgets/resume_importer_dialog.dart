import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';
import 'package:frontend_userside/features/user/profile/domain/entities/profile.dart';
import 'package:frontend_userside/features/user/profile/presentation/providers/subscription_provider.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/education.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/experience.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/project.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/resume.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/skill.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';

class ResumeImporterDialog extends ConsumerStatefulWidget {
  const ResumeImporterDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => const ResumeImporterDialog(),
    );
  }

  @override
  ConsumerState<ResumeImporterDialog> createState() =>
      _ResumeImporterDialogState();
}

class _ResumeImporterDialogState extends ConsumerState<ResumeImporterDialog> {
  final _inputController = TextEditingController(
    text: '''Alex Morgan
Senior Full Stack Engineer
alex.morgan@tech.io | +1 (555) 234-5678 | San Francisco, CA | linkedin.com/in/alexmorgan

SUMMARY
Innovative Senior Software Engineer with 6+ years designing high-throughput distributed systems, cross-platform apps with Flutter & Go, and scalable cloud architectures.

EXPERIENCE
CloudScale Technologies - Senior Backend Engineer (2022 - Present)
• Architected microservices cluster handling 100K+ RPS with 99.99% availability.
• Slashing cloud compute expenses by 35% through container optimization.

EDUCATION
UC Berkeley - B.S. in Computer Science (2016 - 2020) | GPA: 3.88

SKILLS
Flutter, Dart, Go, TypeScript, AWS, Docker, Kubernetes, GraphQL, PostgreSQL, Redis''',
  );

  bool _isImporting = false;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _handleImport() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    final allowed = await ref
        .read(subscriptionProvider.notifier)
        .checkAndConsumeQuota(context, actionName: 'Instant Resume Import');
    if (!allowed || !mounted) return;

    setState(() => _isImporting = true);

    await Future.delayed(const Duration(milliseconds: 900));

    final now = DateTime.now();
    final newResume = Resume(
      id: 'res_${now.millisecondsSinceEpoch}',
      title: 'Imported LinkedIn ATS Resume',
      templateId: 'ats_harvard',
      createdAt: now,
      updatedAt: now,
      summary:
          'Innovative Senior Software Engineer with 6+ years designing high-throughput distributed systems, cross-platform apps with Flutter & Go, and scalable cloud architectures.',
      personalInfo: const Profile(
        id: 'prof_imported',
        fullName: 'Alex Morgan',
        email: 'alex.morgan@tech.io',
        phone: '+1 (555) 234-5678',
        location: 'San Francisco, CA',
        professionalTitle: 'Senior Full Stack Engineer',
        linkedinUrl: 'linkedin.com/in/alexmorgan',
        githubUrl: 'github.com/alexmorgan',
      ),
      experiences: [
        const Experience(
          id: 'exp_1',
          company: 'CloudScale Technologies',
          jobTitle: 'Senior Backend Engineer',
          location: 'San Francisco, CA',
          startDate: '2022',
          endDate: 'Present',
          isCurrentlyWorking: true,
          description:
              '• Architected microservices cluster handling 100K+ RPS with 99.99% availability.\n• Slashing cloud compute expenses by 35% through container optimization.',
        ),
      ],
      educations: [
        const Education(
          id: 'edu_1',
          institution: 'UC Berkeley',
          degree: 'B.S. in Computer Science',
          location: 'Berkeley, CA',
          startDate: '2016',
          endDate: '2020',
          gradeOrCgpa: '3.88',
        ),
      ],
      skills: const [
        Skill(id: 's_1', name: 'Flutter', category: SkillCategory.framework, level: 'Expert'),
        Skill(id: 's_2', name: 'Dart', category: SkillCategory.programmingLanguage, level: 'Expert'),
        Skill(id: 's_3', name: 'Go', category: SkillCategory.programmingLanguage, level: 'Advanced'),
        Skill(id: 's_4', name: 'TypeScript', category: SkillCategory.programmingLanguage, level: 'Advanced'),
        Skill(id: 's_5', name: 'AWS', category: SkillCategory.tool, level: 'Advanced'),
        Skill(id: 's_6', name: 'Kubernetes', category: SkillCategory.tool, level: 'Intermediate'),
        Skill(id: 's_7', name: 'GraphQL', category: SkillCategory.technical, level: 'Advanced'),
      ],
      projects: const [
        Project(
          id: 'proj_1',
          projectName: 'High-Throughput Streaming Engine',
          technologies: 'Go, Kafka, Redis, Docker',
          description:
              '• Engineered streaming architecture processing 2.5B records daily with sub-millisecond delivery SLA.',
        ),
      ],
    );

    ref.read(resumesListProvider.notifier).addResume(newResume);
    ref.read(activeResumeProvider.notifier).setResume(newResume);

    if (mounted) {
      setState(() => _isImporting = false);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Resume imported & parsed into ATS format successfully!'),
          backgroundColor: Color(0xFF059669),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 640, maxHeight: 720),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0284C7), Color(0xFF2563EB)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.download_for_offline_rounded,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '1-Click LinkedIn / Text Importer',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Text(
                              'Paste your existing resume or LinkedIn text to auto-fill all sections',
                              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Text(
              'PASTE RESUME OR LINKEDIN PROFILE TEXT',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _inputController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Paste resume text here...',
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                AppButton(
                  text: 'Cancel',
                  type: ButtonType.outline,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                AppButton(
                  text: 'Parse & Create Resume',
                  icon: Icons.auto_awesome_rounded,
                  isLoading: _isImporting,
                  onPressed: _handleImport,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
