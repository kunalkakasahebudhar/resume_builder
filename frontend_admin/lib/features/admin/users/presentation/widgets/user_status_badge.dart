import 'package:flutter/material.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';

class UserStatusBadge extends StatelessWidget {
  final String status;

  const UserStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg = AppColors.successLight;
    Color fg = AppColors.success;

    if (status.toLowerCase() == 'inactive') {
      bg = const Color(0xFFF1F5F9);
      fg = AppColors.textSecondaryLight;
    } else if (status.toLowerCase() == 'suspended') {
      bg = AppColors.errorLight;
      fg = AppColors.error;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status, style: AppTextStyles.badge(color: fg)),
    );
  }
}
