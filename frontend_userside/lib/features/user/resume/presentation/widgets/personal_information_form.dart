import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_card.dart';
import 'package:frontend_userside/core/widgets/app_text_field.dart';
import 'package:frontend_userside/features/user/profile/domain/entities/profile.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';

class PersonalInformationForm extends ConsumerStatefulWidget {
  const PersonalInformationForm({super.key});

  @override
  ConsumerState<PersonalInformationForm> createState() =>
      _PersonalInformationFormState();
}

class _PersonalInformationFormState
    extends ConsumerState<PersonalInformationForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _titleController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _locationController;
  late final TextEditingController _linkedinController;
  late final TextEditingController _githubController;
  late final TextEditingController _portfolioController;

  @override
  void initState() {
    super.initState();
    final profile =
        ref.read(activeResumeProvider)?.personalInfo ??
        const Profile(
          id: '',
          fullName: '',
          professionalTitle: '',
          email: '',
          phone: '',
          location: '',
        );

    _nameController = TextEditingController(text: profile.fullName);
    _titleController = TextEditingController(text: profile.professionalTitle);
    _emailController = TextEditingController(text: profile.email);
    _phoneController = TextEditingController(text: profile.phone);
    _locationController = TextEditingController(text: profile.location);
    _linkedinController = TextEditingController(
      text: profile.linkedinUrl ?? '',
    );
    _githubController = TextEditingController(text: profile.githubUrl ?? '');
    _portfolioController = TextEditingController(
      text: profile.portfolioUrl ?? '',
    );
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
    super.dispose();
  }

  void _onChanged() {
    final current =
        ref.read(activeResumeProvider)?.personalInfo ??
        const Profile(
          id: '',
          fullName: '',
          professionalTitle: '',
          email: '',
          phone: '',
          location: '',
        );

    final updated = current.copyWith(
      fullName: _nameController.text.trim(),
      professionalTitle: _titleController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      location: _locationController.text.trim(),
      linkedinUrl: _linkedinController.text.trim(),
      githubUrl: _githubController.text.trim(),
      portfolioUrl: _portfolioController.text.trim(),
    );

    ref.read(activeResumeProvider.notifier).updatePersonalInfo(updated);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Enter your contact and identity details. All information is formatted for ATS compliance.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 18),
          AppTextField(
            label: 'Full Name *',
            hint: 'Alex Morgan',
            controller: _nameController,
            onChanged: (_) => _onChanged(),
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Professional Title *',
            hint: 'Senior Software Engineer',
            controller: _titleController,
            onChanged: (_) => _onChanged(),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 450;
              return Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  SizedBox(
                    width: isWide
                        ? (constraints.maxWidth - 14) / 2
                        : constraints.maxWidth,
                    child: AppTextField(
                      label: 'Email Address *',
                      hint: 'alex@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (_) => _onChanged(),
                    ),
                  ),
                  SizedBox(
                    width: isWide
                        ? (constraints.maxWidth - 14) / 2
                        : constraints.maxWidth,
                    child: AppTextField(
                      label: 'Phone Number',
                      hint: '+1 (555) 019-2834',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      onChanged: (_) => _onChanged(),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Location (City, Country)',
            hint: 'San Francisco, CA, USA',
            controller: _locationController,
            onChanged: (_) => _onChanged(),
          ),
          const SizedBox(height: 18),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            'Social & Web Profiles',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'LinkedIn Profile URL',
            hint: 'https://linkedin.com/in/username',
            controller: _linkedinController,
            onChanged: (_) => _onChanged(),
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'GitHub URL',
            hint: 'https://github.com/username',
            controller: _githubController,
            onChanged: (_) => _onChanged(),
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Portfolio / Personal Website',
            hint: 'https://alexmorgan.dev',
            controller: _portfolioController,
            onChanged: (_) => _onChanged(),
          ),
        ],
      ),
    );
  }
}
