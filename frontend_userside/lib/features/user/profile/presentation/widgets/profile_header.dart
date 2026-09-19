import 'package:flutter/material.dart';
import 'package:frontend_userside/features/user/profile/domain/entities/profile.dart';

class ProfileHeader extends StatelessWidget {
  final Profile? profile;

  const ProfileHeader({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final initials = (profile?.fullName.isNotEmpty ?? false)
        ? profile!.fullName
              .split(' ')
              .map((n) => n.isNotEmpty ? n[0] : '')
              .take(2)
              .join()
              .toUpperCase()
        : 'U';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: const Color(0xFF4F46E5),
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      width: 2,
                    ),
                  ),
                  child: const Icon(Icons.check, size: 10, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      profile?.fullName ?? 'Alex Morgan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified,
                            size: 12,
                            color: Color(0xFF4F46E5),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'PRO ACCOUNT',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF4F46E5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  profile?.professionalTitle ?? 'Senior Software Engineer',
                  style: const TextStyle(
                    color: Color(0xFF6366F1),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile?.email ?? 'alex.morgan@resumeforge.com',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
