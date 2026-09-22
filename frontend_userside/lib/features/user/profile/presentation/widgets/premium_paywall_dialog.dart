import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';
import 'package:frontend_userside/features/user/profile/presentation/providers/subscription_provider.dart';

class PremiumPaywallDialog extends ConsumerStatefulWidget {
  final String? featureTrigger;

  const PremiumPaywallDialog({super.key, this.featureTrigger});

  static Future<void> show(BuildContext context, {String? featureTrigger}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => PremiumPaywallDialog(featureTrigger: featureTrigger),
    );
  }

  @override
  ConsumerState<PremiumPaywallDialog> createState() =>
      _PremiumPaywallDialogState();
}

class _PremiumPaywallDialogState extends ConsumerState<PremiumPaywallDialog> {
  int _selectedPlanIndex = 1; // 0 = Monthly (₹199), 1 = Lifetime Pro (₹499)
  final _promoController = TextEditingController();
  bool _isApplyingPromo = false;
  String? _promoMessage;
  bool _isPromoSuccess = false;
  bool _isUpgrading = false;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  Future<void> _handlePromoApply() async {
    final code = _promoController.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _isApplyingPromo = true;
      _promoMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    final success = await ref
        .read(subscriptionProvider.notifier)
        .applyPromoCode(code);

    if (mounted) {
      setState(() {
        _isApplyingPromo = false;
        _isPromoSuccess = success;
        _promoMessage = success
            ? '🎉 Promo Code applied! Lifetime Pro VIP activated!'
            : '❌ Invalid Promo Code. Try "ATS100" or "PROFREE"';
      });

      if (success) {
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  Future<void> _handleUpgrade() async {
    setState(() {
      _isUpgrading = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    final planName =
        _selectedPlanIndex == 1 ? 'Lifetime Pro (₹499)' : 'Monthly Pro (₹199)';
    await ref
        .read(subscriptionProvider.notifier)
        .upgradeToPremium(plan: planName);

    if (mounted) {
      setState(() {
        _isUpgrading = false;
      });
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.workspace_premium_rounded,
                  color: Colors.amber, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '🎉 Congratulations! You unlocked $planName with unlimited downloads & all ATS templates!',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF1E1B4B),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 780),
        child: Column(
          children: [
            // Top Premium Banner Header
            Container(
              padding: const EdgeInsets.fromLTRB(28, 24, 20, 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1E1B4B),
                    Color(0xFF312E81),
                    Color(0xFF4338CA),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.workspace_premium_rounded,
                          color: Color(0xFFFBBF24),
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444)
                                    .withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: const Color(0xFFEF4444)
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                              child: Text(
                                widget.featureTrigger != null
                                    ? '3 Free Uses Finished • Upgrade for ${widget.featureTrigger}'
                                    : '3 Free Uses Limit Reached',
                                style: const TextStyle(
                                  color: Color(0xFFFCA5A5),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Upgrade to ResumeForge Pro',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Unlimited ATS downloads, all 11+ certified templates, and AI optimization for your dream job.',
                              style: TextStyle(
                                color: Color(0xFFCBD5E1),
                                fontSize: 12,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: -4,
                    right: -4,
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: Colors.white70, size: 22),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Features Checklist Grid
                    Text(
                      'PRO FEATURES INCLUDED',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(
                      icon: Icons.all_inclusive_rounded,
                      title: 'Unlimited A4 PDF Exports',
                      desc: 'Download high-res, parser-ready PDFs anytime without limits',
                    ),
                    _buildFeatureItem(
                      icon: Icons.style_rounded,
                      title: 'All 11+ Premium ATS Templates',
                      desc: 'Access Harvard, Tech Minimalist, Executive, Quant & Compact formats',
                    ),
                    _buildFeatureItem(
                      icon: Icons.troubleshoot_rounded,
                      title: 'Full 100-Point ATS Analyzer',
                      desc: 'Deep parser score, keyword gap detection, and bullet improvements',
                    ),
                    _buildFeatureItem(
                      icon: Icons.cloud_done_rounded,
                      title: 'Unlimited Saved Resumes',
                      desc: 'Create tailor-made resume variations for every single company',
                    ),

                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 20),

                    // Pricing Plans Selector
                    Text(
                      'CHOOSE YOUR PLAN',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 420;
                        if (isWide) {
                          return Row(
                            children: [
                              // Monthly Plan
                              Expanded(
                                child: _buildPlanCard(
                                  index: 0,
                                  title: 'Monthly Pro',
                                  price: '₹199',
                                  period: '/ month',
                                  badge: 'Flexible',
                                  badgeColor: const Color(0xFF64748B),
                                  isDark: isDark,
                                ),
                              ),
                              const SizedBox(width: 14),
                              // Lifetime Plan (Featured)
                              Expanded(
                                child: _buildPlanCard(
                                  index: 1,
                                  title: 'Lifetime Master',
                                  price: '₹499',
                                  period: 'one-time pay',
                                  badge: '🔥 BEST VALUE (80% OFF)',
                                  badgeColor: const Color(0xFFD97706),
                                  isDark: isDark,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              _buildPlanCard(
                                index: 0,
                                title: 'Monthly Pro',
                                price: '₹199',
                                period: '/ month',
                                badge: 'Flexible',
                                badgeColor: const Color(0xFF64748B),
                                isDark: isDark,
                              ),
                              const SizedBox(height: 12),
                              _buildPlanCard(
                                index: 1,
                                title: 'Lifetime Master',
                                price: '₹499',
                                period: 'one-time pay',
                                badge: '🔥 BEST VALUE (80% OFF)',
                                badgeColor: const Color(0xFFD97706),
                                isDark: isDark,
                              ),
                            ],
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    // Promo Code Section
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.confirmation_number_outlined,
                                  size: 18, color: Color(0xFF6366F1)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _promoController,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter Promo Code (e.g. ATS100)',
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
                                height: 32,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 4,
                                ),
                                isLoading: _isApplyingPromo,
                                onPressed: _handlePromoApply,
                              ),
                            ],
                          ),
                          if (_promoMessage != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              _promoMessage!,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _isPromoSuccess
                                    ? Colors.green
                                    : Colors.redAccent,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer CTA
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedPlanIndex == 1 ? '₹499 One-time' : '₹199 / month',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const Text(
                          'Instant Access • 100% Satisfaction',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF10B981),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppButton(
                    text: 'Unlock Premium Now',
                    icon: Icons.bolt_rounded,
                    isLoading: _isUpgrading,
                    onPressed: _handleUpgrade,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF10B981),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 11,
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

  Widget _buildPlanCard({
    required int index,
    required String title,
    required String price,
    required String period,
    required String badge,
    required Color badgeColor,
    required bool isDark,
  }) {
    final isSelected = _selectedPlanIndex == index;

    return InkWell(
      onTap: () => setState(() => _selectedPlanIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? const Color(0xFF1E1B4B)
                  : const Color(0xFFEEF2FF))
              : (isDark
                  ? const Color(0xFF1E293B)
                  : const Color(0xFFFFFFFF)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4F46E5)
                : (isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFCBD5E1)),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  color: badgeColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: isSelected
                        ? const Color(0xFF4F46E5)
                        : (isDark ? Colors.white : Colors.black87),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  period,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
