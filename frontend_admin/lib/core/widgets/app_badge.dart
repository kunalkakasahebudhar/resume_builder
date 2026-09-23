import 'package:flutter/material.dart';

enum BadgeType {
  success,
  warning,
  error,
  info,
  primary,
  neutral,
}

typedef BadgeVariant = BadgeType;

class AppBadge extends StatelessWidget {
  final String label;
  final BadgeType type;
  final IconData? icon;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const AppBadge({
    super.key,
    String? text,
    String? label,
    BadgeType? type,
    BadgeType? variant,
    this.icon,
    this.fontSize = 11,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
  })  : label = label ?? text ?? '',
        type = variant ?? type ?? BadgeType.primary;

  @override
  Widget build(BuildContext context) {
    final (bg, border, text) = switch (type) {
      BadgeType.success => (
        const Color(0xFF10B981).withValues(alpha: 0.12),
        const Color(0xFF10B981).withValues(alpha: 0.35),
        const Color(0xFF059669),
      ),
      BadgeType.warning => (
        const Color(0xFFF59E0B).withValues(alpha: 0.12),
        const Color(0xFFF59E0B).withValues(alpha: 0.35),
        const Color(0xFFD97706),
      ),
      BadgeType.error => (
        const Color(0xFFEF4444).withValues(alpha: 0.12),
        const Color(0xFFEF4444).withValues(alpha: 0.35),
        const Color(0xFFDC2626),
      ),
      BadgeType.info => (
        const Color(0xFF06B6D4).withValues(alpha: 0.12),
        const Color(0xFF06B6D4).withValues(alpha: 0.35),
        const Color(0xFF0891B2),
      ),
      BadgeType.primary => (
        const Color(0xFF4F46E5).withValues(alpha: 0.12),
        const Color(0xFF4F46E5).withValues(alpha: 0.35),
        const Color(0xFF4F46E5),
      ),
      BadgeType.neutral => (
        const Color(0xFF64748B).withValues(alpha: 0.12),
        const Color(0xFF64748B).withValues(alpha: 0.35),
        const Color(0xFF64748B),
      ),
    };

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 2, color: text),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: text,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
