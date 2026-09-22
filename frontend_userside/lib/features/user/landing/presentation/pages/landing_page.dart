import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/features/user/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_userside/features/user/landing/presentation/widgets/landing_ai_tools_section.dart';
import 'package:frontend_userside/features/user/landing/presentation/widgets/landing_builder_showcase.dart';
import 'package:frontend_userside/features/user/landing/presentation/widgets/landing_comparison_section.dart';
import 'package:frontend_userside/features/user/landing/presentation/widgets/landing_cta_section.dart';
import 'package:frontend_userside/features/user/landing/presentation/widgets/landing_faq_section.dart';
import 'package:frontend_userside/features/user/landing/presentation/widgets/landing_footer.dart';
import 'package:frontend_userside/features/user/landing/presentation/widgets/landing_hero_section.dart';
import 'package:frontend_userside/features/user/landing/presentation/widgets/landing_how_it_works.dart';
import 'package:frontend_userside/features/user/landing/presentation/widgets/landing_navbar.dart';
import 'package:frontend_userside/features/user/landing/presentation/widgets/landing_templates_section.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _aiSuiteKey = GlobalKey();
  final GlobalKey _templatesKey = GlobalKey();
  final GlobalKey _howItWorksKey = GlobalKey();
  final GlobalKey _faqKey = GlobalKey();

  final ScrollController _scrollController = ScrollController();
  bool _showStickyMobileCta = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    if (offset > 400 && !_showStickyMobileCta) {
      setState(() => _showStickyMobileCta = true);
    } else if (offset <= 400 && _showStickyMobileCta) {
      setState(() => _showStickyMobileCta = false);
    }
  }

  void _scrollToKey(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authState = ref.watch(authProvider);
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF070B14) : Colors.white,
      drawer: _buildMobileDrawer(context, isDark, authState.isAuthenticated),
      bottomNavigationBar: (isMobile && _showStickyMobileCta)
          ? _buildStickyBottomBar(context, isDark)
          : null,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Sticky Top Navigation
            LandingNavbar(
              onFeaturesClick: () => _scrollToKey(_featuresKey),
              onAiSuiteClick: () => _scrollToKey(_aiSuiteKey),
              onTemplatesClick: () => _scrollToKey(_templatesKey),
              onHowItWorksClick: () => _scrollToKey(_howItWorksKey),
              onFaqClick: () => _scrollToKey(_faqKey),
              onOpenDrawer: () => Scaffold.of(context).openDrawer(),
            ),

            // Main Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // 1. Hero Section
                    LandingHeroSection(
                      onExploreTemplates: () => _scrollToKey(_templatesKey),
                    ),

                    // 2. Modular Resume Builder 9-Section Showcase
                    Container(
                      key: _featuresKey,
                      child: const LandingBuilderShowcase(),
                    ),

                    // 3. AI Career Supercharge Suite (ATS Scanner, JD Matcher, Cover Letter, STAR Kit, Salary)
                    Container(
                      key: _aiSuiteKey,
                      child: const LandingAiToolsSection(),
                    ),

                    // 4. 11+ ATS-Friendly Templates Showcase
                    Container(
                      key: _templatesKey,
                      child: const LandingTemplatesSection(),
                    ),

                    // 5. How It Works (3 Steps)
                    Container(
                      key: _howItWorksKey,
                      child: const LandingHowItWorks(),
                    ),

                    // 6. ResumeForge vs Traditional Builders
                    const LandingComparisonSection(),

                    // 7. Interactive FAQs
                    Container(
                      key: _faqKey,
                      child: const LandingFaqSection(),
                    ),

                    // 8. Conversion CTA
                    const LandingCtaSection(),

                    // 9. Rich Footer
                    LandingFooter(
                      onFeaturesClick: () => _scrollToKey(_featuresKey),
                      onAiSuiteClick: () => _scrollToKey(_aiSuiteKey),
                      onTemplatesClick: () => _scrollToKey(_templatesKey),
                      onFaqClick: () => _scrollToKey(_faqKey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyBottomBar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0F172A).withValues(alpha: 0.96)
            : Colors.white.withValues(alpha: 0.96),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => context.push('/resumes/new'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Build My Resume Free'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileDrawer(BuildContext context, bool isDark, bool isAuthenticated) {
    return Drawer(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.auto_stories_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'ResumeForge',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            _drawerTile(
              icon: Icons.dashboard_customize_rounded,
              title: 'Resume Builder',
              onTap: () {
                Navigator.pop(context);
                _scrollToKey(_featuresKey);
              },
              isDark: isDark,
            ),
            _drawerTile(
              icon: Icons.auto_awesome_rounded,
              title: 'AI Career Suite',
              badge: 'PRO',
              onTap: () {
                Navigator.pop(context);
                _scrollToKey(_aiSuiteKey);
              },
              isDark: isDark,
            ),
            _drawerTile(
              icon: Icons.palette_outlined,
              title: 'ATS Templates (11+)',
              onTap: () {
                Navigator.pop(context);
                _scrollToKey(_templatesKey);
              },
              isDark: isDark,
            ),
            _drawerTile(
              icon: Icons.checklist_rounded,
              title: 'How It Works',
              onTap: () {
                Navigator.pop(context);
                _scrollToKey(_howItWorksKey);
              },
              isDark: isDark,
            ),
            _drawerTile(
              icon: Icons.help_outline_rounded,
              title: 'FAQs',
              onTap: () {
                Navigator.pop(context);
                _scrollToKey(_faqKey);
              },
              isDark: isDark,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (isAuthenticated) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          context.push('/dashboard');
                        },
                        icon: const Icon(Icons.dashboard_rounded, size: 18),
                        label: const Text('Go to Dashboard'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.push('/login');
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Sign In'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.push('/register');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Get Started Free'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerTile({
    required IconData icon,
    required String title,
    String? badge,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4F46E5), size: 22),
      title: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          if (badge != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: onTap,
    );
  }
}
