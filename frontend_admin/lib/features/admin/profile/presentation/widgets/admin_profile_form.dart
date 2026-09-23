import 'package:flutter/material.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/core/utils/validators.dart';
import 'package:frontend_admin/core/widgets/app_button.dart';
import 'package:frontend_admin/core/widgets/app_text_field.dart';
import 'package:frontend_admin/features/admin/auth/domain/entities/admin.dart';

class AdminProfileForm extends StatefulWidget {
  final Admin? admin;
  final Function(String name, String phone) onSave;

  const AdminProfileForm({
    super.key,
    required this.admin,
    required this.onSave,
  });

  @override
  State<AdminProfileForm> createState() => _AdminProfileFormState();
}

class _AdminProfileFormState extends State<AdminProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _roleController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.admin?.name ?? 'Kunal Udhar',
    );
    _emailController = TextEditingController(
      text: widget.admin?.email ?? 'admin@resumeforge.com',
    );
    _phoneController = TextEditingController(
      text: widget.admin?.phone ?? '+91 98765 43210',
    );
    _roleController = TextEditingController(
      text: widget.admin?.role.displayName ?? 'Super Admin',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 500));
      widget.onSave(_nameController.text.trim(), _phoneController.text.trim());
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primaryContainer,
                child: Text(
                  _nameController.text.isNotEmpty
                      ? _nameController.text[0].toUpperCase()
                      : 'A',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _nameController.text,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _roleController.text,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 20),
          AppTextField(
            label: 'Full Name',
            controller: _nameController,
            validator: (v) => Validators.validateRequired(v, 'Full Name'),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Email Address',
            controller: _emailController,
            readOnly: true,
            hintText: 'admin@resumeforge.com',
          ),
          const SizedBox(height: 16),
          AppTextField(label: 'Phone Number', controller: _phoneController),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Role & Permissions',
            controller: _roleController,
            readOnly: true,
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'Save Changes',
            isLoading: _isLoading,
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}
