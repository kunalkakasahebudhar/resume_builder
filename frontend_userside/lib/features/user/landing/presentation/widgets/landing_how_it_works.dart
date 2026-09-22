import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingHowItWorks extends StatelessWidget {
  const LandingHowItWorks({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final steps = [
      _WorkflowStep(
        number: '01',
        title: 'Pick Template or Quick Import',
        description: 'Choose from 11+ certified ATS single-column templates, or paste your existing resume / LinkedIn text to autofill in seconds.',
        icon: Icons.upload_file_rounded,
        color: const Color(0xFF4F46E5),
      ),
      _WorkflowStep(
        number: '02',
        title: 'AI Optimize & Match Job Description',
        description: 'Use AI to generate quantified STAR bullet points, match critical keywords against your target job posting, and achieve a 90+ ATS score.',
        icon: Icons.auto_awesome_rounded,
        color: const Color(0xFF8B5CF6),
      ),
      _WorkflowStep(
        number: '03',
        title: 'Export PDF & Apply with Confidence',
        description: 'Download a clean, pixel-perfect, ATS-verified PDF. No hidden watermarks, no broken column flows. Ready for 1-click job submissions.',
        icon: Icons.picture_as_pdf_rounded,
        color: const Color(0xFF10B981),
      ),
    ];

    return Container(
      width: double.infinity,
      color: isDark ? const Color(0xFF070B14) : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
                ),
                child: const Text(
                  'SIMPLE 3-STEP PROCESS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF6366F1),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                'From Scratch to Interview-Ready in 5 Minutes',
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
                  'Follow our streamlined path designed by tech recruiters to ensure your application stands out from hundreds of competing applicants.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(height: 52),

              // 3-Cards Horizontal Row
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth > 900;
                  final width = isDesktop
                      ? (constraints.maxWidth - 48) / 3
                      : constraints.maxWidth;

                  return Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: steps.map((step) {
                      return SizedBox(
                        width: width,
                        child: _buildStepCard(context, step, isDark),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 48),

              // Bottom CTA
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4F46E5).withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/resumes/new'),
                  icon: const Icon(Icons.rocket_launch_rounded, size: 18),
                  label: const Text('Create My Resume Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard(BuildContext context, _WorkflowStep step, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131B2E) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: step.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(step.icon, color: step.color, size: 24),
              ),
              Text(
                step.number,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFCBD5E1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            step.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            step.description,
            style: TextStyle(
              fontSize: 14,
              height: 1.55,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkflowStep {
  final String number;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  _WorkflowStep({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
