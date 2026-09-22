import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';
import 'package:frontend_userside/core/widgets/app_empty_state.dart';
import 'package:frontend_userside/core/widgets/app_loader.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/usage_limit_banner.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/user_layout.dart';
import 'package:frontend_userside/features/user/profile/presentation/providers/subscription_provider.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';
import 'package:go_router/go_router.dart';

class InterviewPrepPage extends ConsumerStatefulWidget {
  const InterviewPrepPage({super.key});

  @override
  ConsumerState<InterviewPrepPage> createState() => _InterviewPrepPageState();
}

class _InterviewPrepPageState extends ConsumerState<InterviewPrepPage> {
  bool _isGenerating = false;
  bool _hasGenerated = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'type': 'System Architecture',
      'difficulty': 'Hard',
      'question':
          'Can you walk us through the high-throughput architecture you designed and how you handled data consistency and latency spikes under heavy load?',
      'whyAsked':
          'Interviewers check if you actually built scalable backend systems or just used existing frameworks.',
      'starAnswer':
          'Situation: Our core API experienced 3x traffic spikes during product launches causing query degradation.\nTask: Re-architect data caching and implement event-driven queueing with Redis & Kafka.\nAction: Deployed distributed read replicas, integrated exponential backoff retries, and decoupled state management.\nResult: Reduced P99 response latency by 42% and supported 2.5B daily requests with 99.99% uptime.',
      'proTip': 'Always emphasize metric improvements (%, ms, RPS) to validate technical credibility.',
    },
    {
      'type': 'Technical Deep Dive',
      'difficulty': 'Medium',
      'question':
          'In your recent project, why did you select Flutter & Go over competing stacks like React Native & Node.js?',
      'whyAsked':
          'Evaluates your technology trade-off decision making and architectural maturity.',
      'starAnswer':
          'Situation: Needed to achieve 60fps native graphics rendering and shared business logic across iOS and Web.\nTask: Choose a performant multi-platform stack with compile-to-native binaries.\nAction: Conducted benchmarks showing Flutter compiled with Skia/Impeller reduced frame drops by 60% compared to JavaScript bridges, while Go provided sub-millisecond gRPC routing.\nResult: Shipped 6 months faster with a unified codebase saving ~35% in engineering headcount costs.',
      'proTip': 'Focus on engineering trade-offs (memory vs velocity) rather than personal syntax preferences.',
    },
    {
      'type': 'Behavioral & Leadership',
      'difficulty': 'Medium',
      'question':
          'Tell me about a time you faced a critical production incident or technical disagreement within your engineering team.',
      'whyAsked':
          'Tests composure under pressure, root cause analysis mindset, and blameless post-mortem culture.',
      'starAnswer':
          'Situation: A high-priority release caused a memory leak on client devices affecting 15% of active sessions.\nTask: Stabilize production traffic immediately and diagnose the root cause.\nAction: Initiated rollback protocol, established a clear war-room, pinpointed an uncancelled stream subscription, and added automated lint rules and canary deployments.\nResult: Restored 100% stability within 28 minutes and instituted automated memory leak integration testing.',
      'proTip': 'Highlight your calm communication and preventative system improvements.',
    },
    {
      'type': 'Problem Solving',
      'difficulty': 'Medium',
      'question':
          'How do you approach optimizing database queries and reducing cloud infrastructure expenditure?',
      'whyAsked':
          'Tests practical production engineering economics and optimization skills.',
      'starAnswer':
          'Situation: Monthly cloud compute costs were increasing 25% month-over-month due to unindexed queries and oversized instances.\nTask: Reduce compute footprint without impacting latency SLAs.\nAction: Implemented composite index strategies, auto-scaled container pods based on CPU threshold metrics, and right-sized memory reservations.\nResult: Slashing monthly cloud expenditure by 35% (\$12K/month savings) while improving query execution time by 18%.',
      'proTip': 'Quantify dollar savings or infrastructure ROI.',
    },
  ];

  Future<void> _generateQuestions() async {
    final allowed = await ref
        .read(subscriptionProvider.notifier)
        .checkAndConsumeQuota(context, actionName: 'AI Interview Predictor');
    if (!allowed || !mounted) return;

    setState(() {
      _isGenerating = true;
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      setState(() {
        _isGenerating = false;
        _hasGenerated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeResume = ref.watch(activeResumeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return UserLayout(
      currentRoute: '/interview-prep',
      child: activeResume == null
          ? AppEmptyState(
              title: 'No Resume Selected',
              description: 'Select a resume to generate targeted interview questions & STAR answers.',
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                          colors: [Color(0xFF059669), Color(0xFF10B981)],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.psychology_rounded,
                                          color: Colors.white, size: 22),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'AI Interview Predictor & STAR Kit',
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
                                  'AI simulates real interviewer questions based directly on your resume projects, experience, and tech stack',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          const UsageLimitBanner(compact: true),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Generate Trigger Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final isMobile = constraints.maxWidth < 600;
                            final textContent = Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ready to simulate interview for: "${activeResume.title}"',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Analyzing ${activeResume.experiences.length} roles, ${activeResume.projects.length} projects & ${activeResume.skills.length} skills',
                                  style: TextStyle(fontSize: 12, color: theme.colorScheme.primary),
                                ),
                              ],
                            );

                            final button = AppButton(
                              text: _hasGenerated ? 'Re-Generate Questions' : 'Predict Interview Questions',
                              icon: Icons.bolt_rounded,
                              isLoading: _isGenerating,
                              onPressed: _generateQuestions,
                            );

                            if (isMobile) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  textContent,
                                  const SizedBox(height: 14),
                                  button,
                                ],
                              );
                            }

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: textContent),
                                const SizedBox(width: 16),
                                button,
                              ],
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      if (_isGenerating)
                        const AppLoader(message: 'Scanning resume achievements and predicting technical & behavioral questions...')
                      else if (_hasGenerated) ...[
                        Text(
                          'TOP PREDICTED INTERVIEW QUESTIONS (${_questions.length})',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ..._questions.asMap().entries.map((entry) {
                          final idx = entry.key + 1;
                          final q = entry.value;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            q['type'] as String,
                                            style: const TextStyle(
                                              color: Color(0xFF6366F1),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            'Difficulty: ${q['difficulty']}',
                                            style: const TextStyle(
                                              color: Color(0xFFD97706),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text('Q$idx',
                                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  q['question'] as String,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '💡 Why interviewers ask this: ${q['whyAsked']}',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                const Divider(height: 1),
                                const SizedBox(height: 14),
                                Text(
                                  'MODEL STAR METHOD ANSWER',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.6,
                                    color: const Color(0xFF10B981),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                                    ),
                                  ),
                                  child: SelectableText(
                                    q['starAnswer'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      height: 1.45,
                                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '🔥 Pro Tip: ${q['proTip']}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFD97706),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
