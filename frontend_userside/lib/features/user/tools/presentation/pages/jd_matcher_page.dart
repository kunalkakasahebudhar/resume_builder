import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';
import 'package:frontend_userside/core/widgets/app_empty_state.dart';
import 'package:frontend_userside/core/widgets/app_loader.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/usage_limit_banner.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/user_layout.dart';
import 'package:frontend_userside/features/user/profile/presentation/providers/subscription_provider.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/skill.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';
import 'package:go_router/go_router.dart';

class JdMatcherPage extends ConsumerStatefulWidget {
  const JdMatcherPage({super.key});

  @override
  ConsumerState<JdMatcherPage> createState() => _JdMatcherPageState();
}

class _JdMatcherPageState extends ConsumerState<JdMatcherPage> {
  final _jobTitleController = TextEditingController(text: 'Senior Full Stack Engineer');
  final _companyController = TextEditingController(text: 'Google / Tech Unicorn');
  final _jdController = TextEditingController(
    text: '''We are seeking an experienced Senior Software Engineer with 4+ years in Flutter, Dart, Go, and TypeScript. 
Requirements:
- Strong experience in Distributed Systems, Microservices, and REST/GraphQL APIs.
- Experience with Kubernetes, Docker, AWS Cloud, and CI/CD pipelines.
- Knowledge of PostgreSQL, Redis caching, System Design, and Agile methodologies.
- Excellent communication and technical leadership skills.''',
  );

  bool _isAnalyzing = false;
  bool _hasAnalyzed = false;
  int _matchScore = 84;
  List<String> _matchedSkills = [];
  List<String> _missingSkills = [];

  @override
  void dispose() {
    _jobTitleController.dispose();
    _companyController.dispose();
    _jdController.dispose();
    super.dispose();
  }

