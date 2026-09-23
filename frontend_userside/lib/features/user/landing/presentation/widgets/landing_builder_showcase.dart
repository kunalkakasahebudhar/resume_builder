import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingBuilderShowcase extends StatelessWidget {
  const LandingBuilderShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final builderSections = [
      _BuilderSectionItem(
        icon: Icons.person_rounded,
        title: 'Personal Info & Contact',
        description: 'Clean header stream with LinkedIn, GitHub, Portfolio, Email, and City/Country without parser-breaking tables.',
        color: const Color(0xFF4F46E5),
      ),
      _BuilderSectionItem(
        icon: Icons.auto_awesome_rounded,
        title: 'AI Executive Summary',
        description: 'Generate high-impact professional summaries tailored for your target seniority and specialization.',
        color: const Color(0xFF8B5CF6),
      ),
      _BuilderSectionItem(
        icon: Icons.work_history_rounded,
        title: 'Work Experience & STAR',
        description: 'Quantified accomplishments with strong action verbs and metric suggestions (e.g. "Reduced latency by 42%").',
        color: const Color(0xFF06B6D4),
      ),
      _BuilderSectionItem(
        icon: Icons.school_rounded,
        title: 'Education & Academics',
        description: 'Degrees, majors, GPA honors, relevant coursework, and university graduation dates with standard ISO formatting.',
        color: const Color(0xFF10B981),
      ),
      _BuilderSectionItem(
        icon: Icons.bolt_rounded,
        title: 'Categorized Skills Matrix',
        description: 'Categorize by Languages, Frameworks, Cloud/DevOps, and Core competencies for instant keyword extraction.',
        color: const Color(0xFFF59E0B),
      ),
      _BuilderSectionItem(
        icon: Icons.code_rounded,
        title: 'Projects & Repositories',
        description: 'Showcase live URLs, open-source repos, architectural tech stacks, and quantifiable business outcomes.',
        color: const Color(0xFFEC4899),
      ),
      _BuilderSectionItem(
        icon: Icons.verified_user_rounded,
        title: 'Certifications & Credentials',
        description: 'Add AWS, Azure, GCP, PMP, or Scrums with credential IDs and direct verification URLs.',
        color: const Color(0xFF3B82F6),
      ),
      _BuilderSectionItem(
        icon: Icons.emoji_events_rounded,
        title: 'Key Achievements & Awards',
        description: 'Highlight competitive programming ranks, hackathon victories, patents, and enterprise excellence honors.',
        color: const Color(0xFFF97316),
      ),
      _BuilderSectionItem(
        icon: Icons.translate_rounded,
        title: 'Languages & Fluency',
        description: 'Standardized proficiency ratings (Native, Full Professional, Working) recognized by international ATS scanners.',
        color: const Color(0xFF14B8A6),
      ),
    ];

    return Container(
      width: double.infinity,
      color: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(vertical: 88, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              // Section Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
                  ),
                ),
                child: const Text(
                  'MODULAR RESUME BUILDER',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF4F46E5),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                'Complete 9-Section Guided Workflow',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 14),

              // Subtitle
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Text(
                  'Build, rearrange, and optimize every section of your resume with guided inputs, real-time validations, and zero guesswork.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // 9-Grid Layout with Standardized 16px/8px Rhythm
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth > 960;
                  final isTablet = constraints.maxWidth > 640 && constraints.maxWidth <= 960;

                  final itemWidth = isDesktop
                      ? (constraints.maxWidth - 48) / 3
                      : isTablet
                          ? (constraints.maxWidth - 24) / 2
                          : constraints.maxWidth;

                  return Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: builderSections.map((item) {
                      return SizedBox(
                        width: itemWidth,
                        child: _buildSectionCard(context, item, isDark),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 48),

              // 1-Click Fast Importer Callout Banner
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF1E1B4B), const Color(0xFF0F172A)]
                        : [const Color(0xFFEEF2FF), const Color(0xFFF1F5F9)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 720;

                    final content = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4F46E5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.upload_file_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Have an existing resume or LinkedIn profile?',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Use our 1-Click Fast Importer to paste plain text or JSON. We automatically parse your work experience, education, and skills in seconds.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.45,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    );

                    final button = ElevatedButton.icon(
                      onPressed: () => context.push('/resumes/new'),
                      icon: const Icon(Icons.flash_on_rounded, size: 16),
                      label: const Text('Try Fast Importer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );

                    if (isNarrow) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          content,
                          const SizedBox(height: 16),
                          button,
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(child: content),
                        const SizedBox(width: 20),
                        button,
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, _BuilderSectionItem item, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131B2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Icon Container
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: item.color, size: 22),
          ),
          const SizedBox(height: 16), // Strict 16px spatial step

          // 2. Title
          Text(
            item.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8), // Strict 8px spatial step

          // 3. Description
          Text(
            item.description,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

class _BuilderSectionItem {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  _BuilderSectionItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
