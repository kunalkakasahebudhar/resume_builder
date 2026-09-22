import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';
import 'package:frontend_userside/features/user/profile/presentation/providers/subscription_provider.dart';
import 'package:frontend_userside/features/user/profile/presentation/widgets/premium_paywall_dialog.dart';

class UsageLimitBanner extends ConsumerWidget {
  final bool compact;

  const UsageLimitBanner({super.key, this.compact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sub = ref.watch(subscriptionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (sub.isLoading) {
      return const SizedBox.shrink();
    }

    if (sub.isPremium) {
      // Pro Member Badge
      if (compact) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.workspace_premium_rounded,
                  color: Color(0xFFFBBF24), size: 14),
              SizedBox(width: 5),
              Text(
                'PRO VIP',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1E1B4B), const Color(0xFF312E81)]
                : [const Color(0xFFEEF2FF), const Color(0xFFE0E7FF)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF6366F1).withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.workspace_premium_rounded,
                color: Color(0xFFFBBF24),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${sub.planName} Active',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF1E1B4B),
                    ),
                  ),
                  Text(
                    'Unlimited ATS downloads, all 8 templates & priority parsing unlocked.',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF4338CA),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Free Tier Usage Card
    final usesLeft = sub.freeUsesLeft;
    final isExhausted = usesLeft <= 0;

    if (compact) {
      return InkWell(
        onTap: () => PremiumPaywallDialog.show(context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isExhausted
                ? const Color(0xFFEF4444).withValues(alpha: 0.15)
                : const Color(0xFFF59E0B).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isExhausted
                  ? const Color(0xFFEF4444).withValues(alpha: 0.4)
                  : const Color(0xFFF59E0B).withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isExhausted ? Icons.lock_outline_rounded : Icons.flash_on_rounded,
                size: 13,
                color: isExhausted
                    ? const Color(0xFFEF4444)
                    : const Color(0xFFD97706),
              ),
              const SizedBox(width: 4),
              Text(
                isExhausted ? '0/3 Free Left • Upgrade' : '$usesLeft/3 Free Left',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isExhausted
                      ? const Color(0xFFEF4444)
                      : const Color(0xFFD97706),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? (isExhausted
                    ? const Color(0xFF2D1214)
                    : const Color(0xFF241C10))
                : (isExhausted
                    ? const Color(0xFFFEF2F2)
                    : const Color(0xFFFFFBEB)),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isExhausted
                  ? const Color(0xFFEF4444).withValues(alpha: isDark ? 0.35 : 0.25)
                  : const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.35 : 0.25),
              width: 1,
            ),
          ),
          child: isWide
              ? Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isExhausted
                            ? const Color(0xFFEF4444).withValues(alpha: 0.15)
                            : const Color(0xFFF59E0B).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isExhausted
                            ? Icons.lock_clock_rounded
                            : Icons.electric_bolt_rounded,
                        color: isExhausted
                            ? const Color(0xFFEF4444)
                            : const Color(0xFFD97706),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isExhausted
                                ? 'Free Tier Limit Reached (0/3)'
                                : 'Free Trial Quota: $usesLeft of 3 Left',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isExhausted
                                  ? const Color(0xFFB91C1C)
                                  : const Color(0xFFB45309),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isExhausted
                                ? 'You have used all 3 free generations. Upgrade to Pro for unlimited exports.'
                                : 'You get 3 free downloads/creations. After 3 uses, upgrade to Pro for unlimited access.',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark
                                  ? const Color(0xFFCBD5E1)
                                  : const Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    AppButton(
                      text: isExhausted ? 'Upgrade to Pro' : 'Get Unlimited',
                      icon: Icons.bolt_rounded,
                      height: 36,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      onPressed: () => PremiumPaywallDialog.show(context),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isExhausted
                                ? const Color(0xFFEF4444)
                                    .withValues(alpha: 0.15)
                                : const Color(0xFFF59E0B)
                                    .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            isExhausted
                                ? Icons.lock_clock_rounded
                                : Icons.electric_bolt_rounded,
                            color: isExhausted
                                ? const Color(0xFFEF4444)
                                : const Color(0xFFD97706),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isExhausted
                                    ? 'Free Tier Limit Reached (0/3)'
                                    : 'Free Trial Quota: $usesLeft of 3 Left',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isExhausted
                                      ? const Color(0xFFB91C1C)
                                      : const Color(0xFFB45309),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isExhausted
                                    ? 'All 3 free generations used. Upgrade to Pro for unlimited exports.'
                                    : '3 free uses included. Upgrade to Pro for unlimited access.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark
                                      ? const Color(0xFFCBD5E1)
                                      : const Color(0xFF475569),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        text: isExhausted ? 'Upgrade to Pro' : 'Get Unlimited',
                        icon: Icons.bolt_rounded,
                        height: 36,
                        onPressed: () => PremiumPaywallDialog.show(context),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
