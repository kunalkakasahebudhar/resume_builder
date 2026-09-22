import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/resume.dart';

class ShareResumeDialog extends StatelessWidget {
  final Resume resume;

  const ShareResumeDialog({super.key, required this.resume});

  static void show(BuildContext context, Resume resume) {
    showDialog(
      context: context,
      builder: (ctx) => ShareResumeDialog(resume: resume),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final slug = resume.personalInfo.fullName.toLowerCase().replaceAll(' ', '-');
    final shareUrl = 'https://resumeforge.me/$slug';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 540),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF10B981), Color(0xFF059669)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.share_rounded,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Shareable Web Portfolio Link',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Text(
                              'Live personal web link with real-time recruiter view analytics',
                              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Link Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link_rounded, color: Color(0xFF6366F1), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SelectableText(
                      shareUrl,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AppButton(
                    text: 'Copy Link',
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: shareUrl));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Portfolio URL copied to clipboard!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Live Analytics Widget
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1E1B4B), const Color(0xFF1E293B)]
                      : [const Color(0xFFEEF2FF), const Color(0xFFF8FAFC)],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'LIVE RECRUITER VIEW ANALYTICS',
                          style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF6366F1)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, color: Color(0xFF10B981), size: 6),
                            SizedBox(width: 4),
                            Text('Tracking Active', style: TextStyle(color: Color(0xFF059669), fontSize: 9, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 360;
                      if (isNarrow) {
                        return Column(
                          children: [
                            _buildStatItem('18 Views', 'This Week', Icons.visibility_rounded, isDark),
                            const SizedBox(height: 8),
                            _buildStatItem('4 Downloads', 'PDF Saved', Icons.download_done_rounded, isDark),
                            const SizedBox(height: 8),
                            _buildStatItem('Google, Meta', 'Top Visitors', Icons.business_rounded, isDark),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: _buildStatItem('18 Views', 'This Week', Icons.visibility_rounded, isDark),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildStatItem('4 Downloads', 'PDF Saved', Icons.download_done_rounded, isDark),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildStatItem('Google, Meta', 'Top Visitors', Icons.business_rounded, isDark),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String subtitle, IconData icon, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF6366F1)),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12), overflow: TextOverflow.ellipsis),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
