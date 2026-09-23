import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_admin/features/admin/ai_ops/presentation/pages/ai_ops_page.dart';
import 'package:frontend_admin/features/admin/analytics/presentation/pages/ats_analytics_page.dart';
import 'package:frontend_admin/features/admin/ats_rubric/presentation/pages/ats_rubric_page.dart';
import 'package:frontend_admin/features/admin/audit_logs/presentation/pages/audit_logs_page.dart';
import 'package:frontend_admin/features/admin/auth/presentation/pages/admin_login_page.dart';
import 'package:frontend_admin/features/admin/auth/presentation/providers/admin_auth_provider.dart';
import 'package:frontend_admin/features/admin/billing/presentation/pages/billing_page.dart';
import 'package:frontend_admin/features/admin/dashboard/presentation/pages/admin_dashboard_page.dart';
import 'package:frontend_admin/features/admin/moderation/presentation/pages/moderation_page.dart';
import 'package:frontend_admin/features/admin/notifications/presentation/pages/admin_notifications_page.dart';
import 'package:frontend_admin/features/admin/profile/presentation/pages/admin_profile_page.dart';
import 'package:frontend_admin/features/admin/resumes/presentation/pages/admin_resumes_page.dart';
import 'package:frontend_admin/features/admin/settings/presentation/pages/settings_page.dart';
import 'package:frontend_admin/features/admin/templates/presentation/pages/template_form_page.dart';
import 'package:frontend_admin/features/admin/templates/presentation/pages/templates_page.dart';
import 'package:frontend_admin/features/admin/users/presentation/pages/user_details_page.dart';
import 'package:frontend_admin/features/admin/users/presentation/pages/users_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(adminAuthProvider.notifier);
  final authState = ref.watch(adminAuthProvider);

  return GoRouter(
    initialLocation: '/admin/dashboard',
    refreshListenable: GoRouterRefreshStream(authNotifier.stream),
    redirect: (BuildContext context, GoRouterState state) {
      if (!authState.isInitialized) {
        return null;
      }

      final isAuth = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/admin/login';
      final isRoot = state.matchedLocation == '/';

      if (!isAuth && !isLoggingIn) {
        return '/admin/login';
      }

      if (isAuth && (isLoggingIn || isRoot)) {
        return '/admin/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (context, state) => '/admin/dashboard'),
      GoRoute(
        path: '/admin/login',
        builder: (context, state) => const AdminLoginPage(),
      ),
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) => const AdminDashboardPage(),
      ),
      GoRoute(
        path: '/admin/users',
        builder: (context, state) => const UsersPage(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return UserDetailsPage(userId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/admin/resumes',
        builder: (context, state) => const AdminResumesPage(),
      ),
      GoRoute(
        path: '/admin/templates',
        builder: (context, state) => const TemplatesPage(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) =>
                const TemplateFormPage(templateId: 'new'),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return TemplateFormPage(templateId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/admin/ai-ops',
        builder: (context, state) => const AiOpsPage(),
      ),
      GoRoute(
        path: '/admin/ats-rubric',
        builder: (context, state) => const AtsRubricPage(),
      ),
      GoRoute(
        path: '/admin/billing',
        builder: (context, state) => const BillingPage(),
      ),
      GoRoute(
        path: '/admin/moderation',
        builder: (context, state) => const ModerationPage(),
      ),
      GoRoute(
        path: '/admin/notifications',
        builder: (context, state) => const AdminNotificationsPage(),
      ),
      GoRoute(
        path: '/admin/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/admin/audit-logs',
        builder: (context, state) => const AuditLogsPage(),
      ),
      GoRoute(
        path: '/admin/analytics',
        builder: (context, state) => const AtsAnalyticsPage(),
      ),
      GoRoute(
        path: '/admin/profile',
        builder: (context, state) => const AdminProfilePage(),
      ),
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
