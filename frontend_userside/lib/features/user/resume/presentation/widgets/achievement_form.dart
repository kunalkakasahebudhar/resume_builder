import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_card.dart';
import 'package:frontend_userside/core/widgets/app_text_field.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/achievement.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';
import 'package:frontend_userside/features/user/resume/presentation/widgets/add_item_button.dart';
import 'package:frontend_userside/features/user/resume/presentation/widgets/reorderable_section_list.dart';

class AchievementForm extends ConsumerWidget {
  const AchievementForm({super.key});

  void _addAchievement(WidgetRef ref) {
    final currentList = ref.read(activeResumeProvider)?.achievements ?? [];
    final newAch = Achievement(
      id: 'ach_${DateTime.now().millisecondsSinceEpoch}',
      title: '',
      description: '',
      date: '',
    );
    ref.read(activeResumeProvider.notifier).updateAchievements([
      ...currentList,
      newAch,
    ]);
  }

  void _updateAchievement(WidgetRef ref, int index, Achievement updated) {
    final currentList = List<Achievement>.from(
      ref.read(activeResumeProvider)?.achievements ?? [],
    );
    if (index >= 0 && index < currentList.length) {
      currentList[index] = updated;
      ref.read(activeResumeProvider.notifier).updateAchievements(currentList);
    }
  }

  void _deleteAchievement(WidgetRef ref, int index) {
    final currentList = List<Achievement>.from(
      ref.read(activeResumeProvider)?.achievements ?? [],
    );
    if (index >= 0 && index < currentList.length) {
      currentList.removeAt(index);
      ref.read(activeResumeProvider.notifier).updateAchievements(currentList);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resume = ref.watch(activeResumeProvider);
    final achievements = resume?.achievements ?? [];
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
                      'Key Honors & Achievements',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Awards, hackathon wins, scholarships, and competition recognitions',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${achievements.length} achievements',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ReorderableSectionList<Achievement>(
            items: achievements,
            emptyMessage: 'No achievements added yet. Click below to add.',
            onReorder: (oldIndex, newIndex) {
              final list = List<Achievement>.from(achievements);
              if (newIndex > oldIndex) newIndex--;
              final item = list.removeAt(oldIndex);
              list.insert(newIndex, item);
              ref.read(activeResumeProvider.notifier).updateAchievements(list);
            },
            itemBuilder: (context, index, ach) {
              return _AchievementItemCard(
                ach: ach,
                onChanged: (updated) => _updateAchievement(ref, index, updated),
                onDelete: () => _deleteAchievement(ref, index),
              );
            },
          ),
          const SizedBox(height: 16),
          AddItemButton(
            label: 'Add Honor / Achievement',
            onPressed: () => _addAchievement(ref),
          ),
        ],
      ),
    );
  }
}

class _AchievementItemCard extends StatefulWidget {
  final Achievement ach;
  final ValueChanged<Achievement> onChanged;
  final VoidCallback onDelete;

  const _AchievementItemCard({
    required this.ach,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<_AchievementItemCard> createState() => _AchievementItemCardState();
}

class _AchievementItemCardState extends State<_AchievementItemCard> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.ach.title);
    _descController = TextEditingController(text: widget.ach.description);
    _dateController = TextEditingController(text: widget.ach.date);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _notify() {
    widget.onChanged(
      widget.ach.copyWith(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        date: _dateController.text.trim(),
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
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.drag_indicator_rounded,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.ach.title.isNotEmpty
                            ? widget.ach.title
                            : 'New Achievement',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: Colors.red,
                ),
                onPressed: widget.onDelete,
                tooltip: 'Delete Achievement',
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Achievement Title *',
            hint: '1st Place Winner - Bay Area Tech Hackathon',
            controller: _titleController,
            onChanged: (_) => _notify(),
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Date (Optional)',
            hint: 'Nov 2023',
            controller: _dateController,
            onChanged: (_) => _notify(),
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Description',
            hint:
                'Awarded top prize among 60 teams for developing an automated accessibility audit tool.',
            controller: _descController,
            maxLines: 2,
            onChanged: (_) => _notify(),
          ),
        ],
      ),
    );
  }
}
