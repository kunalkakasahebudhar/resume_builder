import 'package:flutter/material.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';

class UserSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hintText;

  const UserSearchBar({
    super.key,
    required this.onChanged,
    this.hintText = 'Search users by name or email...',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextField(
        onChanged: onChanged,
        style: AppTextStyles.bodyMedium(),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
            color: AppColors.textSecondaryLight,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
        ),
      ),
    );
  }
}
