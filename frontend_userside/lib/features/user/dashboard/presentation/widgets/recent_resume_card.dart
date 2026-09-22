import 'package:flutter/material.dart';
import 'package:frontend_userside/core/utils/date_utils.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/resume.dart';

class RecentResumeCard extends StatefulWidget {
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
  State<RecentResumeCard> createState() => _RecentResumeCardState();
}

class _RecentResumeCardState extends State<RecentResumeCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isHighAts = widget.resume.atsScore >= 80;
    final atsColor = isHighAts
        ? const Color(0xFF10B981)
        : const Color(0xFFF59E0B);

    final borderColor = _isHovered
        ? (isDark ? const Color(0x4D6366F1) : const Color(0x3D4F46E5))
        : (isDark ? const Color(0x1AFFFFFF) : const Color(0x140F172A));

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          transform: _isHovered
              ? Matrix4.translationValues(0.0, -2.0, 0.0)
              : Matrix4.identity(),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: _isHovered ? 0.3 : 0.15)
                    : const Color(0xFF0F172A).withValues(alpha: _isHovered ? 0.07 : 0.02),
                blurRadius: _isHovered ? 14 : 6,
                offset: Offset(0, _isHovered ? 5 : 2),
              ),
              if (_isHovered)
                BoxShadow(
                  color: const Color(0xFF6366F1).withValues(alpha: isDark ? 0.08 : 0.04),
                  blurRadius: 10,
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
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: _isHovered ? 0.12 : 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
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
              // Resume Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.resume.title,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
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
                            color: atsColor.withValues(alpha: isDark ? 0.16 : 0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: atsColor.withValues(alpha: isDark ? 0.25 : 0.15),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            '${widget.resume.atsScore} ATS',
                            style: TextStyle(
                              color: atsColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 10.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Edited ${AppDateUtils.timeAgo(widget.resume.updatedAt)}',
                          style: TextStyle(
                            fontSize: 11.5,
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
                            fontSize: 11.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            _formatTemplateName(widget.resume.templateId),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              AnimatedSlide(
                duration: const Duration(milliseconds: 150),
                offset: _isHovered ? const Offset(0.15, 0) : Offset.zero,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: _isHovered
                      ? (isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5))
                      : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTemplateName(String templateId) {
    switch (templateId) {
      case 'ats_harvard':
        return 'Harvard';
      case 'ats_tech_minimal':
        return 'Silicon Tech';
      case 'ats_modern_clean':
        return 'Modern Clean';
      case 'ats_executive':
        return 'Executive';
      case 'ats_quant':
        return 'Quant';
      case 'ats_compact':
        return 'Compact 1-Page';
      case 'ats_stanford':
        return 'Stanford';
      case 'ats_classic':
        return 'Classic ATS';
      case 'ats_professional':
        return 'Professional';
      case 'ats_fresher':
        return 'Fresher';
      case 'ats_experienced':
        return 'Senior Leader';
      default:
        return templateId
            .replaceAll('ats_', '')
            .replaceAll('_', ' ')
            .toUpperCase();
    }
  }
}
