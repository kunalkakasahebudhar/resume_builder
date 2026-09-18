import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';
import 'package:frontend_admin/core/utils/validators.dart';
import 'package:frontend_admin/core/widgets/app_button.dart';
import 'package:frontend_admin/core/widgets/app_text_field.dart';
import 'package:frontend_admin/features/admin/auth/presentation/providers/admin_auth_provider.dart';

class AdminLoginForm extends ConsumerStatefulWidget {
  final VoidCallback onSuccess;

  const AdminLoginForm({super.key, required this.onSuccess});

  @override
  ConsumerState<AdminLoginForm> createState() => _AdminLoginFormState();
}

class _AdminLoginFormState extends ConsumerState<AdminLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'admin@resumeforge.com');
  final _passwordController = TextEditingController(text: 'Admin@123');
  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await ref
          .read(adminAuthProvider.notifier)
          .login(
            _emailController.text.trim(),
            _passwordController.text,
            rememberMe: _rememberMe,
          );
      if (success && mounted) {
        widget.onSuccess();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(adminAuthProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (authState.errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      authState.errorMessage!,
                      style: AppTextStyles.bodySmall(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          AppTextField(
            label: 'Admin Email',
            hintText: 'admin@resumeforge.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(
              Icons.mail_outline,
              size: 20,
              color: AppColors.textSecondaryLight,
            ),
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Password',
            hintText: '••••••••',
            controller: _passwordController,
            obscureText: _obscurePassword,
            prefixIcon: const Icon(
              Icons.lock_outline,
              size: 20,
              color: AppColors.textSecondaryLight,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20,
                color: AppColors.textSecondaryLight,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: Validators.validatePassword,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _rememberMe,
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (val) =>
                          setState(() => _rememberMe = val ?? false),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('Remember me', style: AppTextStyles.bodySmall()),
                ],
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'For mock admin, default credentials are: admin@resumeforge.com / Admin@123',
                      ),
                    ),
                  );
                },
                child: Text(
                  'Forgot password?',
                  style: AppTextStyles.label(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'Sign In to Admin Portal',
            isLoading: authState.isLoading,
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}
