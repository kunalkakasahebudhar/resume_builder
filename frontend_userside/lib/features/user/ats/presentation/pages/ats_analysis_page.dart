import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';
import 'package:frontend_userside/core/widgets/app_empty_state.dart';
import 'package:frontend_userside/core/widgets/app_loader.dart';
import 'package:frontend_userside/features/user/ats/presentation/providers/ats_provider.dart';
import 'package:frontend_userside/features/user/ats/presentation/widgets/ats_score_breakdown.dart';
import 'package:frontend_userside/features/user/ats/presentation/widgets/ats_score_card.dart';
import 'package:frontend_userside/features/user/ats/presentation/widgets/ats_suggestion.dart';
import 'package:frontend_userside/features/user/ats/presentation/widgets/ats_warning.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/user_layout.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';
import 'package:go_router/go_router.dart';

class AtsAnalysisPage extends ConsumerWidget {
  final String? resumeId;

  const AtsAnalysisPage({super.key, this.resumeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeResume = ref.watch(activeResumeProvider);
    final atsState = ref.watch(atsProvider);
    final theme = Theme.of(context);

    return UserLayout(
      currentRoute: '/ats',
      child: activeResume == null
          ? AppEmptyState(
              title: 'No Resume Selected',
              description:
                  'Select a resume to run the 100-point ATS Analyzer scan.',
              actionText: 'Go to My Resumes',
              onAction: () => context.go('/resumes'),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ATS Readability Analysis',
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Analyzing: ${activeResume.title}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          AppButton(
                            text: 'Re-Analyze',
                            icon: Icons.refresh_rounded,
                            isLoading: atsState.isAnalyzing,
                            onPressed: () => ref
                                .read(atsProvider.notifier)
                                .runAnalysis(activeResume.id),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (atsState.isAnalyzing)
                        const AppLoader(
                          message:
                              'Scanning resume against 100-point ATS benchmark...',
                        )
                      else if (atsState.analysis != null) ...[
                        AtsScoreCard(analysis: atsState.analysis!),
                        const SizedBox(height: 24),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth > 700;
                            if (isWide) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: AtsScoreBreakdown(
                                      analysis: atsState.analysis!,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      children: [
                                        AtsWarningList(
                                          warnings: atsState.analysis!.warnings,
                                        ),
                                        const SizedBox(height: 16),
                                        AtsSuggestionList(
                                          suggestions:
                                              atsState.analysis!.suggestions,
                                          detectedKeywords: atsState
                                              .analysis!
                                              .detectedKeywords,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  AtsScoreBreakdown(
                                    analysis: atsState.analysis!,
                                  ),
                                  const SizedBox(height: 16),
                                  AtsWarningList(
                                    warnings: atsState.analysis!.warnings,
                                  ),
                                  const SizedBox(height: 16),
                                  AtsSuggestionList(
                                    suggestions: atsState.analysis!.suggestions,
                                    detectedKeywords:
                                        atsState.analysis!.detectedKeywords,
                                  ),
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
