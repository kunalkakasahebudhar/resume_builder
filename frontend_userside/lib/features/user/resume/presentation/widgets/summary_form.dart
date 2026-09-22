import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_card.dart';
import 'package:frontend_userside/core/widgets/app_text_field.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';

import 'package:frontend_userside/features/user/tools/presentation/widgets/ai_bullet_rewriter_dialog.dart';

class SummaryForm extends ConsumerStatefulWidget {
  const SummaryForm({super.key});

  @override
  ConsumerState<SummaryForm> createState() => _SummaryFormState();
}

class _SummaryFormState extends ConsumerState<SummaryForm> {
  late final TextEditingController _summaryController;

  @override
  void initState() {
    super.initState();
    final summary = ref.read(activeResumeProvider)?.summary ?? '';
    _summaryController = TextEditingController(text: summary);
  }

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  void _onChanged() {
    ref
        .read(activeResumeProvider.notifier)
        .updateSummary(_summaryController.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Text(
                'Professional Summary',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              InkWell(
                onTap: () async {
                  final result = await AiBulletRewriterDialog.show(
                    context,
                    initialText: _summaryController.text,
                  );
                  if (result != null && result.isNotEmpty) {
                    setState(() {
                      _summaryController.text = result;
                    });
                    _onChanged();
                  }
                },
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 14,
                        color: Color(0xFF6366F1),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'AI Summary Enhancer',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Summarize your career highlights, domain expertise, and core value proposition in 2-4 sentences.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 18),
          AppTextField(
            label: 'Summary / Career Objective',
            hint:
                'Experienced engineer with expertise in building scalable cloud services...',
            controller: _summaryController,
            maxLines: 6,
            onChanged: (_) => _onChanged(),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: theme.colorScheme.primary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'ATS Tip: Mention your total years of experience, core tech stack, and a notable quantifiable result.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
