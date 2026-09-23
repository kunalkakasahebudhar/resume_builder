import 'package:flutter/material.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';

class TemplatePreview extends StatelessWidget {
  final String category;
  final String accentColorHex;

  const TemplatePreview({
    super.key,
    required this.category,
    required this.accentColorHex,
  });

  @override
  Widget build(BuildContext context) {
    Color accentColor = AppColors.primary;
    try {
      final hex = accentColorHex.replaceAll('#', '');
      accentColor = Color(int.parse('FF$hex', radix: 16));
    } catch (_) {}

    return Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(bottom: BorderSide(color: AppColors.border(context))),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mock Resume Header
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 90,
                        height: 8,
                        color: AppColors.textPrimary(context),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 60,
                        height: 5,
                        color: AppColors.textMuted(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(height: 1.5, color: accentColor.withValues(alpha: 0.4)),
            const SizedBox(height: 8),

            // Mock Resume Sections
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 50, height: 6, color: accentColor),
                      const SizedBox(height: 4),
                      Container(
                        width: 100,
                        height: 4,
                        color: AppColors.border(context),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        width: 85,
                        height: 4,
                        color: AppColors.border(context),
                      ),
                      const SizedBox(height: 8),
                      Container(width: 45, height: 6, color: accentColor),
                      const SizedBox(height: 4),
                      Container(
                        width: 95,
                        height: 4,
                        color: AppColors.border(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 35, height: 6, color: accentColor),
                      const SizedBox(height: 4),
                      Container(
                        width: 45,
                        height: 4,
                        color: AppColors.border(context),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        width: 40,
                        height: 4,
                        color: AppColors.border(context),
                      ),
                      const SizedBox(height: 8),
                      Container(width: 30, height: 6, color: accentColor),
                      const SizedBox(height: 4),
                      Container(
                        width: 35,
                        height: 4,
                        color: AppColors.border(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
