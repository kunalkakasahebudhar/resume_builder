import 'package:flutter/material.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';
import 'package:frontend_userside/features/user/templates/domain/entities/resume_template.dart';

class TemplatePreviewDialog extends StatelessWidget {
  final ResumeTemplate template;
  final VoidCallback onSelect;

  const TemplatePreviewDialog({
    super.key,
    required this.template,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: theme.colorScheme.surface,
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 640, maxHeight: 720),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '100% ATS Approved',
                            style: TextStyle(
                              color: Color(0xFF059669),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          template.category,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: _buildPreviewLayout(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  text: 'Close',
                  type: ButtonType.outline,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 12),
                AppButton(
                  text: 'Apply This Template',
                  icon: Icons.check_circle_outline_rounded,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onSelect();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewLayout() {
    switch (template.id) {
      case 'ats_harvard':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'ALEXANDER MORGAN',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 3),
            const Center(
              child: Text(
                'Cambridge, MA • a.morgan@alumni.harvard.edu • +1 (555) 234-5678',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 9.5,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildSectionHeader('EDUCATION', isSerif: true),
            const SizedBox(height: 4),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'HARVARD UNIVERSITY',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Cambridge, MA',
                  style: TextStyle(fontFamily: 'serif', fontSize: 9.5),
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'B.A. in Computer Science & Economics, GPA: 3.92',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 9.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  '2018 – 2022',
                  style: TextStyle(fontFamily: 'serif', fontSize: 9.5),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildSectionHeader('EXPERIENCE', isSerif: true),
            const SizedBox(height: 4),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'MCKINSEY & COMPANY / TECH PRACTICE',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'New York, NY',
                  style: TextStyle(fontFamily: 'serif', fontSize: 9.5),
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Senior Technology Consultant',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 9.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  '2022 – Present',
                  style: TextStyle(fontFamily: 'serif', fontSize: 9.5),
                ),
              ],
            ),
            const SizedBox(height: 2),
            const Text(
              '• Led enterprise AI data transformation reducing query latency by 42% across 5 Fortune 500 clients.\n• Spearheaded high-throughput streaming architecture processing 2.5B daily records.',
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 9,
                height: 1.35,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildSectionHeader('SKILLS & INTERESTS', isSerif: true),
            const SizedBox(height: 4),
            const Text(
              'Technical Skills: Python, SQL, Cloud Architecture, Distributed Systems, Flutter, Go\nCertifications: AWS Solutions Architect Professional, CFA Level 1',
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 9,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
          ],
        );

      case 'ats_tech_minimal':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ALEX MORGAN',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      'Staff Software Engineer',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('alex.dev@silicon.io',
                        style: TextStyle(fontSize: 9, color: Color(0xFF334155))),
                    Text('github.com/alexmorgan',
                        style: TextStyle(fontSize: 9, color: Color(0xFF2563EB))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(height: 2, color: const Color(0xFF0F172A)),
            const SizedBox(height: 10),
            _buildTechHeader('TECHNICAL SKILLS'),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Text(
                'Languages: Go, TypeScript, Dart, Python, Rust, SQL\nFrameworks: Flutter, Next.js, FastAPI, gRPC, Node.js\nCloud & DevOps: AWS, Kubernetes, Docker, Terraform, CI/CD pipelines',
                style: TextStyle(fontSize: 9, height: 1.4, color: Color(0xFF334155)),
              ),
            ),
            const SizedBox(height: 10),
            _buildTechHeader('ENGINEERING EXPERIENCE'),
            const SizedBox(height: 4),
            const Text(
              'Senior Backend Engineer — CloudScale Labs (2021 – Present)',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            const Text(
              '• Architected microservices cluster handling 100K+ RPS with 99.99% availability.\n• Reduced cloud infrastructure spend by 35% via container right-sizing and caching.',
              style: TextStyle(fontSize: 9, height: 1.35, color: Colors.black87),
            ),
          ],
        );

      case 'ats_executive':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ALEXANDER MORGAN',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'VP OF ENGINEERING / CHIEF ARCHITECT',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
                Text(
                  'San Francisco, CA • (555) 234-5678',
                  style: TextStyle(fontSize: 9, color: Color(0xFF475569)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(height: 2, color: const Color(0xFF0F172A)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                border: Border(
                  left: BorderSide(color: Color(0xFF0F172A), width: 3),
                ),
              ),
              child: const Text(
                'Visionary technology executive with 12+ years driving hyper-scale platform engineering, team scaling from 10 to 120+ engineers, and multi-million dollar ARR growth.',
                style: TextStyle(fontSize: 9.5, height: 1.4, color: Color(0xFF1E293B)),
              ),
            ),
            const SizedBox(height: 10),
            _buildSectionHeader('CORE LEADERSHIP COMPETENCIES'),
            const SizedBox(height: 4),
            const Text(
              'Enterprise Architecture • Multi-Region Scaling • Team Building & Mentorship • P&L Management • Cloud Cost Optimization',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
            ),
          ],
        );

