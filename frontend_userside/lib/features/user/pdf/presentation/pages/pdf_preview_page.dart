import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';
import 'package:frontend_userside/core/widgets/app_card.dart';
import 'package:frontend_userside/core/widgets/app_empty_state.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/user_layout.dart';
import 'package:frontend_userside/features/user/pdf/presentation/widgets/pdf_download_button.dart';
import 'package:frontend_userside/features/user/preview/presentation/widgets/resume_renderer.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';
import 'package:go_router/go_router.dart';

class PdfPreviewPage extends ConsumerWidget {
  final String? resumeId;

  const PdfPreviewPage({super.key, this.resumeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resume = ref.watch(activeResumeProvider);
    final theme = Theme.of(context);

    return UserLayout(
      currentRoute: '/pdf',
      child: resume == null
          ? AppEmptyState(
              title: 'No Resume Selected',
              description:
                  'Select a resume to export ATS-formatted PDF document.',
              actionText: 'Go to My Resumes',
              onAction: () => context.go('/resumes'),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 860),
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
                                'A4 PDF Export & Preview',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Formatted according to international standard A4 specs (210mm x 297mm)',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              AppButton(
                                text: 'Back to Editor',
                                type: ButtonType.outline,
                                icon: Icons.edit_note_rounded,
                                onPressed: () =>
                                    context.push('/resumes/${resume.id}'),
                              ),
                              const SizedBox(width: 12),
                              PdfDownloadButton(
                                resumeId: resume.id,
                                title: resume.title,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      AppCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              color: Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Ready for download: Standard ATS typography, selectable text, single-column margins, zero parser-blocking graphics.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ResumeRenderer(resume: resume, scale: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
