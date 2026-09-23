import 'package:flutter/material.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';

class ResumeFilter extends StatelessWidget {
  final String selectedTemplate;
  final String selectedScoreTier;
  final ValueChanged<String> onTemplateChanged;
  final ValueChanged<String> onScoreTierChanged;

  const ResumeFilter({
    super.key,
    required this.selectedTemplate,
    required this.selectedScoreTier,
    required this.onTemplateChanged,
    required this.onScoreTierChanged,
  });

  @override
  Widget build(BuildContext context) {
    final templates = [
      'All',
      'ATS Classic',
      'ATS Professional',
      'ATS Fresher',
      'ATS Experienced',
    ];
    final scoreTiers = ['All', 'High (80-100)', 'Medium (60-79)', 'Low (0-59)'];

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Template: ', style: AppTextStyles.label()),
            const SizedBox(width: 6),
            DropdownButton<String>(
              value: selectedTemplate,
              items: templates
                  .map(
                    (t) => DropdownMenuItem(
                      value: t,
                      child: Text(t, style: AppTextStyles.bodyMedium()),
                    ),
                  )
                  .toList(),
              onChanged: (val) => val != null ? onTemplateChanged(val) : null,
              underline: const SizedBox(),
            ),
          ],
        ),
        Container(width: 1, height: 24, color: AppColors.border(context)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('ATS Score: ', style: AppTextStyles.label()),
            const SizedBox(width: 6),
            DropdownButton<String>(
              value: selectedScoreTier,
              items: scoreTiers
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(s, style: AppTextStyles.bodyMedium()),
                    ),
                  )
                  .toList(),
              onChanged: (val) => val != null ? onScoreTierChanged(val) : null,
              underline: const SizedBox(),
            ),
          ],
        ),
      ],
    );
  }
}
