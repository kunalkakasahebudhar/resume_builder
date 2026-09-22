import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_empty_state.dart';
import 'package:frontend_userside/core/widgets/app_error_state.dart';
import 'package:frontend_userside/core/widgets/app_loader.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/usage_limit_banner.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/user_layout.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';
import 'package:frontend_userside/features/user/templates/presentation/providers/template_provider.dart';
import 'package:frontend_userside/features/user/templates/presentation/widgets/template_card.dart';
import 'package:frontend_userside/features/user/templates/presentation/widgets/template_preview.dart';
import 'package:go_router/go_router.dart';

class TemplateSelectionPage extends ConsumerWidget {
  const TemplateSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesState = ref.watch(templatesProvider);
    final activeResume = ref.watch(activeResumeProvider);
    final theme = Theme.of(context);

    return UserLayout(
      currentRoute: '/templates',
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                      Text(
                        'ATS-Friendly Templates',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '11 high-performing, parser-certified layouts (Harvard, Tech Minimal, Executive, Quant & more)',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const UsageLimitBanner(compact: true),
              ],
            ),
            const SizedBox(height: 16),
            // Category Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  'All',
                  'Ivy League',
                  'Tech & FAANG',
                  'Modern Clean',
                  'Executive',
                  'FinTech & Quant',
                  '1-Page Compact',
                  'Academic',
                  'Corporate',
                  'Fresher',
                  'Experienced',
                  'Classic',
                ].map((category) {
                  final isSelected = templatesState.selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) {
                        ref
                            .read(templatesProvider.notifier)
                            .setSelectedCategory(category);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: templatesState.isLoading
                  ? const AppLoader(message: 'Loading templates...')
                  : templatesState.error != null
                  ? AppErrorState(
                      message: templatesState.error!,
                      onRetry: () =>
                          ref.read(templatesProvider.notifier).loadTemplates(),
                    )
                  : templatesState.filteredTemplates.isEmpty
                  ? const AppEmptyState(
                      title: 'No templates found',
                      description: 'Try choosing a different category',
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 360,
                            mainAxisExtent: 390,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                      itemCount: templatesState.filteredTemplates.length,
                      itemBuilder: (context, index) {
                        final template =
                            templatesState.filteredTemplates[index];
                        final isSelected =
                            activeResume?.templateId == template.id;

                        return TemplateCard(
                          template: template,
                          isSelected: isSelected,
                          onSelect: () {
                            ref
                                .read(activeResumeProvider.notifier)
                                .setTemplateId(template.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Selected ${template.name} for current resume',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                            if (activeResume != null) {
                              context.push('/preview');
                            }
                          },
                          onPreview: () {
                            showDialog(
                              context: context,
                              builder: (_) => TemplatePreviewDialog(
                                template: template,
                                onSelect: () {
                                  ref
                                      .read(activeResumeProvider.notifier)
                                      .setTemplateId(template.id);
                                },
                              ),
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
