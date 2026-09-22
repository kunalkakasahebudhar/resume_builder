import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingAiToolsSection extends StatelessWidget {
  const LandingAiToolsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      color: isDark ? const Color(0xFF070B14) : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 88, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 14),
                    SizedBox(width: 6),
                    Text(
                      'AI CAREER SUPERCHARGE SUITE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                'Proprietary AI Tools to 2x Interview Callbacks',
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
                constraints: const BoxConstraints(maxWidth: 720),
                child: Text(
                  'More than just a template editor. ResumeForge includes a complete suite of recruiter-grade AI utilities designed to beat automated filters and impress hiring managers.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(height: 52),

              // Big Feature 1: ATS 100-Point Analyzer
              _buildFeatureRow(
                context: context,
                isDark: isDark,
                tag: 'CORE ENGINE',
                tagColor: const Color(0xFF10B981),
                title: 'ATS 100-Point Analyzer & Health Inspector',
                description:
                    'Automated applicant tracking systems reject 75% of resumes due to unreadable tables, missing keywords, and improper section titles. Our ATS engine analyzes every sentence and generates an actionable score breakdown with 1-click fixes.',
                points: [
                  'Section Header ISO Compliance Check (Experience, Education, Skills)',
                  'Action Verb & Metric Impact Density (STAR framework)',
                  'Recruiter Optical Readability & Workday/Greenhouse simulation',
                  'Instant actionable recommendations with live score preview',
                ],
                actionLabel: 'Launch ATS Scanner',
                onAction: () => context.push('/ats'),
                visualWidget: _buildAtsScannerVisual(isDark),
                isReversed: false,
              ),
              const SizedBox(height: 64),

              // Big Feature 2: JD Keyword Matcher
              _buildFeatureRow(
                context: context,
                isDark: isDark,
                tag: 'MATCHMAKER',
                tagColor: const Color(0xFF4F46E5),
                title: 'Job Description (JD) Keyword Gap Matcher',
                description:
                    'Paste any job posting from LinkedIn, Indeed, or Greenhouse. The JD Matcher compares the required tech stack, hard skills, and experience against your resume and highlights exactly what you need to add to rank #1.',
                points: [
                  'Real-time keyword frequency and relevancy percentage',
                  'Detection of missing required vs preferred technologies',
                  'Smart keyword placement suggestions in Experience bullets',
                  'Tailored match score to optimize before submitting application',
                ],
                actionLabel: 'Open JD Matcher',
                onAction: () => context.push('/jd-matcher'),
                visualWidget: _buildJdMatcherVisual(isDark),
                isReversed: true,
              ),
              const SizedBox(height: 64),

              // 3 Mini Features Grid (Cover Letter, Interview STAR, Salary Estimator)
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth > 880;
                  final width = isDesktop
                      ? (constraints.maxWidth - 32) / 3
                      : constraints.maxWidth;

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      SizedBox(
                        width: width,
                        child: _buildToolCard(
                          context: context,
                          isDark: isDark,
                          icon: Icons.edit_document,
                          color: const Color(0xFF4F46E5),
                          title: 'AI Cover Letter Generator',
                          description:
                              'Generate bespoke, role-specific cover letters matched with your exact resume in 3 clicks. Select tone (Professional, Modern, Confident).',
                          actionText: 'Generate Cover Letter',
                          onTap: () => context.push('/cover-letter'),
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: _buildToolCard(
                          context: context,
                          isDark: isDark,
                          icon: Icons.psychology_rounded,
                          color: const Color(0xFF6366F1),
                          title: 'AI Interview STAR Kit',
                          description:
                              'Get predicted technical and behavioral questions tailored directly from your resume projects, with structured STAR answer frameworks.',
                          actionText: 'Practice Questions',
                          onTap: () => context.push('/interview-prep'),
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: _buildToolCard(
                          context: context,
                          isDark: isDark,
                          icon: Icons.currency_rupee_rounded,
                          color: const Color(0xFF10B981),
                          title: 'Tech Salary Estimator',
                          description:
                              'Benchmark market compensation data based on your specific tech stack, years of experience, and geographic tier before salary negotiations.',
                          actionText: 'Estimate Compensation',
                          onTap: () => context.push('/salary-estimator'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow({
    required BuildContext context,
    required bool isDark,
    required String tag,
    required Color tagColor,
    required String title,
    required String description,
    required List<String> points,
    required String actionLabel,
    required VoidCallback onAction,
    required Widget visualWidget,
    required bool isReversed,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;

        final textBlock = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: tagColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: tagColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: tagColor,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 16),
            ...points.map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: tagColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        p,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? const Color(0xFFCBD5E1)
                              : const Color(0xFF334155),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              label: Text(actionLabel),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );

        if (isDesktop) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: isReversed
                ? [
                    Expanded(flex: 5, child: visualWidget),
                    const SizedBox(width: 48),
                    Expanded(flex: 5, child: textBlock),
                  ]
                : [
                    Expanded(flex: 5, child: textBlock),
                    const SizedBox(width: 48),
                    Expanded(flex: 5, child: visualWidget),
                  ],
          );
        } else {
          return Column(
            children: [
              textBlock,
              const SizedBox(height: 32),
              visualWidget,
            ],
          );
        }
      },
    );
  }

  Widget _buildAtsScannerVisual(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131B2E) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.12 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.speed_rounded, color: Color(0xFF10B981), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ATS Score Report',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const Text(
                        'Pass Probability: 98%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '94 / 100',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildScoreBar('Header & Contact Parsing', 1.0, '100%', const Color(0xFF10B981), isDark),
          const SizedBox(height: 12),
          _buildScoreBar('Impact & Metrics Density', 0.92, '92%', const Color(0xFF4F46E5), isDark),
          const SizedBox(height: 12),
          _buildScoreBar('Keyword Coverage', 0.95, '95%', const Color(0xFF6366F1), isDark),
          const SizedBox(height: 12),
          _buildScoreBar('Formatting & Single-Column', 1.0, '100%', const Color(0xFF10B981), isDark),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Zero parsing errors detected. 100% readable by Taleo, Workday, and Lever.',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBar(String label, double value, String scoreText, Color color, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
              ),
            ),
            Text(
              scoreText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildJdMatcherVisual(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131B2E) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(alpha: isDark ? 0.12 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.document_scanner_rounded, color: Color(0xFF4F46E5), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'JD Keyword Scanner',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const Text(
                        'Target Role: Staff Software Engineer',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6366F1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF4F46E5).withValues(alpha: 0.3)),
                ),
                child: const Text(
                  '88% Match',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'MATCHED HARD SKILLS (14/16)',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildTag('Microservices', true, isDark),
              _buildTag('Kubernetes', true, isDark),
              _buildTag('PostgreSQL', true, isDark),
              _buildTag('GraphQL API', true, isDark),
              _buildTag('System Design', true, isDark),
              _buildTag('Event-Driven', true, isDark),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'MISSING HIGH-PRIORITY KEYWORDS (2)',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Color(0xFFEF4444),
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildTag('Kafka Streams (Critical)', false, isDark),
              _buildTag('Terraform IaC (Preferred)', false, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, bool isMatched, bool isDark) {
    final color = isMatched ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isMatched ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required String actionText,
    required VoidCallback onTap,
  }) {
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: onTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  actionText,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, size: 14, color: color),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
