import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_error_state.dart';
import 'package:frontend_userside/core/widgets/app_loader.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/user_layout.dart';
import 'package:frontend_userside/features/user/profile/presentation/providers/profile_provider.dart';
import 'package:frontend_userside/features/user/profile/presentation/widgets/profile_form.dart';
import 'package:frontend_userside/features/user/profile/presentation/widgets/profile_header.dart';
import 'package:frontend_userside/features/user/profile/presentation/widgets/subscription_card.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileProvider);

    return UserLayout(
      currentRoute: '/profile',
      child: state.isLoading
          ? const AppLoader(message: 'Loading profile...')
          : state.error != null && state.profile == null
          ? AppErrorState(
              message: state.error!,
              onRetry: () => ref.read(profileProvider.notifier).loadProfile(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ProfileHeader(profile: state.profile),
                      const SizedBox(height: 20),
                      const SubscriptionCard(),
                      const SizedBox(height: 20),
                      if (state.profile != null)
                        ProfileForm(profile: state.profile!),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