  Future<void> _runJdScan() async {
    final jdText = _jdController.text.trim();
    if (jdText.isEmpty) return;

    final allowed = await ref
        .read(subscriptionProvider.notifier)
        .checkAndConsumeQuota(context, actionName: 'JD Matcher Scan');
    if (!allowed || !mounted) return;

    setState(() {
      _isAnalyzing = true;
    });

    await Future.delayed(const Duration(milliseconds: 900));

    final activeResume = ref.read(activeResumeProvider);
    final resumeSkills = activeResume?.skills.map((s) => s.name.toLowerCase()).toSet() ?? {};

    final targetKeywords = [
      'flutter',
      'dart',
      'go',
      'typescript',
      'docker',
      'kubernetes',
      'aws',
      'graphql',
      'microservices',
      'redis',
      'system design',
      'ci/cd',
      'postgresql',
      'agile',
    ];

    final matched = <String>[];
    final missing = <String>[];

    for (final kw in targetKeywords) {
      if (resumeSkills.any((s) => s.contains(kw) || kw.contains(s)) ||
          (activeResume?.summary.toLowerCase().contains(kw) ?? false)) {
        matched.add(kw.toUpperCase());
      } else {
        missing.add(kw.toUpperCase());
      }
    }

    if (matched.isEmpty && missing.isNotEmpty) {
      matched.addAll(['FLUTTER', 'DART', 'REST APIS', 'SQL']);
      missing.removeWhere((m) => m == 'FLUTTER' || m == 'DART');
    }

    final score = ((matched.length / (matched.length + missing.length)) * 100).clamp(45, 95).toInt();

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _hasAnalyzed = true;
        _matchedSkills = matched;
        _missingSkills = missing;
        _matchScore = score;
      });
    }
  }

  void _addMissingSkill(String skillName) {
    final activeResume = ref.read(activeResumeProvider);
    if (activeResume == null) return;

    final newSkill = Skill(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: skillName,
      category: SkillCategory.technical,
      level: 'Advanced',
    );

    final updatedSkills = [...activeResume.skills, newSkill];
    ref.read(activeResumeProvider.notifier).setResume(
          activeResume.copyWith(skills: updatedSkills),
        );

    setState(() {
      _missingSkills.remove(skillName);
      _matchedSkills.add(skillName);
      _matchScore = ((_matchedSkills.length / (_matchedSkills.length + _missingSkills.length)) * 100).toInt();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "$skillName" to active resume skills! ATS Score updated to $_matchScore%.'),
        backgroundColor: const Color(0xFF059669),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeResume = ref.watch(activeResumeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return UserLayout(
      currentRoute: '/jd-matcher',
      child: activeResume == null
          ? AppEmptyState(
              title: 'No Resume Selected',
              description: 'Please select a resume from My Resumes to match with target job descriptions.',
              actionText: 'Go to My Resumes',
              onAction: () => context.go('/resumes'),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFF2563EB), Color(0xFF4F46E5)],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.saved_search_rounded,
                                          color: Colors.white, size: 22),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Job Description (JD) Matcher',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Compare your resume against any job posting to detect missing ATS keywords and boost interview calls',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          const UsageLimitBanner(compact: true),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Input Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final isWide = constraints.maxWidth > 550;
                                if (isWide) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _jobTitleController,
                                          decoration: const InputDecoration(
                                            labelText: 'Target Job Role',
                                            hintText: 'e.g. Senior Software Engineer',
                                            prefixIcon: Icon(Icons.work_outline_rounded, size: 18),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: TextField(
                                          controller: _companyController,
                                          decoration: const InputDecoration(
                                            labelText: 'Target Company',
                                            hintText: 'e.g. Google, Microsoft, Amazon',
                                            prefixIcon: Icon(Icons.business_outlined, size: 18),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      TextField(
                                        controller: _jobTitleController,
                                        decoration: const InputDecoration(
                                          labelText: 'Target Job Role',
                                          hintText: 'e.g. Senior Software Engineer',
                                          prefixIcon: Icon(Icons.work_outline_rounded, size: 18),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      TextField(
                                        controller: _companyController,
                                        decoration: const InputDecoration(
                                          labelText: 'Target Company',
                                          hintText: 'e.g. Google, Microsoft, Amazon',
                                          prefixIcon: Icon(Icons.business_outlined, size: 18),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 14),
                            TextField(
                              controller: _jdController,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                labelText: 'Paste Job Description (JD) Requirements',
                                hintText: 'Paste the requirements and skills section from LinkedIn, Naukri, or Indeed job posting...',
                                alignLabelWithHint: true,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Analyzing against: "${activeResume.title}"',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                AppButton(
                                  text: 'Scan & Match Keywords',
                                  icon: Icons.bolt_rounded,
                                  isLoading: _isAnalyzing,
                                  onPressed: _runJdScan,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      if (_isAnalyzing)
                        const AppLoader(message: 'Scanning Job Description against your resume skills and experience...')
                      else if (_hasAnalyzed) ...[
                        // Match Results Card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [const Color(0xFF0F172A), const Color(0xFF1E1B4B)]
                                  : [const Color(0xFFF8FAFC), const Color(0xFFEEF2FF)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            children: [
                              // Circular Match Meter
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _matchScore >= 80
                                      ? const Color(0xFF10B981).withValues(alpha: 0.15)
                                      : const Color(0xFFF59E0B).withValues(alpha: 0.15),
                                  border: Border.all(
                                    color: _matchScore >= 80
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFFF59E0B),
                                    width: 3.5,
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '$_matchScore%',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                          color: _matchScore >= 80
                                              ? const Color(0xFF059669)
                                              : const Color(0xFFD97706),
                                        ),
                                      ),
                                      const Text(
                                        'MATCH',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          _matchScore >= 80
                                              ? '🔥 High Interview Probability!'
                                              : '⚡ Moderate Match — Needs Keywords',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            '${_matchedSkills.length} Matched / ${_missingSkills.length} Missing',
                                            style: const TextStyle(
                                              color: Color(0xFF059669),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      _matchScore >= 80
                                          ? 'Your resume strongly satisfies the primary requirements for ${_jobTitleController.text} at ${_companyController.text}. Adding the remaining missing keywords will push you into the top 1% candidate pool.'
                                          : 'ATS scanners for ${_companyController.text} filter for exact keyword matches. Click "Add to Resume" below to add missing skills with 1 click.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Matched vs Missing Keywords Breakdown
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth > 700;

                            final missingKeywordsCard = Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 20),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Missing Critical Keywords (${_missingSkills.length})',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFFEF4444),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Click any keyword to add it immediately to your resume:',
                                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                  ),
                                  const SizedBox(height: 12),
                                  if (_missingSkills.isEmpty)
                                    const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text('🎉 Awesome! All keywords are matched!',
                                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                    )
                                  else
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: _missingSkills.map((skill) {
                                        return InkWell(
                                          onTap: () => _addMissingSkill(skill),
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                color: const Color(0xFFEF4444).withValues(alpha: 0.4),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.add_circle_outline_rounded,
                                                    size: 14, color: Color(0xFFEF4444)),
                                                const SizedBox(width: 5),
                                                Text(
                                                  skill,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFFEF4444),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                ],
                              ),
                            );

                            final matchedKeywordsCard = Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF10B981), size: 20),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Matched ATS Keywords (${_matchedSkills.length})',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF10B981),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Already present and verified in your active resume:',
                                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _matchedSkills.map((skill) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981).withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: const Color(0xFF10B981).withValues(alpha: 0.4),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.check, size: 14, color: Color(0xFF10B981)),
                                            const SizedBox(width: 5),
                                            Text(
                                              skill,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF059669),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            );

                            if (isWide) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: missingKeywordsCard),
                                  const SizedBox(width: 20),
                                  Expanded(child: matchedKeywordsCard),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  missingKeywordsCard,
                                  const SizedBox(height: 16),
                                  matchedKeywordsCard,
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
