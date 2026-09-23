import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/core/widgets/app_error.dart';
import 'package:frontend_admin/core/widgets/app_loader.dart';
import 'package:frontend_admin/features/admin/dashboard/presentation/widgets/admin_layout.dart';
import 'package:frontend_admin/features/admin/resumes/presentation/providers/admin_resumes_provider.dart';
import 'package:frontend_admin/features/admin/resumes/presentation/widgets/resume_filter.dart';
import 'package:frontend_admin/features/admin/resumes/presentation/widgets/resume_search_bar.dart';
import 'package:frontend_admin/features/admin/resumes/presentation/widgets/resume_table.dart';

class AdminResumesPage extends ConsumerWidget {
  const AdminResumesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumesState = ref.watch(adminResumesProvider);
    final resumesNotifier = ref.read(adminResumesProvider.notifier);

    return AdminLayout(
      title: 'Resume Documents Management',
      currentPath: '/admin/resumes',
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter & Search Controls Card
            Card(
              elevation: 0,
              color: AppColors.card(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: AppColors.border(context)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 780) {
                      return Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: ResumeSearchBar(
                              onChanged: (q) =>
                                  resumesNotifier.setSearchQuery(q),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ResumeFilter(
                            selectedTemplate: resumesState.selectedTemplate,
                            selectedScoreTier: resumesState.selectedScoreTier,
                            onTemplateChanged: (t) =>
                                resumesNotifier.setTemplateFilter(t),
                            onScoreTierChanged: (s) =>
                                resumesNotifier.setScoreTierFilter(s),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ResumeSearchBar(
                            onChanged: (q) => resumesNotifier.setSearchQuery(q),
                          ),
                          const SizedBox(height: 12),
                          ResumeFilter(
                            selectedTemplate: resumesState.selectedTemplate,
                            selectedScoreTier: resumesState.selectedScoreTier,
                            onTemplateChanged: (t) =>
                                resumesNotifier.setTemplateFilter(t),
                            onScoreTierChanged: (s) =>
                                resumesNotifier.setScoreTierFilter(s),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Table Content
            Expanded(
              child: Card(
                elevation: 0,
                color: AppColors.card(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors.border(context)),
                ),
                child: resumesState.isLoading
                    ? const AppLoader(message: 'Loading resumes...')
                    : resumesState.errorMessage != null
                    ? AppError(
                        message: resumesState.errorMessage!,
                        onRetry: () => resumesNotifier.loadResumes(),
                      )
                    : ResumeTable(
                        resumes: resumesState.resumes,
                        onDelete: (id) => resumesNotifier.deleteResume(id),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
