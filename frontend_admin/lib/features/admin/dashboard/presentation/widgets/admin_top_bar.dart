import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';
import 'package:frontend_admin/features/admin/auth/presentation/providers/admin_auth_provider.dart';
import 'package:go_router/go_router.dart';

class AdminTopBar extends ConsumerWidget {
  final String title;
  final VoidCallback? onMenuPressed;
  final bool showMenuButton;

  const AdminTopBar({
    super.key,
    required this.title,
    this.onMenuPressed,
    this.showMenuButton = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(adminAuthProvider);
    final admin = authState.admin;

    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.borderLight, width: 1)),
      ),
      child: Row(
        children: [
          if (showMenuButton) ...[
            IconButton(
              icon: const Icon(Icons.menu, color: AppColors.textPrimaryLight),
              onPressed: onMenuPressed,
            ),
            const SizedBox(width: 6),
          ],
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.h3(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),

          // Search shortcut / Quick Status indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'API Live',
                  style: AppTextStyles.badge(color: AppColors.success),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Admin Profile Avatar Button
          InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => context.go('/admin/profile'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primaryContainer,
                  child: Text(
                    (admin?.name.isNotEmpty ?? false) ? admin!.name[0].toUpperCase() : 'A',
                    style: AppTextStyles.titleSmall(color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      admin?.name ?? 'Admin',
                      style: AppTextStyles.titleSmall(),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      admin?.role ?? 'Super Admin',
                      style: AppTextStyles.bodySmall(color: AppColors.textSecondaryLight),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
