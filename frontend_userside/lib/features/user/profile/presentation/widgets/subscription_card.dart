import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';
import 'package:frontend_userside/features/user/profile/presentation/providers/subscription_provider.dart';
import 'package:frontend_userside/features/user/profile/presentation/widgets/premium_paywall_dialog.dart';

class SubscriptionCard extends ConsumerStatefulWidget {
  const SubscriptionCard({super.key});

  @override
  ConsumerState<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends ConsumerState<SubscriptionCard> {
  final _promoController = TextEditingController();
  bool _isApplying = false;
  String? _promoResult;
  bool _isSuccess = false;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  Future<void> _handlePromo() async {
    final code = _promoController.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _isApplying = true;
      _promoResult = null;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    final ok = await ref.read(subscriptionProvider.notifier).applyPromoCode(code);

    if (mounted) {
      setState(() {
        _isApplying = false;
        _isSuccess = ok;
        _promoResult = ok
            ? '🎉 Code applied! Pro VIP unlocked!'
            : '❌ Invalid code. Try "ATS100" or "PROFREE"';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sub = ref.watch(subscriptionProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final usesLeft = sub.freeUsesLeft;
    final isExhausted = usesLeft <= 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: sub.isPremium
              ? const Color(0xFF6366F1).withValues(alpha: 0.6)
              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          width: sub.isPremium ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: sub.isPremium
                ? const Color(0xFF6366F1).withValues(alpha: 0.15)
                : (isDark
                    ? Colors.black.withValues(alpha: 0.2)
                    : const Color(0xFF0F172A).withValues(alpha: 0.04)),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 500;

              final titleSection = Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: sub.isPremium
                          ? const Color(0xFF6366F1).withValues(alpha: 0.15)
                          : const Color(0xFFF59E0B).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      sub.isPremium
                          ? Icons.workspace_premium_rounded
                          : Icons.electric_bolt_rounded,
                      color: sub.isPremium
                          ? const Color(0xFF6366F1)
                          : const Color(0xFFD97706),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Subscription & Free Usage Limit',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color:
                                isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          sub.isPremium
                              ? 'Active Plan: ${sub.planName}'
                              : 'Free Trial: 3 Total Free Uses',
                          style: TextStyle(
                            fontSize: 12,
                            color: sub.isPremium
                                ? const Color(0xFF10B981)
                                : (isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B)),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              );

              final badge = Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: sub.isPremium
                      ? const Color(0xFF10B981).withValues(alpha: 0.15)
                      : (isExhausted
                          ? const Color(0xFFEF4444).withValues(alpha: 0.15)
                          : const Color(0xFFF59E0B).withValues(alpha: 0.15)),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: sub.isPremium
                        ? const Color(0xFF10B981).withValues(alpha: 0.4)
                        : (isExhausted
                            ? const Color(0xFFEF4444).withValues(alpha: 0.4)
                            : const Color(0xFFF59E0B).withValues(alpha: 0.4)),
                  ),
                ),
                child: Text(
                  sub.isPremium
                      ? 'PRO VIP'
                      : (isExhausted
                          ? '0/3 FREE USES'
                          : '$usesLeft/3 FREE LEFT'),
                  style: TextStyle(
                    color: sub.isPremium
                        ? const Color(0xFF059669)
                        : (isExhausted
                            ? const Color(0xFFEF4444)
                            : const Color(0xFFD97706)),
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              );

              if (isWide) {
                return Row(
                  children: [
                    Expanded(child: titleSection),
                    const SizedBox(width: 12),
                    badge,
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleSection,
                    const SizedBox(height: 10),
                    badge,
                  ],
                );
              }
            },
          ),

          const SizedBox(height: 18),
          const Divider(height: 1),
          const SizedBox(height: 18),

          if (!sub.isPremium) ...[
            // Progress Bar & Usage Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Free Usage Quota',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  isExhausted
                      ? '3 of 3 used (0 left)'
                      : '${3 - usesLeft} of 3 used ($usesLeft remaining)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isExhausted
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (3 - usesLeft) / 3,
                minHeight: 8,
                backgroundColor: isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isExhausted
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF2563EB),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              isExhausted
                  ? '⚠️ You have used all 3 free generations. Upgrade to ResumeForge Pro to download unlimited PDFs and access all 11 ATS templates.'
                  : '💡 Each PDF export, resume creation, or duplication uses 1 free credit. After 3 uses, you will be prompted to upgrade.',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                height: 1.4,
              ),
            ),

            const SizedBox(height: 20),

            // Upgrade Banner CTA & Promo Code in Row/Wrap
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AppButton(
                  text: 'Upgrade to ResumeForge Pro',
                  icon: Icons.workspace_premium_rounded,
                  onPressed: () => PremiumPaywallDialog.show(context),
                ),
                AppButton(
                  text: 'Reset Quota (Test Mode)',
                  type: ButtonType.outline,
                  icon: Icons.restart_alt_rounded,
                  onPressed: () async {
                    await ref
                        .read(subscriptionProvider.notifier)
                        .resetQuotaForTesting();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Free quota reset to 3 uses for testing!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Promo Code Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.discount_outlined,
                      size: 18, color: Color(0xFF6366F1)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _promoController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        hintText: 'Enter Promo Code (ATS100, PROFREE, VIP2026)',
                        hintStyle: TextStyle(fontSize: 12),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  AppButton(
                    text: 'Apply',
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    isLoading: _isApplying,
                    onPressed: _handlePromo,
                  ),
                ],
              ),
            ),
            if (_promoResult != null) ...[
              const SizedBox(height: 6),
              Text(
                _promoResult!,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _isSuccess ? Colors.green : Colors.redAccent,
                ),
              ),
            ],
          ] else ...[
            // Pro Member Unlocked Features
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: Color(0xFF10B981), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Unlimited PDF Exports & 11 ATS-Certified Templates Unlocked',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: Color(0xFF10B981), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '100-Point Full ATS Keyword Scanner & AI Suggestions',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppButton(
                  text: 'Switch to Free Tier (Test Mode)',
                  type: ButtonType.outline,
                  icon: Icons.change_circle_outlined,
                  onPressed: () async {
                    await ref
                        .read(subscriptionProvider.notifier)
                        .resetQuotaForTesting();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Switched back to Free Tier with 3 credits for testing!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
