import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';
import 'package:frontend_userside/core/widgets/app_card.dart';
import 'package:frontend_userside/core/widgets/app_dropdown.dart';
import 'package:frontend_userside/core/widgets/app_text_field.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/language.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';

class LanguageForm extends ConsumerStatefulWidget {
  const LanguageForm({super.key});

  @override
  ConsumerState<LanguageForm> createState() => _LanguageFormState();
}

class _LanguageFormState extends ConsumerState<LanguageForm> {
  final _langController = TextEditingController();
  String _proficiency = 'Fluent';

  @override
  void dispose() {
    _langController.dispose();
    super.dispose();
  }

  void _addLanguage() {
    final text = _langController.text.trim();
    if (text.isEmpty) return;

    final currentLangs = ref.read(activeResumeProvider)?.languages ?? [];
    final exists = currentLangs.any(
      (l) => l.language.toLowerCase() == text.toLowerCase(),
    );
    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Language "$text" is already added')),
      );
      return;
    }

    final newLang = Language(
      id: 'lang_${DateTime.now().millisecondsSinceEpoch}',
      language: text,
      proficiency: _proficiency,
    );

    ref.read(activeResumeProvider.notifier).updateLanguages([
      ...currentLangs,
      newLang,
    ]);
    _langController.clear();
  }

  void _removeLanguage(String id) {
    final currentLangs = ref.read(activeResumeProvider)?.languages ?? [];
    ref
        .read(activeResumeProvider.notifier)
        .updateLanguages(currentLangs.where((l) => l.id != id).toList());
  }

  @override
  Widget build(BuildContext context) {
    final resume = ref.watch(activeResumeProvider);
    final languages = resume?.languages ?? [];
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
                      'Languages',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Spoken & written language proficiencies',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${languages.length} languages',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 500;
              final dropdown = AppDropdown<String>(
                label: 'Proficiency',
                value: _proficiency,
                items: const [
                  DropdownMenuItem(
                    value: 'Beginner',
                    child: Text('Beginner'),
                  ),
                  DropdownMenuItem(
                    value: 'Intermediate',
                    child: Text('Intermediate'),
                  ),
                  DropdownMenuItem(
                    value: 'Advanced',
                    child: Text('Advanced'),
                  ),
                  DropdownMenuItem(value: 'Fluent', child: Text('Fluent')),
                  DropdownMenuItem(value: 'Native', child: Text('Native')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _proficiency = val;
                    });
                  }
                },
              );

              final addButton = AppButton(
                text: 'Add',
                icon: Icons.add_rounded,
                height: 44,
                onPressed: _addLanguage,
              );

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: 'Language',
                      hint: 'e.g. English, Spanish, German',
                      controller: _langController,
                      onFieldSubmitted: (_) => _addLanguage(),
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
                      label: 'Language',
                      hint: 'e.g. English, Spanish, German',
                      controller: _langController,
                      onFieldSubmitted: (_) => _addLanguage(),
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
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          if (languages.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'No languages added yet.',
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
              children: languages.map((lang) {
                return Chip(
                  label: Text('${lang.language} • ${lang.proficiency}'),
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
                  onDeleted: () => _removeLanguage(lang.id),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
