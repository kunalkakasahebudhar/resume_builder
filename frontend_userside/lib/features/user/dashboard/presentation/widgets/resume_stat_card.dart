import 'package:flutter/material.dart';

class ResumeStatCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = color ?? const Color(0xFF4F46E5);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.15)
                : const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: cardColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: cardColor, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 26,
                  letterSpacing: -0.5,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              if (trendText != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isPositiveTrend
                        ? const Color(0xFF10B981).withValues(alpha: 0.12)
                        : const Color(0xFFF59E0B).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    trendText!,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isPositiveTrend
                          ? const Color(0xFF059669)
                          : const Color(0xFFD97706),
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                color: isDark
                    ? const Color(0xFF64748B)
                    : const Color(0xFF94A3B8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
