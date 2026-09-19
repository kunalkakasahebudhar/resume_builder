import 'package:flutter/material.dart';
import 'package:frontend_userside/core/utils/date_utils.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/resume.dart';

class RecentResumeCard extends StatelessWidget {
  final Resume resume;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onPreview;

  const RecentResumeCard({
    super.key,
    required this.resume,
    required this.onTap,
    this.onEdit,
    this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final isHighAts = resume.atsScore >= 80;
    final atsColor = isHighAts
        ? const Color(0xFF10B981)
        : const Color(0xFFF59E0B);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.15)
                  : const Color(0xFF0F172A).withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Mini A4 Paper Thumbnail Simulation
            Container(
              width: 44,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mini top header bar
                  Container(
                    width: 24,
                    height: 3,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  const SizedBox(height: 3),
                  // Mini subtitle
                  Container(
                    width: 16,
                    height: 2,
                    decoration: BoxDecoration(
                      color: const Color(0xFF94A3B8),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Divider
                  Container(height: 0.5, color: const Color(0xFFE2E8F0)),
                  const SizedBox(height: 3),
                  // Section bars
                  Container(
                    width: 32,
                    height: 2,
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.7),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: 28,
                    height: 2,
                    color: const Color(0xFFCBD5E1),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: 34,
                    height: 2,
                    color: const Color(0xFFCBD5E1),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            // Resume Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          resume.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: atsColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${resume.atsScore} ATS',
                          style: TextStyle(
                            color: atsColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Edited ${AppDateUtils.timeAgo(resume.updatedAt)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '•',
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFF475569)
                              : const Color(0xFFCBD5E1),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        resume.templateId.replaceAll('_', ' ').toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6366F1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }
}
