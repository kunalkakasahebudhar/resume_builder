import 'package:flutter/material.dart';

class ResumeStatCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final String? subtitle;
  final String? trendText;
  final bool isPositiveTrend;

  const ResumeStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.subtitle,
    this.trendText,
    this.isPositiveTrend = true,
  });

  @override
  State<ResumeStatCard> createState() => _ResumeStatCardState();
}

class _ResumeStatCardState extends State<ResumeStatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = widget.color ?? const Color(0xFF6366F1);

    final border = _isHovered
        ? (isDark ? cardColor.withValues(alpha: 0.4) : cardColor.withValues(alpha: 0.35))
        : (isDark ? const Color(0x1AFFFFFF) : const Color(0x140F172A));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        transform: _isHovered
            ? Matrix4.translationValues(0.0, -2.0, 0.0)
            : Matrix4.identity(),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 1),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: _isHovered ? 0.35 : 0.2)
                  : const Color(0xFF0F172A).withValues(alpha: _isHovered ? 0.08 : 0.03),
              blurRadius: _isHovered ? 16 : 8,
              offset: Offset(0, _isHovered ? 6 : 2),
            ),
            if (_isHovered)
              BoxShadow(
                color: cardColor.withValues(alpha: isDark ? 0.08 : 0.05),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    letterSpacing: -0.1,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: cardColor.withValues(alpha: isDark ? 0.16 : 0.1),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      color: cardColor.withValues(alpha: isDark ? 0.25 : 0.15),
                    ),
                  ),
                  child: Icon(widget.icon, color: cardColor, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  widget.value,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 26,
                    letterSpacing: -0.8,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                if (widget.trendText != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2.5,
                    ),
                    decoration: BoxDecoration(
                      color: widget.isPositiveTrend
                          ? const Color(0xFF10B981).withValues(alpha: isDark ? 0.18 : 0.12)
                          : const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.18 : 0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: widget.isPositiveTrend
                            ? const Color(0xFF10B981).withValues(alpha: 0.25)
                            : const Color(0xFFF59E0B).withValues(alpha: 0.25),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      widget.trendText!,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: widget.isPositiveTrend
                            ? const Color(0xFF10B981)
                            : const Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (widget.subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                widget.subtitle!,
                style: TextStyle(
                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
