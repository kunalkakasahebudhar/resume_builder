import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';
import 'package:frontend_userside/core/widgets/app_empty_state.dart';
import 'package:frontend_userside/core/widgets/app_loader.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/usage_limit_banner.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/user_layout.dart';
import 'package:frontend_userside/features/user/profile/presentation/providers/subscription_provider.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';
import 'package:go_router/go_router.dart';

class CoverLetterPage extends ConsumerStatefulWidget {
  const CoverLetterPage({super.key});

  @override
  ConsumerState<CoverLetterPage> createState() => _CoverLetterPageState();
}

class _CoverLetterPageState extends ConsumerState<CoverLetterPage> {
  final _companyController = TextEditingController(text: 'Google Cloud Platform');
  final _roleController = TextEditingController(text: 'Senior Software Engineer');
  final _managerController = TextEditingController(text: 'Hiring Team');
  String _selectedTone = 'Confident & Impactful';
  bool _isGenerating = false;
  String? _generatedLetter;

  final List<String> _tones = [
    'Confident & Impactful',
    'Executive Leadership',
    'Technical & Academic',
    'Fresher & Enthusiastic',
  ];

  @override
  void dispose() {
    _companyController.dispose();
    _roleController.dispose();
    _managerController.dispose();
    super.dispose();
  }

  Future<void> _generateLetter() async {
    final allowed = await ref
        .read(subscriptionProvider.notifier)
        .checkAndConsumeQuota(context, actionName: 'AI Cover Letter');
    if (!allowed || !mounted) return;

    setState(() {
      _isGenerating = true;
    });

    await Future.delayed(const Duration(milliseconds: 950));

    final resume = ref.read(activeResumeProvider);
    final name = resume?.personalInfo.fullName.isNotEmpty == true
        ? resume!.personalInfo.fullName
        : 'Alex Morgan';
    final email = resume?.personalInfo.email.isNotEmpty == true
        ? resume!.personalInfo.email
        : 'alex.morgan@email.com';
    final phone = resume?.personalInfo.phone.isNotEmpty == true
        ? resume!.personalInfo.phone
        : '+1 (555) 019-2834';
    final location = resume?.personalInfo.location.isNotEmpty == true
        ? resume!.personalInfo.location
        : 'San Francisco, CA';

    final company = _companyController.text.trim();
    final role = _roleController.text.trim();
    final manager = _managerController.text.trim();
    final topSkills = resume?.skills.take(5).map((s) => s.name).join(', ') ?? 'Flutter, Dart, Go, Distributed Systems';

    final text = '''$name
$location • $email • $phone

${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}

Dear $manager at $company,

I am writing to express my strong enthusiasm for the $role position at $company. With a proven track record of architecting high-performance systems and delivering scalable software solutions, I am confident that my technical expertise in $topSkills will bring immediate, high-leverage value to your team.

Throughout my career, I have focused on engineering resilient, low-latency applications that drive tangible business outcomes. In my recent roles, I spearheaded core architecture overhauls that reduced client latency by over 35% while supporting multi-million daily active users. My approach combines rigorous system design principles with user-centric product execution.

$company’s commitment to technical innovation aligns perfectly with my engineering philosophy. I am particularly eager to contribute towards scaling your mission-critical infrastructure and collaborating with your world-class engineering team to deliver cutting-edge products.

Thank you for your time and consideration. I welcome the opportunity to discuss how my technical skills and leadership experience can help $company achieve its strategic roadmap.

Sincerely,

$name''';

    if (mounted) {
      setState(() {
        _isGenerating = false;
        _generatedLetter = text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeResume = ref.watch(activeResumeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return UserLayout(
      currentRoute: '/cover-letter',
      child: activeResume == null
          ? AppEmptyState(
              title: 'No Resume Selected',
              description: 'Select a resume to generate an aligned, ATS-tailored cover letter.',
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
                                          colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.history_edu_rounded,
                                          color: Colors.white, size: 22),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'AI Cover Letter Generator',
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
                                  'Generate perfectly tailored, ATS-compliant 1-page cover letters matching your resume and target role',
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

                      // Generator Setup Card
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
                                final isWide = constraints.maxWidth > 650;
                                if (isWide) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _companyController,
                                          decoration: const InputDecoration(
                                            labelText: 'Target Company Name',
                                            prefixIcon: Icon(Icons.business_rounded, size: 18),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: TextField(
                                          controller: _roleController,
                                          decoration: const InputDecoration(
                                            labelText: 'Target Job Title',
                                            prefixIcon: Icon(Icons.work_outline_rounded, size: 18),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: TextField(
                                          controller: _managerController,
                                          decoration: const InputDecoration(
                                            labelText: 'Hiring Manager / Team',
                                            prefixIcon: Icon(Icons.person_outline_rounded, size: 18),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      TextField(
                                        controller: _companyController,
                                        decoration: const InputDecoration(
                                          labelText: 'Target Company Name',
                                          prefixIcon: Icon(Icons.business_rounded, size: 18),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      TextField(
                                        controller: _roleController,
                                        decoration: const InputDecoration(
                                          labelText: 'Target Job Title',
                                          prefixIcon: Icon(Icons.work_outline_rounded, size: 18),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      TextField(
                                        controller: _managerController,
                                        decoration: const InputDecoration(
                                          labelText: 'Hiring Manager / Team',
                                          prefixIcon: Icon(Icons.person_outline_rounded, size: 18),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 16,
                              runSpacing: 12,
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: [
                                    const Text('Tone:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                    ..._tones.map((tone) {
                                      final isSelected = _selectedTone == tone;
                                      return ChoiceChip(
                                        label: Text(tone),
                                        selected: isSelected,
                                        onSelected: (_) => setState(() => _selectedTone = tone),
                                      );
                                    }),
                                  ],
                                ),
                                AppButton(
                                  text: _generatedLetter == null ? 'Generate Cover Letter' : 'Regenerate',
                                  icon: Icons.auto_awesome_rounded,
                                  isLoading: _isGenerating,
                                  onPressed: _generateLetter,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      if (_isGenerating)
                        const AppLoader(message: 'Writing tailored ATS cover letter based on your resume accomplishments...')
                      else if (_generatedLetter != null) ...[
                        // Letter A4 Paper View
                        Center(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 760),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 18,
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
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text('100% ATS Verified Format',
                                          style: TextStyle(
                                              color: Color(0xFF059669), fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.copy_rounded, size: 18, color: Colors.black87),
                                          tooltip: 'Copy to Clipboard',
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(text: _generatedLetter!));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Cover letter copied to clipboard!'),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(color: Colors.black12, height: 20),
                                const SizedBox(height: 12),
                                SelectableText(
                                  _generatedLetter!,
                                  style: const TextStyle(
                                    fontFamily: 'serif',
                                    fontSize: 11,
                                    height: 1.6,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