      case 'ats_modern_clean':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ELENA ROSTOVA',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'Lead Full Stack Architect',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0D9488),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('elena.rostova@tech.io',
                        style: TextStyle(fontSize: 9, color: Color(0xFF334155))),
                    Text('San Francisco, CA • (555) 789-0123',
                        style: TextStyle(fontSize: 9, color: Color(0xFF64748B))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(height: 1.5, color: const Color(0xFF0D9488)),
            const SizedBox(height: 8),
            _buildModernHeader('SUMMARY'),
            const SizedBox(height: 3),
            const Text(
              'High-impact software architect with 8+ years experience scaling real-time distributed microservices and mobile apps across multi-cloud environments.',
              style: TextStyle(fontSize: 9.5, height: 1.4, color: Color(0xFF334155)),
            ),
            const SizedBox(height: 8),
            _buildModernHeader('CORE SKILLS'),
            const SizedBox(height: 3),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: ['TypeScript', 'Flutter', 'Go', 'Docker', 'AWS', 'GraphQL']
                  .map((s) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                              color: const Color(0xFFCBD5E1), width: 0.6),
                        ),
                        child: Text(s,
                            style: const TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B))),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
            _buildModernHeader('EXPERIENCE'),
            const SizedBox(height: 3),
            const Text(
              'Principal Engineer — Veloce Cloud (2022 – Present)',
              style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold),
            ),
            const Text(
              '• Spearheaded GraphQL gateway reducing network payload by 55% across 20M active devices.',
              style: TextStyle(fontSize: 9, height: 1.35, color: Colors.black87),
            ),
          ],
        );

      case 'ats_data_fintech':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'ETHAN VANDERBILT, CFA',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            const SizedBox(height: 2),
            const Center(
              child: Text(
                'QUANTITATIVE STRATEGIST & PORTFOLIO ANALYST',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E40AF),
                ),
              ),
            ),
            const SizedBox(height: 2),
            const Center(
              child: Text(
                'New York, NY • e.vanderbilt@finquant.com • +1 (212) 555-0199',
                style: TextStyle(fontSize: 9, color: Color(0xFF334155)),
              ),
            ),
            const SizedBox(height: 8),
            Container(height: 1.5, color: const Color(0xFF1E40AF)),
            const SizedBox(height: 8),
            _buildSectionHeader('QUANTITATIVE PROFILE & CORE METRICS'),
            const SizedBox(height: 3),
            const Text(
              'Quantitative strategist with 6+ years specializing in statistical arbitrage, algorithmic execution, and real-time risk modeling across fixed income and equities.',
              style: TextStyle(fontSize: 9, height: 1.35, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 8),
            _buildSectionHeader('TECHNICAL & QUANTITATIVE TOOLKIT'),
            const SizedBox(height: 3),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: const Text(
                'Modeling: Python (NumPy, SciPy, Pandas), C++, R, SQL, Monte Carlo, GARCH\nPlatforms: Bloomberg Terminal, FactSet, KDB+/Q, AWS SageMaker, Snowflake',
                style: TextStyle(fontSize: 8.5, height: 1.35, color: Color(0xFF0F172A)),
              ),
            ),
            const SizedBox(height: 8),
            _buildSectionHeader('PROFESSIONAL EXPERIENCE'),
            const SizedBox(height: 3),
            const Text(
              'Senior Quantitative Analyst — Citadel Securities (2021 – Present)',
              style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold),
            ),
            const Text(
              '• Engineered low-latency statistical arbitrage models generating \$14.2M in annual alpha with Sharpe ratio of 2.85.\n• Backtested 150+ order execution algorithms reducing slippage by 18 bps.',
              style: TextStyle(fontSize: 9, height: 1.35, color: Colors.black87),
            ),
          ],
        );

      case 'ats_stanford':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'DR. JULIA CHEN',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Color(0xFF8C1D40),
                ),
              ),
            ),
            const SizedBox(height: 2),
            const Center(
              child: Text(
                'Stanford, CA • jchen@stanford.edu • (650) 723-2300',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 9,
                  color: Color(0xFF444444),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(height: 1.2, color: const Color(0xFF8C1D40)),
            const SizedBox(height: 8),
            _buildSectionHeader('RESEARCH FOCUS', isSerif: true),
            const SizedBox(height: 3),
            const Text(
              'Postdoctoral researcher focusing on neural network interpretability, sparse attention transformers, and efficient edge inference.',
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 9,
                height: 1.35,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildSectionHeader('EDUCATION', isSerif: true),
            const SizedBox(height: 3),
            const Text(
              'STANFORD UNIVERSITY — Ph.D. in Computer Science (2019 – 2024)',
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 9.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Dissertation: "Scalable Sparse Attention in Multi-Modal Deep Models" • Advisor: Prof. Chris Manning',
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 8.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        );

      case 'ats_classic':
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'ALEX MORGAN',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Colors.black,
                ),
              ),
            ),
            const Center(
              child: Text(
                'San Francisco, CA • user@resumeforge.com • +1 (555) 234-5678',
                style: TextStyle(fontSize: 10, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.black54, thickness: 1),
            const SizedBox(height: 8),
            _buildSectionHeader('PROFESSIONAL SUMMARY'),
            const SizedBox(height: 4),
            const Text(
              'Experienced Software Engineer with a passion for designing scalable web architectures and leading developer teams.',
              style: TextStyle(fontSize: 10, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            _buildSectionHeader('EXPERIENCE'),
            const SizedBox(height: 4),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Senior Software Engineer',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '2022 - Present',
                  style: TextStyle(fontSize: 9, color: Colors.black87),
                ),
              ],
            ),
            const Text(
              'CloudScale Technologies - San Francisco, CA',
              style: TextStyle(
                fontSize: 9,
                fontStyle: FontStyle.italic,
                color: Colors.black87,
              ),
            ),
            const Text(
              '• Scaled distributed API services to 10M+ daily events.\n• Mentored 8 junior and mid-level engineers.',
              style: TextStyle(fontSize: 9, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            _buildSectionHeader('EDUCATION'),
            const SizedBox(height: 4),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'B.S. in Computer Science',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '2016 - 2020',
                  style: TextStyle(fontSize: 9, color: Colors.black87),
                ),
              ],
            ),
            const Text(
              'UC Berkeley, GPA: 3.85',
              style: TextStyle(fontSize: 9, color: Colors.black87),
            ),
          ],
        );
    }
  }

  Widget _buildSectionHeader(String title, {bool isSerif = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: isSerif ? 'serif' : null,
            fontSize: 10.5,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 2),
        Container(height: 1, color: Colors.black87),
      ],
    );
  }

  Widget _buildTechHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 3, height: 10, color: const Color(0xFF2563EB)),
            const SizedBox(width: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Container(height: 1, color: const Color(0xFFE2E8F0)),
      ],
    );
  }

  Widget _buildModernHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 3, height: 10, color: const Color(0xFF0D9488)),
            const SizedBox(width: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Container(height: 1, color: const Color(0xFFE2E8F0)),
      ],
    );
  }
}
