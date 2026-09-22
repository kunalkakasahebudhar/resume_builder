import 'package:flutter/material.dart';

enum ButtonType { primary, secondary, outline, text, danger }

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.width,
    this.height = 42,
    this.padding,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    final effectivePadding = widget.padding ??
        const EdgeInsets.symmetric(horizontal: 18, vertical: 8);

    Widget buttonChild = widget.isLoading
        ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.type == ButtonType.outline || widget.type == ButtonType.text
                    ? theme.colorScheme.primary
                    : Colors.white,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                AnimatedSlide(
                  duration: const Duration(milliseconds: 150),
                  offset: _isHovered ? const Offset(0.05, 0) : Offset.zero,
                  child: Icon(widget.icon, size: 17),
                ),
                const SizedBox(width: 7),
              ],
              Flexible(
                child: Text(
                  widget.text,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.1,
                  ),
                ),
              ),
            ],
          );

    BoxDecoration decoration;
    Color textColor;

    switch (widget.type) {
      case ButtonType.primary:
        textColor = Colors.white;
        decoration = BoxDecoration(
          gradient: isEnabled
              ? LinearGradient(
                  colors: isDark
                      ? [
                          _isHovered ? const Color(0xFF818CF8) : const Color(0xFF6366F1),
                          _isHovered ? const Color(0xFF6366F1) : const Color(0xFF4F46E5),
                        ]
                      : [
                          _isHovered ? const Color(0xFF4338CA) : const Color(0xFF4F46E5),
                          _isHovered ? const Color(0xFF3730A3) : const Color(0xFF4338CA),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isEnabled ? null : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isEnabled
                ? (isDark ? const Color(0x33FFFFFF) : const Color(0x29FFFFFF))
                : Colors.transparent,
            width: 1,
          ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: isDark
                        ? const Color(0xFF6366F1).withValues(alpha: _isHovered ? 0.35 : 0.2)
                        : const Color(0xFF4F46E5).withValues(alpha: _isHovered ? 0.3 : 0.18),
                    blurRadius: _isHovered ? 14 : 8,
                    offset: Offset(0, _isHovered ? 4 : 2),
                  ),
                ]
              : null,
        );
        break;

      case ButtonType.secondary:
        textColor = isDark ? Colors.white : const Color(0xFF0F172A);
        decoration = BoxDecoration(
          color: isDark
              ? (_isHovered ? const Color(0xFF334155) : const Color(0xFF1E293B))
              : (_isHovered ? const Color(0xFFE2E8F0) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark
                ? (_isHovered ? const Color(0x33FFFFFF) : const Color(0x1FFFFFFF))
                : (_isHovered ? const Color(0x290F172A) : const Color(0x140F172A)),
            width: 1,
          ),
        );
        break;

      case ButtonType.outline:
        textColor = isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5);
        decoration = BoxDecoration(
          color: _isHovered
              ? (isDark ? const Color(0x1F6366F1) : const Color(0x144F46E5))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark
                ? (_isHovered ? const Color(0xFF818CF8) : const Color(0x4D6366F1))
                : (_isHovered ? const Color(0xFF4F46E5) : const Color(0x4D4F46E5)),
            width: 1.2,
          ),
        );
        break;

      case ButtonType.text:
        textColor = isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5);
        decoration = BoxDecoration(
          color: _isHovered
              ? (isDark ? const Color(0x14FFFFFF) : const Color(0x0A0F172A))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        );
        break;

      case ButtonType.danger:
        textColor = Colors.white;
        decoration = BoxDecoration(
          gradient: isEnabled
              ? LinearGradient(
                  colors: _isHovered
                      ? [const Color(0xFFDC2626), const Color(0xFFB91C1C)]
                      : [const Color(0xFFEF4444), const Color(0xFFDC2626)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isEnabled ? null : const Color(0xFF94A3B8),
          borderRadius: BorderRadius.circular(10),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: const Color(0xFFEF4444).withValues(alpha: _isHovered ? 0.35 : 0.2),
                    blurRadius: _isHovered ? 12 : 6,
                    offset: Offset(0, _isHovered ? 4 : 2),
                  ),
                ]
              : null,
        );
        break;
    }

    Widget buttonContent = AnimatedScale(
      duration: const Duration(milliseconds: 100),
      scale: _isPressed ? 0.98 : 1.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        height: widget.height,
        width: widget.width ?? (widget.isFullWidth ? double.infinity : null),
        decoration: decoration,
        padding: effectivePadding,
        alignment: Alignment.center,
        child: DefaultTextStyle(
          style: TextStyle(
            color: isEnabled ? textColor : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
          ),
          child: IconTheme(
            data: IconThemeData(
              color: isEnabled ? textColor : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
              size: 17,
            ),
            child: buttonChild,
          ),
        ),
      ),
    );

    return MouseRegion(
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      onEnter: (_) {
        if (isEnabled && mounted) setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (mounted) setState(() => _isHovered = false);
      },
      child: GestureDetector(
        onTapDown: (_) {
          if (isEnabled && mounted) setState(() => _isPressed = true);
        },
        onTapUp: (_) {
          if (mounted) setState(() => _isPressed = false);
        },
        onTapCancel: () {
          if (mounted) setState(() => _isPressed = false);
        },
        onTap: isEnabled ? widget.onPressed : null,
        child: buttonContent,
      ),
    );
  }
}
