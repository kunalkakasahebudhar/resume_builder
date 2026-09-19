import 'package:flutter/material.dart';
import 'package:frontend_userside/core/utils/date_utils.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/resume.dart';

class ResumeCard extends StatelessWidget {
  final Resume resume;
  final VoidCallback onEdit;
  final VoidCallback onPreview;
  final VoidCallback onAnalyze;
  final VoidCallback onDuplicate;
  final VoidCallback onRename;
  final VoidCallback onDownload;
  final VoidCallback onDelete;

  const ResumeCard({
    super.key,
    required this.resume,
    required this.onEdit,
    required this.onPreview,
    required this.onAnalyze,
    required this.onDuplicate,
    required this.onRename,
    required this.onDownload,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDraft = resume.status == ResumeStatus.draft;

    final isHighAts = resume.atsScore >= 80;
    final atsColor = isHighAts
        ? const Color(0xFF10B981)
        : const Color(0xFFF59E0B);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Paper Thumbnail & Title Banner
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mini A4 Paper Simulation
                Container(
                  width: 44,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: const Color(0xFFCBD5E1),
                      width: 1,
                    ),
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
                      Container(
                        width: 24,
                        height: 3,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        width: 16,
                        height: 2,
                        decoration: BoxDecoration(
                          color: const Color(0xFF94A3B8),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(height: 0.5, color: const Color(0xFFE2E8F0)),
                      const SizedBox(height: 3),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resume.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Edited ${AppDateUtils.timeAgo(resume.updatedAt)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isDraft
                                  ? const Color(
                                      0xFFF59E0B,
                                    ).withValues(alpha: 0.12)
                                  : const Color(
                                      0xFF10B981,
                                    ).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isDraft ? 'Draft' : 'Completed',
                              style: TextStyle(
                                color: isDraft
                                    ? const Color(0xFFD97706)
                                    : const Color(0xFF059669),
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF4F46E5,
                              ).withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              resume.templateId
                                  .replaceAll('_', ' ')
                                  .toUpperCase(),
                              style: const TextStyle(
                                color: Color(0xFF4F46E5),
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    size: 18,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  onSelected: (val) {
                    switch (val) {
                      case 'duplicate':
                        onDuplicate();
                        break;
                      case 'rename':
                        onRename();
                        break;
                      case 'analyze':
                        onAnalyze();
                        break;
                      case 'download':
                        onDownload();
                        break;
                      case 'delete':
                        onDelete();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'duplicate',
                      child: Row(
                        children: [
                          Icon(Icons.copy_rounded, size: 16),
                          SizedBox(width: 8),
                          Text('Duplicate Resume'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'rename',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 16),
                          SizedBox(width: 8),
                          Text('Rename Resume'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'analyze',
                      child: Row(
                        children: [
                          Icon(Icons.analytics_outlined, size: 16),
                          SizedBox(width: 8),
                          Text('ATS Score & Analysis'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'download',
                      child: Row(
                        children: [
                          Icon(Icons.download_rounded, size: 16),
                          SizedBox(width: 8),
                          Text('Download PDF'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            size: 16,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Delete Resume',
                            style: TextStyle(
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // ATS Score & Completion Meter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Completion: ${resume.completionPercentage}%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: atsColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${resume.atsScore}/100 ATS',
                        style: TextStyle(
                          color: atsColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: resume.completionPercentage / 100,
                    minHeight: 4,
                    backgroundColor: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF4F46E5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Action Buttons
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18, bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_note_rounded, size: 16),
                    label: const Text('Edit Resume'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(0, 36),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onPreview,
                    icon: const Icon(Icons.visibility_outlined, size: 15),
                    label: const Text('Preview'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF334155),
                      side: BorderSide(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFCBD5E1),
                      ),
                      minimumSize: const Size(0, 36),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
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
