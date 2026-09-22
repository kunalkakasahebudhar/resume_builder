import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/app/constants/app_constants.dart';
import 'package:frontend_userside/app/router/app_router.dart';
import 'package:frontend_userside/app/theme/app_theme.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/user_top_bar.dart';

class ResumeForgeApp extends ConsumerWidget {
  const ResumeForgeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
