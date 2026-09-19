import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_card.dart';
import 'package:frontend_userside/core/widgets/app_text_field.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/education.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';
import 'package:frontend_userside/features/user/resume/presentation/widgets/add_item_button.dart';
import 'package:frontend_userside/features/user/resume/presentation/widgets/reorderable_section_list.dart';

class EducationForm extends ConsumerWidget {
  const EducationForm({super.key});

  void _addEducation(BuildContext context, WidgetRef ref) {
    final currentList = ref.read(activeResumeProvider)?.educations ?? [];
    final newEdu = Education(
      id: 'edu_${DateTime.now().millisecondsSinceEpoch}',
      degree: '',
      institution: '',
      location: '',
      startDate: '',
      endDate: '',
      gradeOrCgpa: '',
    );
    ref.read(activeResumeProvider.notifier).updateEducations([
      ...currentList,
      newEdu,
    ]);
  }

  void _updateEducation(WidgetRef ref, int index, Education updated) {
    final currentList = List<Education>.from(
      ref.read(activeResumeProvider)?.educations ?? [],
    );
    if (index >= 0 && index < currentList.length) {
      currentList[index] = updated;
      ref.read(activeResumeProvider.notifier).updateEducations(currentList);
    }
  }

  void _deleteEducation(WidgetRef ref, int index) {
    final currentList = List<Education>.from(
      ref.read(activeResumeProvider)?.educations ?? [],
    );
    if (index >= 0 && index < currentList.length) {
      currentList.removeAt(index);
      ref.read(activeResumeProvider.notifier).updateEducations(currentList);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resume = ref.watch(activeResumeProvider);
    final educations = resume?.educations ?? [];
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
                    'Education',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Degrees, universities, CGPA and academic achievements',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              Text(
                '${educations.length} records',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ReorderableSectionList<Education>(
            items: educations,
            emptyMessage: 'No education entries added yet. Click below to add.',
            onReorder: (oldIndex, newIndex) {
              final list = List<Education>.from(educations);
              if (newIndex > oldIndex) newIndex--;
              final item = list.removeAt(oldIndex);
              list.insert(newIndex, item);
              ref.read(activeResumeProvider.notifier).updateEducations(list);
            },
            itemBuilder: (context, index, edu) {
              return _EducationItemCard(
                edu: edu,
                onChanged: (updated) => _updateEducation(ref, index, updated),
                onDelete: () => _deleteEducation(ref, index),
              );
            },
          ),
          const SizedBox(height: 16),
          AddItemButton(
            label: 'Add Education Record',
            onPressed: () => _addEducation(context, ref),
          ),
        ],
      ),
    );
  }
}

class _EducationItemCard extends StatefulWidget {
  final Education edu;
  final ValueChanged<Education> onChanged;
  final VoidCallback onDelete;

  const _EducationItemCard({
    required this.edu,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<_EducationItemCard> createState() => _EducationItemCardState();
}

class _EducationItemCardState extends State<_EducationItemCard> {
  late final TextEditingController _degreeController;
  late final TextEditingController _institutionController;
  late final TextEditingController _locationController;
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;
  late final TextEditingController _gradeController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _degreeController = TextEditingController(text: widget.edu.degree);
    _institutionController = TextEditingController(
      text: widget.edu.institution,
    );
    _locationController = TextEditingController(text: widget.edu.location);
    _startDateController = TextEditingController(text: widget.edu.startDate);
    _endDateController = TextEditingController(text: widget.edu.endDate);
    _gradeController = TextEditingController(text: widget.edu.gradeOrCgpa);
    _descriptionController = TextEditingController(
      text: widget.edu.description ?? '',
    );
  }

  @override
  void dispose() {
    _degreeController.dispose();
    _institutionController.dispose();
    _locationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _gradeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _notify() {
    widget.onChanged(
      widget.edu.copyWith(
        degree: _degreeController.text.trim(),
        institution: _institutionController.text.trim(),
        location: _locationController.text.trim(),
        startDate: _startDateController.text.trim(),
        endDate: _endDateController.text.trim(),
        gradeOrCgpa: _gradeController.text.trim(),
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
                    widget.edu.degree.isNotEmpty
                        ? widget.edu.degree
                        : 'New Education Degree',
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
                tooltip: 'Delete Education',
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Degree / Major *',
            hint: 'B.S. in Computer Science',
            controller: _degreeController,
            onChanged: (_) => _notify(),
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Institution / University *',
            hint: 'University of California, Berkeley',
            controller: _institutionController,
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
                      hint: 'Aug 2016',
                      controller: _startDateController,
                      onChanged: (_) => _notify(),
                    ),
                  ),
                  SizedBox(
                    width: isWide
                        ? (constraints.maxWidth - 12) / 2
                        : constraints.maxWidth,
                    child: AppTextField(
                      label: 'End Date (or Expected)',
                      hint: 'May 2020',
                      controller: _endDateController,
                      onChanged: (_) => _notify(),
                    ),
                  ),
                ],
              );
            },
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
                      label: 'Location',
                      hint: 'Berkeley, CA',
                      controller: _locationController,
                      onChanged: (_) => _notify(),
                    ),
                  ),
                  SizedBox(
                    width: isWide
                        ? (constraints.maxWidth - 12) / 2
                        : constraints.maxWidth,
                    child: AppTextField(
                      label: 'Grade / CGPA',
                      hint: '3.85 GPA / Top 5%',
                      controller: _gradeController,
                      onChanged: (_) => _notify(),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Description / Honors (Optional)',
            hint: 'Relevant coursework, dean’s honors, clubs...',
            controller: _descriptionController,
            maxLines: 2,
            onChanged: (_) => _notify(),
          ),
        ],
      ),
    );
  }
}
