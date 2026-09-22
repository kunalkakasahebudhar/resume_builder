import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';
import 'package:frontend_userside/core/widgets/app_card.dart';
import 'package:frontend_userside/core/widgets/app_dropdown.dart';
import 'package:frontend_userside/core/widgets/app_text_field.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/skill.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';

class SkillForm extends ConsumerStatefulWidget {
  const SkillForm({super.key});

  @override
  ConsumerState<SkillForm> createState() => _SkillFormState();
}

class _SkillFormState extends ConsumerState<SkillForm> {
  final _skillInputController = TextEditingController();
  SkillCategory _selectedCategory = SkillCategory.technical;

  @override
  void dispose() {
    _skillInputController.dispose();
    super.dispose();
  }

  void _addSkill() {
    final text = _skillInputController.text.trim();
    if (text.isEmpty) return;

    final currentSkills = ref.read(activeResumeProvider)?.skills ?? [];

    // Duplicate check
    final exists = currentSkills.any(
      (s) => s.name.toLowerCase() == text.toLowerCase(),
    );
    if (exists) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Skill "$text" is already added')));
      return;
    }

    final newSkill = Skill(
      id: 'sk_${DateTime.now().millisecondsSinceEpoch}',
      name: text,
      category: _selectedCategory,
    );

    ref.read(activeResumeProvider.notifier).updateSkills([
      ...currentSkills,
      newSkill,
    ]);
    _skillInputController.clear();
  }

  void _removeSkill(String id) {
    final currentSkills = ref.read(activeResumeProvider)?.skills ?? [];
    ref
        .read(activeResumeProvider.notifier)
        .updateSkills(currentSkills.where((s) => s.id != id).toList());
  }

  @override
  Widget build(BuildContext context) {
    final resume = ref.watch(activeResumeProvider);
    final skills = resume?.skills ?? [];
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(20),
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
                      'Skills & Technologies',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Categorized skills parsed by ATS keyword matchers',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${skills.length} added',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Input layout
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 500;
              final dropdown = AppDropdown<SkillCategory>(
                label: 'Category',
                value: _selectedCategory,
                items: const [
                  DropdownMenuItem(
                    value: SkillCategory.technical,
                    child: Text('Technical'),
                  ),
                  DropdownMenuItem(
                    value: SkillCategory.programmingLanguage,
                    child: Text('Languages'),
                  ),
                  DropdownMenuItem(
                    value: SkillCategory.framework,
                    child: Text('Frameworks'),
                  ),
                  DropdownMenuItem(
                    value: SkillCategory.database,
                    child: Text('Databases'),
                  ),
                  DropdownMenuItem(
                    value: SkillCategory.tool,
                    child: Text('Tools & DevOps'),
                  ),
                  DropdownMenuItem(
                    value: SkillCategory.softSkill,
                    child: Text('Soft Skills'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCategory = val;
                    });
                  }
                },
              );

              final addButton = AppButton(
                text: 'Add',
                icon: Icons.add_rounded,
                height: 44,
                onPressed: _addSkill,
              );

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: 'Add Skill Name',
                      hint: 'e.g. Flutter, Go, PostgreSQL, Docker',
                      controller: _skillInputController,
                      onFieldSubmitted: (_) => _addSkill(),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: dropdown),
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: addButton,
                        ),
                      ],
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 3,
                    child: AppTextField(
                      label: 'Add Skill Name',
                      hint: 'e.g. Flutter, Go, PostgreSQL, Docker',
                      controller: _skillInputController,
                      onFieldSubmitted: (_) => _addSkill(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: dropdown,
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: addButton,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),
          if (skills.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'No skills added yet. Add relevant keywords to boost your ATS rating.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((skill) {
                return Chip(
                  label: Text(skill.name),
                  labelStyle: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.08,
                  ),
                  side: BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => _removeSkill(skill.id),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
