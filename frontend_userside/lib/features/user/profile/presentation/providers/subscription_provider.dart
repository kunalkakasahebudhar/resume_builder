import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/features/user/profile/presentation/widgets/premium_paywall_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionState {
  final bool isPremium;
  final int freeUsesLeft;
  final int totalUses;
  final int maxFreeUses;
  final String planName;
  final bool isLoading;

  const SubscriptionState({
    this.isPremium = false,
    this.freeUsesLeft = 3,
    this.totalUses = 0,
    this.maxFreeUses = 3,
    this.planName = 'Free Tier',
    this.isLoading = true,
  });

  bool get canUseFeature => isPremium || freeUsesLeft > 0;

  SubscriptionState copyWith({
    bool? isPremium,
    int? freeUsesLeft,
    int? totalUses,
    int? maxFreeUses,
    String? planName,
    bool? isLoading,
  }) {
    return SubscriptionState(
      isPremium: isPremium ?? this.isPremium,
      freeUsesLeft: freeUsesLeft ?? this.freeUsesLeft,
      totalUses: totalUses ?? this.totalUses,
      maxFreeUses: maxFreeUses ?? this.maxFreeUses,
      planName: planName ?? this.planName,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  static const String _keyIsPremium = 'subscription_is_premium';
  static const String _keyFreeUsesLeft = 'subscription_free_uses_left';
  static const String _keyTotalUses = 'subscription_total_uses';
  static const String _keyPlanName = 'subscription_plan_name';

  Future<void>? _initFuture;

  SubscriptionNotifier() : super(const SubscriptionState()) {
    _initFuture = _loadState();
  }

  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isPremium = prefs.getBool(_keyIsPremium) ?? false;
      final freeUsesLeft = prefs.getInt(_keyFreeUsesLeft) ?? 3;
      final totalUses = prefs.getInt(_keyTotalUses) ?? 0;
      final planName = prefs.getString(_keyPlanName) ?? (isPremium ? 'Lifetime Pro' : 'Free Tier');

      state = state.copyWith(
        isPremium: isPremium,
        freeUsesLeft: freeUsesLeft,
        totalUses: totalUses,
        planName: planName,
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> checkAndConsumeQuota(
    BuildContext context, {
    required String actionName,
  }) async {
    await _initFuture;

    if (state.isPremium) {
      // Pro users have unlimited access
      return true;
    }

    if (state.freeUsesLeft <= 0) {
      // Free quota exhausted -> trigger Paywall Dialog
      if (context.mounted) {
        await PremiumPaywallDialog.show(
          context,
          featureTrigger: actionName,
        );
      }
      return false;
    }

    // Decrement free usage
    final newUsesLeft = state.freeUsesLeft - 1;
    final newTotalUses = state.totalUses + 1;

    state = state.copyWith(
      freeUsesLeft: newUsesLeft,
      totalUses: newTotalUses,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyFreeUsesLeft, newUsesLeft);
    await prefs.setInt(_keyTotalUses, newTotalUses);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.flash_on_rounded, color: Colors.amber, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  newUsesLeft > 0
                      ? '$actionName successful! $newUsesLeft free use${newUsesLeft == 1 ? '' : 's'} remaining.'
                      : '$actionName used your last free credit! Upgrade to Pro for unlimited access.',
                ),
              ),
            ],
          ),
          backgroundColor: newUsesLeft > 0 ? const Color(0xFF1E293B) : const Color(0xFFD97706),
          duration: const Duration(seconds: 3),
        ),
      );
    }

    return true;
  }

  Future<void> upgradeToPremium({String plan = 'Lifetime Pro'}) async {
    await _initFuture;
    state = state.copyWith(
      isPremium: true,
      planName: plan,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsPremium, true);
    await prefs.setString(_keyPlanName, plan);
  }

  Future<bool> applyPromoCode(String code) async {
    await _initFuture;
    final cleaned = code.trim().toUpperCase();
    if (cleaned == 'ATS100' || cleaned == 'PROFREE' || cleaned == 'RESUMEPRO' || cleaned == 'VIP2026') {
      await upgradeToPremium(plan: 'Pro VIP (Promo)');
      return true;
    }
    return false;
  }

  Future<void> resetQuotaForTesting() async {
    await _initFuture;
    state = state.copyWith(
      isPremium: false,
      freeUsesLeft: 3,
      totalUses: 0,
      planName: 'Free Tier',
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsPremium, false);
    await prefs.setInt(_keyFreeUsesLeft, 3);
    await prefs.setInt(_keyTotalUses, 0);
    await prefs.setString(_keyPlanName, 'Free Tier');
  }
}

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionState>((ref) {
  return SubscriptionNotifier();
});
