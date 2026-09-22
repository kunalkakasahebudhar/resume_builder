import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_userside/features/user/profile/presentation/providers/subscription_provider.dart';
import 'package:frontend_userside/features/user/templates/data/datasources/template_remote_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ATS Templates Verification', () {
    test('DataSource provides 11 certified ATS templates with unique IDs', () async {
      final ds = TemplateRemoteDataSourceImpl();
      final templates = await ds.getTemplates();

      expect(templates.length, 11);

      final expectedTemplateIds = [
        'ats_harvard',
        'ats_tech_minimal',
        'ats_modern_clean',
        'ats_executive',
        'ats_data_fintech',
        'ats_compact',
        'ats_stanford',
        'ats_professional',
        'ats_fresher',
        'ats_experienced',
        'ats_classic',
      ];

      for (final id in expectedTemplateIds) {
        final t = templates.firstWhere((item) => item.id == id);
        expect(t.name.isNotEmpty, true);
        expect(t.category.isNotEmpty, true);
        expect(t.isAtsOptimized, true);
        expect(t.tags.isNotEmpty, true);
      }
    });
  });

  group('3-Time Free Usage & Freemium Paywall Logic', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Default subscription state starts with 3 free uses and non-premium', () {
      final notifier = SubscriptionNotifier();
      expect(notifier.state.freeUsesLeft, 3);
      expect(notifier.state.maxFreeUses, 3);
      expect(notifier.state.isPremium, false);
      expect(notifier.state.canUseFeature, true);
    });

    test('Promo codes successfully activate Lifetime Pro VIP', () async {
      final notifier = SubscriptionNotifier();

      final invalid = await notifier.applyPromoCode('INVALID_CODE');
      expect(invalid, false);
      expect(notifier.state.isPremium, false);

      final valid = await notifier.applyPromoCode('ATS100');
      expect(valid, true);
      expect(notifier.state.isPremium, true);
      expect(notifier.state.canUseFeature, true);
    });

    test('Reset quota returns state to 3 free uses and Free Tier', () async {
      final notifier = SubscriptionNotifier();
      await notifier.upgradeToPremium(plan: 'Lifetime Pro');
      expect(notifier.state.isPremium, true);

      await notifier.resetQuotaForTesting();
      expect(notifier.state.isPremium, false);
      expect(notifier.state.freeUsesLeft, 3);
      expect(notifier.state.totalUses, 0);
      expect(notifier.state.canUseFeature, true);
    });
  });
}
