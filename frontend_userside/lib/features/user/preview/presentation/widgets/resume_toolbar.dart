import 'package:flutter/material.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';

class ResumeToolbar extends StatelessWidget {
  final double scale;
  final ValueChanged<double> onScaleChanged;
  final VoidCallback onDownloadPdf;
  final VoidCallback onSelectTemplate;
  final VoidCallback onAnalyzeAts;

  const ResumeToolbar({
    super.key,
    required this.scale,
    required this.onScaleChanged,
    required this.onDownloadPdf,
    required this.onSelectTemplate,
    required this.onAnalyzeAts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Zoom Controls
          IconButton(
            icon: const Icon(Icons.zoom_out_rounded, size: 20),
            tooltip: 'Zoom Out',
            onPressed: scale > 0.6
                ? () => onScaleChanged((scale - 0.1).clamp(0.5, 1.5))
                : null,
          ),
          Text(
            '${(scale * 100).toInt()}%',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.zoom_in_rounded, size: 20),
            tooltip: 'Zoom In',
            onPressed: scale < 1.4
                ? () => onScaleChanged((scale + 0.1).clamp(0.5, 1.5))
                : null,
          ),
          const Spacer(),
          AppButton(
            text: 'Templates',
            icon: Icons.palette_outlined,
            type: ButtonType.outline,
            height: 36,
            onPressed: onSelectTemplate,
          ),
          const SizedBox(width: 8),
          AppButton(
            text: 'ATS Score',
            icon: Icons.analytics_outlined,
            type: ButtonType.outline,
            height: 36,
            onPressed: onAnalyzeAts,
          ),
          const SizedBox(width: 8),
          AppButton(
            text: 'Export PDF',
            icon: Icons.picture_as_pdf_outlined,
            height: 36,
            onPressed: onDownloadPdf,
          ),
        ],
      ),
    );
  }
}
