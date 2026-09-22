import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';
import 'package:frontend_userside/core/widgets/app_dialog.dart';
import 'package:frontend_userside/core/widgets/app_empty_state.dart';
import 'package:frontend_userside/core/widgets/app_loader.dart';
import 'package:frontend_userside/core/widgets/app_text_field.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/resume_card.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/usage_limit_banner.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/user_layout.dart';
import 'package:frontend_userside/features/user/profile/presentation/providers/subscription_provider.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/resume.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';
import 'package:go_router/go_router.dart';

class MyResumesPage extends ConsumerStatefulWidget {
  const MyResumesPage({super.key});

  @override
  ConsumerState<MyResumesPage> createState() => _MyResumesPageState();
}

class _MyResumesPageState extends ConsumerState<MyResumesPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showCreateDialog() async {
    final allowed = await ref
        .read(subscriptionProvider.notifier)
        .checkAndConsumeQuota(context, actionName: 'Resume Creation');

    if (!allowed) return;

    if (!mounted) return;

    final titleController = TextEditingController(
      text: 'My ATS Professional Resume',
    );

    showDialog(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Create New ATS Resume',
        content: AppTextField(
          label: 'Resume Title',
          hint: 'e.g. Senior Software Engineer Resume',
          controller: titleController,
          autofocus: true,
        ),
        confirmText: 'Create Resume',
        onConfirm: () async {
          Navigator.of(ctx).pop();
          final newResume = await ref
              .read(resumesListProvider.notifier)
              .createResume(titleController.text.trim());
          if (newResume != null && mounted) {
            ref.read(activeResumeProvider.notifier).setResume(newResume);
            context.push('/resumes/${newResume.id}');
          }
        },
      ),
    );
  }

  void _showRenameDialog(Resume resume) {
    final titleController = TextEditingController(text: resume.title);

    showDialog(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Rename Resume',
        content: AppTextField(
          label: 'New Resume Title',
          controller: titleController,
          autofocus: true,
        ),
        confirmText: 'Save',
        onConfirm: () async {
          Navigator.of(ctx).pop();
          await ref
              .read(resumesListProvider.notifier)
              .renameResume(resume.id, titleController.text.trim());
        },
      ),
    );
  }

  void _showDeleteDialog(Resume resume) async {
    final confirmed = await AppDialog.showConfirmation(
      context: context,
      title: 'Delete Resume',
      message:
          'Are you sure you want to permanently delete "${resume.title}"? This action cannot be undone.',
      confirmText: 'Delete',
      isDestructive: true,
    );

    if (confirmed == true) {
      await ref.read(resumesListProvider.notifier).deleteResume(resume.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resume deleted successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(resumesListProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return UserLayout(
      currentRoute: '/resumes',
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 12,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Resumes',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage, duplicate, edit, and analyze your ATS resume portfolio',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                AppButton(
                  text: 'Create New Resume',
                  icon: Icons.add_rounded,
                  onPressed: _showCreateDialog,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const UsageLimitBanner(),
            const SizedBox(height: 16),
            // Search & Filter Bar
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;

                final searchField = SizedBox(
                  width: isWide ? 340 : constraints.maxWidth,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => ref
                        .read(resumesListProvider.notifier)
                        .setSearchQuery(val),
                    decoration: InputDecoration(
                      hintText: 'Search resumes by title or role...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                ref
                                    .read(resumesListProvider.notifier)
                                    .setSearchQuery('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                    ),
                  ),
                );

                final filterChips = Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text('All'),
                      selected: state.statusFilter == 'all',
                      onSelected: (_) => ref
                          .read(resumesListProvider.notifier)
                          .setStatusFilter('all'),
                    ),
                    ChoiceChip(
                      label: const Text('Completed'),
                      selected: state.statusFilter == 'completed',
                      onSelected: (_) => ref
                          .read(resumesListProvider.notifier)
                          .setStatusFilter('completed'),
                    ),
                    ChoiceChip(
                      label: const Text('Drafts'),
                      selected: state.statusFilter == 'draft',
                      onSelected: (_) => ref
                          .read(resumesListProvider.notifier)
                          .setStatusFilter('draft'),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: state.sortBy,
                          icon: const Icon(Icons.sort_rounded, size: 18),
                          items: const [
                            DropdownMenuItem(
                              value: 'recent',
                              child: Text(
                                'Sort: Recent',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'name',
                              child: Text(
                                'Sort: Name',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'score',
                              child: Text(
                                'Sort: ATS Score',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              ref
                                  .read(resumesListProvider.notifier)
                                  .setSortBy(val);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                );

                if (isWide) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [searchField, filterChips],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      searchField,
                      const SizedBox(height: 12),
                      filterChips,
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 24),
            // Resumes Grid
            Expanded(
              child: state.isLoading
                  ? const AppLoader(message: 'Loading resumes...')
                  : state.filteredResumes.isEmpty
                  ? AppEmptyState(
                      title: 'No resumes found',
                      description: state.searchQuery.isNotEmpty
                          ? 'No resumes matching "${state.searchQuery}"'
                          : 'Create your first ATS-ready resume to get started.',
                      actionText: 'Create Resume',
                      onAction: _showCreateDialog,
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 380,
                            mainAxisExtent: 210,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                      itemCount: state.filteredResumes.length,
                      itemBuilder: (context, index) {
                        final resume = state.filteredResumes[index];
                        return ResumeCard(
                          resume: resume,
                          onEdit: () {
                            ref
                                .read(activeResumeProvider.notifier)
                                .setResume(resume);
                            context.push('/resumes/${resume.id}');
                          },
                          onPreview: () {
                            ref
                                .read(activeResumeProvider.notifier)
                                .setResume(resume);
                            context.push('/preview');
                          },
                          onAnalyze: () {
                            ref
                                .read(activeResumeProvider.notifier)
                                .setResume(resume);
                            context.push('/ats');
                          },
                          onDuplicate: () async {
                            final allowed = await ref
                                 .read(subscriptionProvider.notifier)
                                 .checkAndConsumeQuota(context,
                                     actionName: 'Duplicate Resume');
                            if (!allowed) return;

                            final dup = await ref
                                .read(resumesListProvider.notifier)
                                .duplicateResume(resume.id);
                            if (!context.mounted) return;
                            if (dup != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Duplicated "${resume.title}"'),
                                ),
                              );
                            }
                          },
                          onRename: () => _showRenameDialog(resume),
                          onDownload: () {
                            ref
                                .read(activeResumeProvider.notifier)
                                .setResume(resume);
                            context.push('/pdf');
                          },
                          onDelete: () => _showDeleteDialog(resume),
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
