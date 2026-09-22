import 'package:flutter/material.dart';

class QuickActionCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  const QuickActionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.color,
    required this.onTap,
  });

  @override
  State<QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<QuickActionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final actionColor = widget.color ?? const Color(0xFF6366F1);

    final borderColor = _isHovered
        ? (isDark ? actionColor.withValues(alpha: 0.4) : actionColor.withValues(alpha: 0.35))
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                  color: actionColor.withValues(alpha: isDark ? 0.08 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: actionColor.withValues(alpha: isDark ? 0.15 : 0.09),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: actionColor.withValues(alpha: isDark ? 0.25 : 0.15),
                  ),
                ),
                child: Icon(widget.icon, color: actionColor, size: 19),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSlide(
                duration: const Duration(milliseconds: 150),
                offset: _isHovered ? const Offset(0.15, 0) : Offset.zero,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: _isHovered
                      ? actionColor
                      : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
