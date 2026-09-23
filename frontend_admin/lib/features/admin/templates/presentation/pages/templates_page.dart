import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';
import 'package:frontend_admin/core/widgets/app_button.dart';
import 'package:frontend_admin/core/widgets/app_error.dart';
import 'package:frontend_admin/core/widgets/app_loader.dart';
import 'package:frontend_admin/features/admin/dashboard/presentation/widgets/admin_layout.dart';
import 'package:frontend_admin/features/admin/templates/presentation/providers/template_provider.dart';
import 'package:frontend_admin/features/admin/templates/presentation/widgets/template_card.dart';
import 'package:go_router/go_router.dart';

class TemplatesPage extends ConsumerWidget {
  const TemplatesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(templatesProvider);
    final notifier = ref.read(templatesProvider.notifier);

    return AdminLayout(
      title: 'ATS Resume Templates',
      currentPath: '/admin/templates',
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Bar with "Add Template"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Production Templates', style: AppTextStyles.h2()),
                    const SizedBox(height: 4),
                    Text(
                      'PRD-certified ATS parsing templates (Single Column, Strict Headings, Zero Table Layouts).',
                      style: AppTextStyles.bodySmall(),
                    ),
                  ],
                ),
                AppButton(
                  text: 'Add Template',
                  icon: const Icon(Icons.add, size: 18),
                  onPressed: () => context.go('/admin/templates/new'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Content Grid
            Expanded(
              child: state.isLoading
                  ? const AppLoader(message: 'Loading templates...')
                  : state.errorMessage != null
                  ? AppError(
                      message: state.errorMessage!,
                      onRetry: () => notifier.loadTemplates(),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        int count = 4;
                        if (constraints.maxWidth < 640) {
                          count = 1;
                        } else if (constraints.maxWidth < 1000) {
                          count = 2;
                        } else if (constraints.maxWidth < 1400) {
                          count = 3;
                        }

                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: count,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                mainAxisExtent: 410,
                              ),
                          itemCount: state.templates.length,
                          itemBuilder: (context, index) {
                            final template = state.templates[index];
                            return TemplateCard(
                              template: template,
                              onEdit: () =>
                                  context.go('/admin/templates/${template.id}'),
                              onPreview: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text(
                                      template.name,
                                      style: AppTextStyles.h3(),
                                    ),
                                    content: Text(
                                      '${template.description}\n\nCategory: ${template.category}\nStatus: ${template.status}\nTotal Resumes: ${template.usageCount}',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onStatusChange: (id, status) =>
                                  notifier.updateStatus(id, status),
                              onDelete: (id) => notifier.deleteTemplate(id),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
