import 'package:flutter/material.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';

class UserFilter extends StatelessWidget {
  final String selectedStatus;
  final ValueChanged<String> onStatusChanged;

  const UserFilter({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Active', 'Inactive', 'Suspended'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: filters.map((status) {
        final isSelected = selectedStatus.toLowerCase() == status.toLowerCase();
        return ChoiceChip(
          label: Text(status),
          labelStyle: AppTextStyles.badge(
            color: isSelected ? Colors.white : AppColors.textSecondary(context),
          ),
          selected: isSelected,
          selectedColor: AppColors.primary,
          backgroundColor: AppColors.card(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.border(context),
            ),
          ),
          showCheckmark: false,
          onSelected: (_) => onStatusChanged(status),
        );
      }).toList(),
    );
  }
}
