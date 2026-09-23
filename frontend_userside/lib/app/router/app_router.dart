import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/features/user/ats/presentation/pages/ats_analysis_page.dart';
import 'package:frontend_userside/features/user/auth/presentation/pages/forgot_password_page.dart';
import 'package:frontend_userside/features/user/auth/presentation/pages/login_page.dart';
import 'package:frontend_userside/features/user/auth/presentation/pages/register_page.dart';
import 'package:frontend_userside/features/user/auth/presentation/pages/reset_password_page.dart';
import 'package:frontend_userside/features/user/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/pages/user_dashboard_page.dart';
import 'package:frontend_userside/features/user/landing/presentation/pages/landing_page.dart';
import 'package:frontend_userside/features/user/pdf/presentation/pages/pdf_preview_page.dart';
import 'package:frontend_userside/features/user/preview/presentation/pages/resume_preview_page.dart';
import 'package:frontend_userside/features/user/profile/presentation/pages/profile_page.dart';
import 'package:frontend_userside/features/user/resume/presentation/pages/achievements_page.dart';
import 'package:frontend_userside/features/user/resume/presentation/pages/certifications_page.dart';
import 'package:frontend_userside/features/user/resume/presentation/pages/education_page.dart';
import 'package:frontend_userside/features/user/resume/presentation/pages/experience_page.dart';
import 'package:frontend_userside/features/user/resume/presentation/pages/languages_page.dart';
import 'package:frontend_userside/features/user/resume/presentation/pages/my_resumes_page.dart';
import 'package:frontend_userside/features/user/resume/presentation/pages/personal_information_page.dart';
import 'package:frontend_userside/features/user/resume/presentation/pages/projects_page.dart';
import 'package:frontend_userside/features/user/resume/presentation/pages/resume_builder_page.dart';
import 'package:frontend_userside/features/user/resume/presentation/pages/skills_page.dart';
import 'package:frontend_userside/features/user/resume/presentation/pages/summary_page.dart';
import 'package:frontend_userside/features/user/templates/presentation/pages/template_selection_page.dart';
import 'package:frontend_userside/features/user/tools/presentation/pages/cover_letter_page.dart';
import 'package:frontend_userside/features/user/tools/presentation/pages/interview_prep_page.dart';
import 'package:frontend_userside/features/user/tools/presentation/pages/jd_matcher_page.dart';
import 'package:frontend_userside/features/user/tools/presentation/pages/salary_estimator_page.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authProvider.notifier);
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(authNotifier.stream),
    redirect: (BuildContext context, GoRouterState state) {
      if (!authState.isInitialized) {
        return null;
      }

      final isAuth = authState.isAuthenticated;
      final location = state.matchedLocation;

      // Disallow any attempt to access admin routes
      if (location.startsWith('/admin')) {
        return isAuth ? '/dashboard' : '/login';
      }

      final publicRoutes = [
        '/',
        '/landing',
        '/login',
        '/register',
        '/forgot-password',
        '/reset-password',
      ];

      final isPublicRoute = publicRoutes.contains(location);

      if (!isAuth && !isPublicRoute) {
        return '/login';
      }

      final authEntryRoutes = [
        '/login',
        '/register',
        '/forgot-password',
        '/reset-password',
      ];

      if (isAuth && authEntryRoutes.contains(location)) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        path: '/landing',
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return ResetPasswordPage(email: email);
        },
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const UserDashboardPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/resumes',
        builder: (context, state) => const MyResumesPage(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) =>
                const ResumeBuilderPage(resumeId: 'new'),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return ResumeBuilderPage(resumeId: id);
            },
            routes: [
              GoRoute(
                path: 'personal-information',
                builder: (context, state) {
                  final id = state.pathParameters['id'];
                  return PersonalInformationPage(resumeId: id);
                },
              ),
              GoRoute(
                path: 'summary',
                builder: (context, state) {
                  final id = state.pathParameters['id'];
                  return SummaryPage(resumeId: id);
                },
              ),
              GoRoute(
                path: 'education',
                builder: (context, state) {
                  final id = state.pathParameters['id'];
                  return EducationPage(resumeId: id);
                },
              ),
              GoRoute(
                path: 'skills',
                builder: (context, state) {
                  final id = state.pathParameters['id'];
                  return SkillsPage(resumeId: id);
                },
              ),
              GoRoute(
                path: 'experience',
                builder: (context, state) {
                  final id = state.pathParameters['id'];
                  return ExperiencePage(resumeId: id);
                },
              ),
              GoRoute(
                path: 'projects',
                builder: (context, state) {
                  final id = state.pathParameters['id'];
                  return ProjectsPage(resumeId: id);
                },
              ),
              GoRoute(
                path: 'certifications',
                builder: (context, state) {
                  final id = state.pathParameters['id'];
                  return CertificationsPage(resumeId: id);
                },
              ),
              GoRoute(
                path: 'achievements',
                builder: (context, state) {
                  final id = state.pathParameters['id'];
                  return AchievementsPage(resumeId: id);
                },
              ),
              GoRoute(
                path: 'languages',
                builder: (context, state) {
                  final id = state.pathParameters['id'];
                  return LanguagesPage(resumeId: id);
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/templates',
        builder: (context, state) => const TemplateSelectionPage(),
      ),
      GoRoute(
        path: '/preview',
        builder: (context, state) => const ResumePreviewPage(),
      ),
      GoRoute(
        path: '/ats',
        builder: (context, state) => const AtsAnalysisPage(),
      ),
      GoRoute(
        path: '/pdf',
        builder: (context, state) => const PdfPreviewPage(),
      ),
      GoRoute(
        path: '/jd-matcher',
        builder: (context, state) => const JdMatcherPage(),
      ),
      GoRoute(
        path: '/cover-letter',
        builder: (context, state) => const CoverLetterPage(),
      ),
      GoRoute(
        path: '/interview-prep',
        builder: (context, state) => const InterviewPrepPage(),
      ),
      GoRoute(
        path: '/salary-estimator',
        builder: (context, state) => const SalaryEstimatorPage(),
      ),
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
