import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_admin/features/admin/analytics/presentation/pages/ats_analytics_page.dart';
import 'package:frontend_admin/features/admin/auth/presentation/pages/admin_login_page.dart';
import 'package:frontend_admin/features/admin/auth/presentation/providers/admin_auth_provider.dart';
import 'package:frontend_admin/features/admin/dashboard/presentation/pages/admin_dashboard_page.dart';
import 'package:frontend_admin/features/admin/profile/presentation/pages/admin_profile_page.dart';
import 'package:frontend_admin/features/admin/resumes/presentation/pages/admin_resumes_page.dart';
import 'package:frontend_admin/features/admin/templates/presentation/pages/template_form_page.dart';
import 'package:frontend_admin/features/admin/templates/presentation/pages/templates_page.dart';
import 'package:frontend_admin/features/admin/users/presentation/pages/user_details_page.dart';
import 'package:frontend_admin/features/admin/users/presentation/pages/users_page.dart';
import 'package:go_router/go_router.dart';

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
