import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingHeroSection extends StatelessWidget {
  final VoidCallback onExploreTemplates;

  const LandingHeroSection({
    super.key,
    required this.onExploreTemplates,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.0, -0.6),
          radius: 1.2,
          colors: isDark
              ? [
                  const Color(0xFF1E1B4B).withValues(alpha: 0.6),
                  const Color(0xFF0F172A).withValues(alpha: 0.9),
                  const Color(0xFF070B14),
                ]
              : [
                  const Color(0xFFEEF2FF),
                  const Color(0xFFF8FAFC),
                  Colors.white,
                ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 960;

                if (isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 6,
                        child: _buildHeroTextContent(context, isDark),
                      ),
                      const SizedBox(width: 48),
                      Expanded(
                        flex: 5,
                        child: _buildHeroVisualMockup(context, isDark),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildHeroTextContent(context, isDark, isCentered: true),
                      const SizedBox(height: 48),
                      _buildHeroVisualMockup(context, isDark),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroTextContent(BuildContext context, bool isDark, {bool isCentered = false}) {
    return Column(
      crossAxisAlignment:
          isCentered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Announcement Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF4F46E5).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color(0xFF4F46E5).withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Next-Gen ATS Engine 2.0 • AI-Powered Optimization',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6366F1),
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Main Headline
        RichText(
          textAlign: isCentered ? TextAlign.center : TextAlign.start,
          text: TextSpan(
            style: TextStyle(
              fontSize: isCentered ? 36 : 46,
              fontWeight: FontWeight.w900,
              height: 1.15,
              letterSpacing: -1.2,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            children: [
              const TextSpan(text: 'Build Job-Winning, '),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF9333EA), Color(0xFF06B6D4)],
                  ).createShader(bounds),
                  child: Text(
                    'ATS-Optimized',
                    style: TextStyle(
                      fontSize: isCentered ? 36 : 46,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                      letterSpacing: -1.2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const TextSpan(text: ' Resumes in Minutes'),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Subtitle Description
        Text(
          'Beat applicant tracking systems with AI-assisted bullet points, 11+ Harvard-grade single-column templates, live 100-point ATS scoring, JD matching, and instant PDF exports.',
          textAlign: isCentered ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 32),

        // Call to action buttons
        Wrap(
          spacing: 14,
          runSpacing: 14,
          alignment: isCentered ? WrapAlignment.center : WrapAlignment.start,
          children: [
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
                icon: const Icon(Icons.flash_on_rounded, size: 18),
                label: const Text('Start Building Free'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
            OutlinedButton.icon(
              onPressed: () => context.push('/ats'),
              icon: const Icon(Icons.analytics_outlined, size: 18),
              label: const Text('Test ATS Scanner'),
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
                side: BorderSide(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFCBD5E1),
                  width: 1.5,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: onExploreTemplates,
              icon: const Icon(Icons.palette_outlined, size: 18),
              label: const Text('View 11+ Templates'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6366F1),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 36),

        // Proof metrics bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E293B).withValues(alpha: 0.5)
                : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Wrap(
            spacing: 20,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _buildTrustMetric('98.4%', 'ATS Pass Rate', const Color(0xFF10B981)),
              _buildMetricDivider(isDark),
              _buildTrustMetric('100k+', 'Resumes Generated', const Color(0xFF4F46E5)),
              _buildMetricDivider(isDark),
              _buildTrustMetric('11+', 'Certified Templates', const Color(0xFF8B5CF6)),
              _buildMetricDivider(isDark),
              _buildTrustMetric('0', 'Formatting Glitches', const Color(0xFF06B6D4)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrustMetric(String value, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricDivider(bool isDark) {
    return Container(
      width: 1,
      height: 14,
      color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
    );
  }

  Widget _buildHeroVisualMockup(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? const Color(0xFF334155)
              : const Color(0xFFE2E8F0),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(alpha: isDark ? 0.2 : 0.1),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar of Mockup
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF59E0B),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 14),
                    SizedBox(width: 4),
                    Text(
                      'ATS 100% Validated',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ATS Live Score Gauge
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E1B4B), const Color(0xFF1E293B)]
                    : [const Color(0xFFEEF2FF), const Color(0xFFF8FAFC)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF4F46E5).withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '98',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Senior Full-Stack Engineer Resume',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Excellent ATS parser score. Ready for high-volume job applications.',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Resume Mini Sample Preview
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF151E32) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ALEXANDER MORGAN',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'San Francisco, CA • alex@tech.io',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 1,
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
                ),
                const SizedBox(height: 8),
                Text(
                  'EXPERIENCE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: const Color(0xFF4F46E5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Lead Software Engineer | Apex Cloud (2023 - Present)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '• Architected microservices serving 1.2M daily queries with 99.99% uptime.\n• Boosted query latency by 42% through distributed Redis caching strategies.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.45,
                    color: isDark
                        ? const Color(0xFFCBD5E1)
                        : const Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'MATCHED KEYWORDS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: const Color(0xFF4F46E5),
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _buildKeywordBadge('Flutter & Dart', const Color(0xFF06B6D4), isDark),
                    _buildKeywordBadge('Distributed Systems', const Color(0xFF8B5CF6), isDark),
                    _buildKeywordBadge('Cloud Architecture', const Color(0xFF10B981), isDark),
                    _buildKeywordBadge('CI/CD Pipelines', const Color(0xFFF59E0B), isDark),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Bottom Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Harvard & Standard ISO Format',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
              InkWell(
                onTap: () => context.push('/resumes/new'),
                child: const Row(
                  children: [
                    Text(
                      'Try this layout',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4F46E5),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: Color(0xFF4F46E5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeywordBadge(String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
