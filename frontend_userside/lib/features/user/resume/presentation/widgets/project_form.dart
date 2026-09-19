import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_card.dart';
import 'package:frontend_userside/core/widgets/app_text_field.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/project.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';
import 'package:frontend_userside/features/user/resume/presentation/widgets/add_item_button.dart';
import 'package:frontend_userside/features/user/resume/presentation/widgets/reorderable_section_list.dart';

class ProjectForm extends ConsumerWidget {
  const ProjectForm({super.key});

  void _addProject(WidgetRef ref) {
    final currentList = ref.read(activeResumeProvider)?.projects ?? [];
    final newProj = Project(
      id: 'proj_${DateTime.now().millisecondsSinceEpoch}',
      projectName: '',
      description: '',
      technologies: '',
    );
    ref.read(activeResumeProvider.notifier).updateProjects([
      ...currentList,
      newProj,
    ]);
  }

  void _updateProject(WidgetRef ref, int index, Project updated) {
    final currentList = List<Project>.from(
      ref.read(activeResumeProvider)?.projects ?? [],
    );
    if (index >= 0 && index < currentList.length) {
      currentList[index] = updated;
      ref.read(activeResumeProvider.notifier).updateProjects(currentList);
    }
  }

  void _deleteProject(WidgetRef ref, int index) {
    final currentList = List<Project>.from(
      ref.read(activeResumeProvider)?.projects ?? [],
    );
    if (index >= 0 && index < currentList.length) {
      currentList.removeAt(index);
      ref.read(activeResumeProvider.notifier).updateProjects(currentList);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resume = ref.watch(activeResumeProvider);
    final projects = resume?.projects ?? [];
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(20),
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
                    'Projects',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Showcase notable software, engineering, and personal projects',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              Text(
                '${projects.length} projects',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ReorderableSectionList<Project>(
            items: projects,
            emptyMessage: 'No projects added yet. Click below to add.',
            onReorder: (oldIndex, newIndex) {
              final list = List<Project>.from(projects);
              if (newIndex > oldIndex) newIndex--;
              final item = list.removeAt(oldIndex);
              list.insert(newIndex, item);
              ref.read(activeResumeProvider.notifier).updateProjects(list);
            },
            itemBuilder: (context, index, proj) {
              return _ProjectItemCard(
                project: proj,
                onChanged: (updated) => _updateProject(ref, index, updated),
                onDelete: () => _deleteProject(ref, index),
              );
            },
          ),
          const SizedBox(height: 16),
          AddItemButton(
            label: 'Add Project',
            onPressed: () => _addProject(ref),
          ),
        ],
      ),
    );
  }
}

class _ProjectItemCard extends StatefulWidget {
  final Project project;
  final ValueChanged<Project> onChanged;
  final VoidCallback onDelete;

  const _ProjectItemCard({
    required this.project,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<_ProjectItemCard> createState() => _ProjectItemCardState();
}

class _ProjectItemCardState extends State<_ProjectItemCard> {
  late final TextEditingController _nameController;
  late final TextEditingController _roleController;
  late final TextEditingController _techController;
  late final TextEditingController _descController;
  late final TextEditingController _urlController;
  late final TextEditingController _githubController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project.projectName);
    _roleController = TextEditingController(text: widget.project.role);
    _techController = TextEditingController(text: widget.project.technologies);
    _descController = TextEditingController(text: widget.project.description);
    _urlController = TextEditingController(
      text: widget.project.projectUrl ?? '',
    );
    _githubController = TextEditingController(
      text: widget.project.githubUrl ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _techController.dispose();
    _descController.dispose();
    _urlController.dispose();
    _githubController.dispose();
    super.dispose();
  }

  void _notify() {
    widget.onChanged(
      widget.project.copyWith(
        projectName: _nameController.text.trim(),
        role: _roleController.text.trim(),
        technologies: _techController.text.trim(),
        description: _descController.text.trim(),
        projectUrl: _urlController.text.trim(),
        githubUrl: _githubController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.5),
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
                  const Icon(
                    Icons.drag_indicator_rounded,
                    size: 18,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.project.projectName.isNotEmpty
                        ? widget.project.projectName
                        : 'New Project',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: Colors.red,
                ),
                onPressed: widget.onDelete,
                tooltip: 'Delete Project',
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Project Name *',
            hint: 'e.g. ResumeForge',
            controller: _nameController,
            onChanged: (_) => _notify(),
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Technologies Used *',
            hint: 'e.g. Flutter, Riverpod, Go, Gin, PostgreSQL',
            controller: _techController,
            onChanged: (_) => _notify(),
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Project Description *',
            hint:
                'Engineered a scalable platform with real-time parser scoring...',
            controller: _descController,
            maxLines: 3,
            onChanged: (_) => _notify(),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 400;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: isWide
                        ? (constraints.maxWidth - 12) / 2
                        : constraints.maxWidth,
                    child: AppTextField(
                      label: 'Live Project URL',
                      hint: 'https://...',
                      controller: _urlController,
                      onChanged: (_) => _notify(),
                    ),
                  ),
                  SizedBox(
                    width: isWide
                        ? (constraints.maxWidth - 12) / 2
                        : constraints.maxWidth,
                    child: AppTextField(
                      label: 'GitHub URL',
                      hint: 'https://github.com/...',
                      controller: _githubController,
                      onChanged: (_) => _notify(),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
