import 'package:flutter/material.dart';

enum ButtonType { primary, secondary, outline, text, danger }

class AppButton extends StatelessWidget {
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
    this.height = 44,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectivePadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 18, vertical: 10);

    Widget buttonChild = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );

    Widget button;

    switch (type) {
      case ButtonType.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            padding: effectivePadding,
            minimumSize: Size(
              width ?? (isFullWidth ? double.infinity : 0),
              height,
            ),
          ),
          child: buttonChild,
        );
        break;
      case ButtonType.secondary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: Colors.white,
            padding: effectivePadding,
            minimumSize: Size(
              width ?? (isFullWidth ? double.infinity : 0),
              height,
            ),
          ),
          child: buttonChild,
        );
        break;
      case ButtonType.outline:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
            side: BorderSide(
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            padding: effectivePadding,
            minimumSize: Size(
              width ?? (isFullWidth ? double.infinity : 0),
              height,
            ),
          ),
          child: buttonChild,
        );
        break;
      case ButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            padding: effectivePadding,
            minimumSize: Size(
              width ?? (isFullWidth ? double.infinity : 0),
              height,
            ),
          ),
          child: buttonChild,
        );
        break;
      case ButtonType.danger:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: Colors.white,
            padding: effectivePadding,
            minimumSize: Size(
              width ?? (isFullWidth ? double.infinity : 0),
              height,
            ),
          ),
          child: buttonChild,
        );
        break;
    }

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
