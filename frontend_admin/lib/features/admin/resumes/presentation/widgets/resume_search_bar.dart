import 'package:flutter/material.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';

class ResumeSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const ResumeSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextField(
        onChanged: onChanged,
        style: AppTextStyles.bodyMedium(),
        decoration: const InputDecoration(
          hintText: 'Search resumes by document name, user, or role...',
          prefixIcon: Icon(
            Icons.search,
            size: 20,
            color: AppColors.textSecondaryLight,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        ),
      ),
    );
  }
}
