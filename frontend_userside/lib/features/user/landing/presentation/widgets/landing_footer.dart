import 'package:flutter/material.dart';
import 'package:frontend_userside/app/constants/app_constants.dart';
import 'package:go_router/go_router.dart';

class LandingFooter extends StatelessWidget {
  final VoidCallback? onFeaturesClick;
  final VoidCallback? onAiSuiteClick;
  final VoidCallback? onTemplatesClick;
  final VoidCallback? onFaqClick;

  const LandingFooter({
    super.key,
    this.onFeaturesClick,
    this.onAiSuiteClick,
    this.onTemplatesClick,
    this.onFaqClick,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      color: isDark ? const Color(0xFF070B14) : const Color(0xFF0F172A),
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth > 900;
                  final isTablet = constraints.maxWidth > 580 && constraints.maxWidth <= 900;

                  final columnWidth = isDesktop
                      ? (constraints.maxWidth - 72) / 4
                      : isTablet
                          ? (constraints.maxWidth - 24) / 2
                          : constraints.maxWidth;

                  return Wrap(
                    spacing: 24,
                    runSpacing: 32,
                    children: [
                      // Column 1: Brand
                      SizedBox(
                        width: columnWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.auto_stories_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppConstants.appName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'The intelligent, ATS-certified resume building platform designed to help job seekers land top-tier tech and corporate roles.',
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.55,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.shield_rounded, size: 14, color: Color(0xFF10B981)),
                                  SizedBox(width: 6),
                                  Text(
                                    '100% ATS Compliant',
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
                      ),

                      // Column 2: Resume Features
                      SizedBox(
                        width: columnWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'BUILDER FEATURES',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildFooterLink('Interactive Modular Builder', () => context.push('/resumes/new')),
                            _buildFooterLink('1-Click Fast Import', () => context.push('/resumes/new')),
                            _buildFooterLink('11+ ATS Templates', () => context.push('/templates')),
                            _buildFooterLink('Real-Time Live Preview', () => context.push('/preview')),
                            _buildFooterLink('Pixel-Perfect PDF Export', () => context.push('/pdf')),
                          ],
                        ),
                      ),

                      // Column 3: AI Career Tools
                      SizedBox(
                        width: columnWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'AI CAREER SUITE',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildFooterLink('ATS 100pt Health Scanner', () => context.push('/ats')),
                            _buildFooterLink('Job Description Matcher', () => context.push('/jd-matcher')),
                            _buildFooterLink('AI Cover Letter Writer', () => context.push('/cover-letter')),
                            _buildFooterLink('STAR Interview Prep Kit', () => context.push('/interview-prep')),
                            _buildFooterLink('Tech Salary Estimator', () => context.push('/salary-estimator')),
                          ],
                        ),
                      ),

                      // Column 4: Account & Auth
                      SizedBox(
                        width: columnWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ACCOUNT & ACCESS',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildFooterLink('Sign In to Account', () => context.push('/login')),
                            _buildFooterLink('Create Free Account', () => context.push('/register')),
                            _buildFooterLink('My Dashboard', () => context.push('/dashboard')),
                            _buildFooterLink('My Saved Resumes', () => context.push('/resumes')),
                            _buildFooterLink('User Profile Settings', () => context.push('/profile')),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 48),
              Container(
                height: 1,
                color: const Color(0xFF1E293B),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '© ${DateTime.now().year} ResumeForge. Built with Flutter & Riverpod.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const Text(
                    'Engineered for 100% ATS Compatibility',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLink(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }
}
