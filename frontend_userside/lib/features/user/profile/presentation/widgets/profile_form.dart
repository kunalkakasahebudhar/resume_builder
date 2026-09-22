import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/utils/validators.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';
import 'package:frontend_userside/core/widgets/app_card.dart';
import 'package:frontend_userside/core/widgets/app_text_field.dart';
import 'package:frontend_userside/features/user/profile/domain/entities/profile.dart';
import 'package:frontend_userside/features/user/profile/presentation/providers/profile_provider.dart';

class ProfileForm extends ConsumerStatefulWidget {
  final Profile profile;

  const ProfileForm({super.key, required this.profile});

  @override
  ConsumerState<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _titleController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _locationController;
  late final TextEditingController _linkedinController;
  late final TextEditingController _githubController;
  late final TextEditingController _portfolioController;
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.fullName);
    _titleController = TextEditingController(
      text: widget.profile.professionalTitle,
    );
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(text: widget.profile.phone);
    _locationController = TextEditingController(text: widget.profile.location);
    _linkedinController = TextEditingController(
      text: widget.profile.linkedinUrl ?? '',
    );
    _githubController = TextEditingController(
      text: widget.profile.githubUrl ?? '',
    );
    _portfolioController = TextEditingController(
      text: widget.profile.portfolioUrl ?? '',
    );
    _bioController = TextEditingController(text: widget.profile.bio ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _linkedinController.dispose();
    _githubController.dispose();
    _portfolioController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updated = widget.profile.copyWith(
        fullName: _nameController.text.trim(),
        professionalTitle: _titleController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        location: _locationController.text.trim(),
        linkedinUrl: _linkedinController.text.trim(),
        githubUrl: _githubController.text.trim(),
        portfolioUrl: _portfolioController.text.trim(),
        bio: _bioController.text.trim(),
      );

      await ref.read(profileProvider.notifier).updateProfile(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state.successMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.successMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          AppCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 500;
                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        SizedBox(
                          width: isWide
                              ? (constraints.maxWidth - 16) / 2
                              : constraints.maxWidth,
                          child: AppTextField(
                            label: 'Full Name',
                            hint: 'Alex Morgan',
                            controller: _nameController,
                            validator: (v) =>
                                Validators.validateRequired(v, 'Full Name'),
                          ),
                        ),
                        SizedBox(
                          width: isWide
                              ? (constraints.maxWidth - 16) / 2
                              : constraints.maxWidth,
                          child: AppTextField(
                            label: 'Professional Title',
                            hint: 'Software Engineer',
                            controller: _titleController,
                            validator: (v) => Validators.validateRequired(
                              v,
                              'Professional Title',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: isWide
                              ? (constraints.maxWidth - 16) / 2
                              : constraints.maxWidth,
                          child: AppTextField(
                            label: 'Email Address',
                            hint: 'user@resumeforge.com',
                            controller: _emailController,
                            validator: Validators.validateEmail,
                          ),
                        ),
                        SizedBox(
                          width: isWide
                              ? (constraints.maxWidth - 16) / 2
                              : constraints.maxWidth,
                          child: AppTextField(
                            label: 'Phone Number',
                            hint: '+1 (555) 234-5678',
                            controller: _phoneController,
                            validator: Validators.validatePhone,
                          ),
                        ),
                        SizedBox(
                          width: constraints.maxWidth,
                          child: AppTextField(
                            label: 'Location',
                            hint: 'San Francisco, CA, United States',
                            controller: _locationController,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Social & Web Links',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 500;
                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        SizedBox(
                          width: isWide
                              ? (constraints.maxWidth - 16) / 2
                              : constraints.maxWidth,
                          child: AppTextField(
                            label: 'LinkedIn URL',
                            hint: 'https://linkedin.com/in/...',
                            controller: _linkedinController,
                            validator: (v) =>
                                Validators.validateUrl(v, 'LinkedIn URL'),
                          ),
                        ),
                        SizedBox(
                          width: isWide
                              ? (constraints.maxWidth - 16) / 2
                              : constraints.maxWidth,
                          child: AppTextField(
                            label: 'GitHub URL',
                            hint: 'https://github.com/...',
                            controller: _githubController,
                            validator: (v) =>
                                Validators.validateUrl(v, 'GitHub URL'),
                          ),
                        ),
                        SizedBox(
                          width: constraints.maxWidth,
                          child: AppTextField(
                            label: 'Portfolio Website',
                            hint: 'https://...',
                            controller: _portfolioController,
                            validator: (v) =>
                                Validators.validateUrl(v, 'Portfolio URL'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bio / Career Summary',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Professional Summary',
                  hint:
                      'Write a brief description of your professional journey...',
                  controller: _bioController,
                  maxLines: 4,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: AppButton(
              text: 'Save Changes',
              icon: Icons.save_rounded,
              isLoading: state.isSaving,
              onPressed: _submit,
            ),
          ),
        ],
      ),
    );
  }
}
