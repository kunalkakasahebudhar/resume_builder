import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;
  final double borderRadius;
  final double? width;
  final double? height;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.color,
    this.borderColor,
    this.borderRadius = 12,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardBorderColor =
        borderColor ?? theme.colorScheme.outline.withValues(alpha: 0.5);

    Widget content = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color ?? theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: cardBorderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.2 : 0.03,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: content,
      );
    }

    return content;
  }
}
