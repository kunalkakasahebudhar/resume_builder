import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_card.dart';
import 'package:frontend_userside/core/widgets/app_dropdown.dart';
import 'package:frontend_userside/core/widgets/app_text_field.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/experience.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';
import 'package:frontend_userside/features/user/resume/presentation/widgets/add_item_button.dart';
import 'package:frontend_userside/features/user/resume/presentation/widgets/reorderable_section_list.dart';

class ExperienceForm extends ConsumerWidget {
  const ExperienceForm({super.key});

  void _addExperience(BuildContext context, WidgetRef ref) {
    final currentList = ref.read(activeResumeProvider)?.experiences ?? [];
    final newExp = Experience(
      id: 'exp_${DateTime.now().millisecondsSinceEpoch}',
      jobTitle: '',
      company: '',
      location: '',
      employmentType: 'Full-time',
      startDate: '',
      endDate: '',
      description: '',
    );
    ref.read(activeResumeProvider.notifier).updateExperiences([
      ...currentList,
      newExp,
    ]);
  }

  void _updateExperience(WidgetRef ref, int index, Experience updated) {
    final currentList = List<Experience>.from(
      ref.read(activeResumeProvider)?.experiences ?? [],
    );
    if (index >= 0 && index < currentList.length) {
      currentList[index] = updated;
      ref.read(activeResumeProvider.notifier).updateExperiences(currentList);
    }
  }

  void _deleteExperience(WidgetRef ref, int index) {
    final currentList = List<Experience>.from(
      ref.read(activeResumeProvider)?.experiences ?? [],
    );
    if (index >= 0 && index < currentList.length) {
      currentList.removeAt(index);
      ref.read(activeResumeProvider.notifier).updateExperiences(currentList);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resume = ref.watch(activeResumeProvider);
    final experiences = resume?.experiences ?? [];
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
                    'Work Experience',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Positions, roles, accomplishments, and quantifiable bullet points',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              Text(
                '${experiences.length} roles',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ReorderableSectionList<Experience>(
            items: experiences,
            emptyMessage:
                'No experience entries added yet. Click below to add.',
            onReorder: (oldIndex, newIndex) {
              final list = List<Experience>.from(experiences);
              if (newIndex > oldIndex) newIndex--;
              final item = list.removeAt(oldIndex);
              list.insert(newIndex, item);
              ref.read(activeResumeProvider.notifier).updateExperiences(list);
            },
            itemBuilder: (context, index, exp) {
              return _ExperienceItemCard(
                exp: exp,
                onChanged: (updated) => _updateExperience(ref, index, updated),
                onDelete: () => _deleteExperience(ref, index),
              );
            },
          ),
          const SizedBox(height: 16),
          AddItemButton(
            label: 'Add Work Experience',
            onPressed: () => _addExperience(context, ref),
          ),
        ],
      ),
    );
  }
}

class _ExperienceItemCard extends StatefulWidget {
  final Experience exp;
  final ValueChanged<Experience> onChanged;
  final VoidCallback onDelete;

  const _ExperienceItemCard({
    required this.exp,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<_ExperienceItemCard> createState() => _ExperienceItemCardState();
}

class _ExperienceItemCardState extends State<_ExperienceItemCard> {
  late final TextEditingController _titleController;
  late final TextEditingController _companyController;
  late final TextEditingController _locationController;
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;
  late final TextEditingController _descriptionController;
  late String _employmentType;
  late bool _isCurrentlyWorking;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.exp.jobTitle);
    _companyController = TextEditingController(text: widget.exp.company);
    _locationController = TextEditingController(text: widget.exp.location);
    _startDateController = TextEditingController(text: widget.exp.startDate);
    _endDateController = TextEditingController(text: widget.exp.endDate);
    _descriptionController = TextEditingController(
      text: widget.exp.description,
    );
    _employmentType = widget.exp.employmentType;
    _isCurrentlyWorking = widget.exp.isCurrentlyWorking;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _notify() {
    widget.onChanged(
      widget.exp.copyWith(
        jobTitle: _titleController.text.trim(),
        company: _companyController.text.trim(),
        location: _locationController.text.trim(),
        employmentType: _employmentType,
        startDate: _startDateController.text.trim(),
        endDate: _endDateController.text.trim(),
        isCurrentlyWorking: _isCurrentlyWorking,
        description: _descriptionController.text.trim(),
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
                    widget.exp.jobTitle.isNotEmpty
                        ? widget.exp.jobTitle
                        : 'New Position',
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
                tooltip: 'Delete Position',
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Job Title *',
            hint: 'Senior Software Engineer',
            controller: _titleController,
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
                      label: 'Company Name *',
                      hint: 'Acme Corp',
                      controller: _companyController,
                      onChanged: (_) => _notify(),
                    ),
                  ),
                  SizedBox(
                    width: isWide
                        ? (constraints.maxWidth - 12) / 2
                        : constraints.maxWidth,
                    child: AppDropdown<String>(
                      label: 'Employment Type',
                      value: _employmentType,
                      items: const [
                        DropdownMenuItem(
                          value: 'Full-time',
                          child: Text('Full-time'),
                        ),
                        DropdownMenuItem(
                          value: 'Part-time',
                          child: Text('Part-time'),
                        ),
                        DropdownMenuItem(
                          value: 'Contract',
                          child: Text('Contract'),
                        ),
                        DropdownMenuItem(
                          value: 'Internship',
                          child: Text('Internship'),
                        ),
                        DropdownMenuItem(
                          value: 'Freelance',
                          child: Text('Freelance'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _employmentType = val;
                          });
                          _notify();
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Location',
            hint: 'San Francisco, CA or Remote',
            controller: _locationController,
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
                      label: 'Start Date',
                      hint: 'Jun 2022',
                      controller: _startDateController,
                      onChanged: (_) => _notify(),
                    ),
                  ),
                  SizedBox(
                    width: isWide
                        ? (constraints.maxWidth - 12) / 2
                        : constraints.maxWidth,
                    child: AppTextField(
                      label: 'End Date',
                      hint: 'Present',
                      controller: _endDateController,
                      readOnly: _isCurrentlyWorking,
                      onChanged: (_) => _notify(),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: _isCurrentlyWorking,
                  onChanged: (val) {
                    setState(() {
                      _isCurrentlyWorking = val ?? false;
                      if (_isCurrentlyWorking) {
                        _endDateController.text = 'Present';
                      }
                    });
                    _notify();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'I currently work in this role',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Key Responsibilities & Achievements (Use • bullet points)',
            hint:
                '• Architected RESTful microservices...\n• Reduced latency by 40% via Redis...',
            controller: _descriptionController,
            maxLines: 4,
            onChanged: (_) => _notify(),
          ),
        ],
      ),
    );
  }
}
