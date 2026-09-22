import 'package:flutter/material.dart';

class AppCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;
  final double borderRadius;
  final double? width;
  final double? height;
  final bool enableHover;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.color,
    this.borderColor,
    this.borderRadius = 14,
    this.width,
    this.height,
    this.enableHover = true,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultBorderColor = isDark
        ? const Color(0x1FFFFFFF) // 12% white
        : const Color(0x140F172A); // 8% black

    final hoverBorderColor = isDark
        ? const Color(0x4D6366F1) // 30% indigo glow
        : const Color(0x3D4F46E5); // 24% indigo glow

    final effectiveBorderColor = widget.borderColor ??
        (_isHovered && (widget.onTap != null || widget.enableHover)
            ? hoverBorderColor
            : defaultBorderColor);

    final baseColor = widget.color ??
        (isDark ? const Color(0xFF0F172A) : Colors.white);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      transform: _isHovered && widget.onTap != null
          ? Matrix4.translationValues(0.0, -2.0, 0.0)
          : Matrix4.identity(),
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: effectiveBorderColor, width: 1),
        boxShadow: [
          // Ambient soft shadow
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: _isHovered && widget.onTap != null ? 0.35 : 0.2)
                : const Color(0xFF0F172A).withValues(alpha: _isHovered && widget.onTap != null ? 0.08 : 0.03),
            blurRadius: _isHovered && widget.onTap != null ? 16 : 8,
            offset: Offset(0, _isHovered && widget.onTap != null ? 6 : 2),
            spreadRadius: 0,
          ),
          if (_isHovered && widget.onTap != null)
            BoxShadow(
              color: isDark
                  ? const Color(0xFF6366F1).withValues(alpha: 0.08)
                  : const Color(0xFF4F46E5).withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: InkWell(
          onTap: widget.onTap,
          onHover: (hovered) {
            if (widget.onTap != null && mounted) {
              setState(() => _isHovered = hovered);
            }
          },
          borderRadius: BorderRadius.circular(widget.borderRadius),
          hoverColor: isDark
              ? const Color(0xFF6366F1).withValues(alpha: 0.03)
              : const Color(0xFF4F46E5).withValues(alpha: 0.02),
          splashColor: isDark
              ? const Color(0xFF6366F1).withValues(alpha: 0.06)
              : const Color(0xFF4F46E5).withValues(alpha: 0.05),
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.all(20),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
