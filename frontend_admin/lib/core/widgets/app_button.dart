import 'package:flutter/material.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, outline, danger }

typedef ButtonVariant = AppButtonVariant;

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final AppButtonVariant variant;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.width,
    this.height = 44,
  });

  @override
  Widget build(BuildContext context) {
    Color getBackgroundColor() {
      switch (variant) {
        case AppButtonVariant.primary:
          return AppColors.primary;
        case AppButtonVariant.secondary:
          return AppColors.secondary;
        case AppButtonVariant.outline:
          return Colors.transparent;
        case AppButtonVariant.danger:
          return AppColors.error;
      }
    }

    Color getTextColor() {
      switch (variant) {
        case AppButtonVariant.primary:
        case AppButtonVariant.secondary:
        case AppButtonVariant.danger:
          return Colors.white;
        case AppButtonVariant.outline:
          return AppColors.textPrimaryLight;
      }
    }

    BorderSide? getBorder() {
      if (variant == AppButtonVariant.outline) {
        return const BorderSide(color: AppColors.borderLight, width: 1);
      }
      return BorderSide.none;
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: getBackgroundColor(),
          foregroundColor: getTextColor(),
          elevation: 0,
          side: getBorder(),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(getTextColor()),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 6)],
                  Flexible(
                    child: Text(
                      text,
                      style: AppTextStyles.button(color: getTextColor()),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
