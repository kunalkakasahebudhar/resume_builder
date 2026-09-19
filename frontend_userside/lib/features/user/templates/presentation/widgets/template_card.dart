import 'package:flutter/material.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';
import 'package:frontend_userside/features/user/templates/domain/entities/resume_template.dart';

class TemplateCard extends StatelessWidget {
  final ResumeTemplate template;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback? onPreview;

  const TemplateCard({
    super.key,
    required this.template,
    this.isSelected = false,
    required this.onSelect,
    this.onPreview,
  });

  Widget _buildWireframe(BuildContext context, bool isDark) {
    switch (template.id) {
      case 'ats_classic':
        return Column(
          children: [
            Center(
              child: Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 3),
            Center(
              child: Container(
                width: 40,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF94A3B8),
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Container(height: 1, color: const Color(0xFFCBD5E1)),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 45,
                height: 3,
                color: const Color(0xFF4F46E5),
              ),
            ),
            const SizedBox(height: 3),
            Container(
              width: double.infinity,
              height: 2.5,
              color: const Color(0xFFE2E8F0),
            ),
            const SizedBox(height: 2),
            Container(
              width: double.infinity,
              height: 2.5,
              color: const Color(0xFFE2E8F0),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 50,
                height: 3,
                color: const Color(0xFF4F46E5),
              ),
            ),
            const SizedBox(height: 3),
            Container(
              width: double.infinity,
              height: 2.5,
              color: const Color(0xFFE2E8F0),
            ),
          ],
        );
      case 'ats_professional':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 4,
                    color: const Color(0xFFF8FAFC),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: 35,
                    height: 2.5,
                    color: const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Container(width: 45, height: 3, color: const Color(0xFF4F46E5)),
            const SizedBox(height: 3),
            Container(
              width: double.infinity,
              height: 2.5,
              color: const Color(0xFFE2E8F0),
            ),
            const SizedBox(height: 2),
            Container(
              width: double.infinity,
              height: 2.5,
              color: const Color(0xFFE2E8F0),
            ),
            const SizedBox(height: 6),
            Container(width: 55, height: 3, color: const Color(0xFF4F46E5)),
            const SizedBox(height: 3),
            Container(
              width: double.infinity,
              height: 2.5,
              color: const Color(0xFFE2E8F0),
            ),
          ],
        );
      case 'ats_fresher':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 55, height: 5, color: const Color(0xFF1E293B)),
            const SizedBox(height: 2),
            Container(width: 40, height: 3, color: const Color(0xFF94A3B8)),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              height: 1,
              color: const Color(0xFF4F46E5),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Container(width: 30, height: 3, color: const Color(0xFF10B981)),
                const SizedBox(width: 4),
                Container(width: 25, height: 3, color: const Color(0xFFCBD5E1)),
              ],
            ),
            const SizedBox(height: 3),
            Container(
              width: double.infinity,
              height: 2.5,
              color: const Color(0xFFE2E8F0),
            ),
            const SizedBox(height: 5),
            Container(width: 45, height: 3, color: const Color(0xFF4F46E5)),
            const SizedBox(height: 3),
            Container(
              width: double.infinity,
              height: 2.5,
              color: const Color(0xFFE2E8F0),
            ),
          ],
        );
      default: // ats_experienced
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 55, height: 5, color: const Color(0xFF1E293B)),
                Container(width: 30, height: 3, color: const Color(0xFF94A3B8)),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              height: 1,
              color: const Color(0xFFCBD5E1),
            ),
            const SizedBox(height: 5),
            Container(width: 55, height: 3, color: const Color(0xFF4F46E5)),
            const SizedBox(height: 3),
            Container(
              width: double.infinity,
              height: 2.5,
              color: const Color(0xFFE2E8F0),
            ),
            const SizedBox(height: 2),
            Container(
              width: double.infinity,
              height: 2.5,
              color: const Color(0xFFE2E8F0),
            ),
            const SizedBox(height: 5),
            Container(width: 50, height: 3, color: const Color(0xFF4F46E5)),
            const SizedBox(height: 3),
            Container(
              width: double.infinity,
              height: 2.5,
              color: const Color(0xFFE2E8F0),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF4F46E5)
              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? const Color(0xFF4F46E5).withValues(alpha: 0.15)
                : (isDark
                      ? Colors.black.withValues(alpha: 0.2)
                      : const Color(0xFF0F172A).withValues(alpha: 0.04)),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visual Paper Thumbnail Representation
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: 110,
                    height: 130,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: const Color(0xFFCBD5E1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _buildWireframe(context, isDark),
                  ),
                ),
                if (isSelected)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F46E5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check, size: 12, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Active',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  template.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '100% ATS Ready',
                  style: TextStyle(
                    color: Color(0xFF059669),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            template.description,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: template.tags
                .take(3)
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? const Color(0xFFCBD5E1)
                            : const Color(0xFF475569),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const Spacer(),
          Row(
            children: [
              if (onPreview != null) ...[
                Expanded(
                  child: AppButton(
                    text: 'Preview',
                    type: ButtonType.outline,
                    height: 36,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    onPressed: onPreview,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: AppButton(
                  text: isSelected ? 'Applied' : 'Use Template',
                  type: isSelected ? ButtonType.secondary : ButtonType.primary,
                  height: 36,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  onPressed: onSelect,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
