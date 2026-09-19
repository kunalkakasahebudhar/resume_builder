import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_empty_state.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/user_layout.dart';
import 'package:frontend_userside/features/user/preview/presentation/widgets/resume_page_view.dart';
import 'package:frontend_userside/features/user/preview/presentation/widgets/resume_toolbar.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';
import 'package:go_router/go_router.dart';

class ResumePreviewPage extends ConsumerStatefulWidget {
  final String? resumeId;

  const ResumePreviewPage({super.key, this.resumeId});

  @override
  ConsumerState<ResumePreviewPage> createState() => _ResumePreviewPageState();
}

class _ResumePreviewPageState extends ConsumerState<ResumePreviewPage> {
  double _scale = 0.85;

  @override
  void initState() {
    super.initState();
    if (widget.resumeId != null) {
      ref.read(activeResumeProvider.notifier).loadResume(widget.resumeId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final resume = ref.watch(activeResumeProvider);
    final theme = Theme.of(context);

    return UserLayout(
      currentRoute: '/preview',
      child: resume == null
          ? AppEmptyState(
              title: 'No Resume Selected',
              description:
                  'Please select or create a resume to view live ATS preview',
              actionText: 'Go to My Resumes',
              onAction: () => context.go('/resumes'),
            )
          : Container(
              color: theme.scaffoldBackgroundColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: ResumeToolbar(
                      scale: _scale,
                      onScaleChanged: (newScale) {
                        setState(() {
                          _scale = newScale;
                        });
                      },
                      onSelectTemplate: () => context.push('/templates'),
                      onAnalyzeAts: () => context.push('/ats'),
                      onDownloadPdf: () => context.push('/pdf'),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: theme.brightness == Brightness.dark
                          ? const Color(0xFF090D16)
                          : const Color(0xFFE2E8F0),
                      child: ResumePageView(resume: resume, scale: _scale),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
