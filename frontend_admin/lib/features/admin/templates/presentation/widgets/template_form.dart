import 'package:flutter/material.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/core/utils/validators.dart';
import 'package:frontend_admin/core/widgets/app_button.dart';
import 'package:frontend_admin/core/widgets/app_dropdown.dart';
import 'package:frontend_admin/core/widgets/app_text_field.dart';
import 'package:frontend_admin/features/admin/templates/domain/entities/template.dart';

class TemplateForm extends StatefulWidget {
  final Template? initialTemplate;
  final bool isLoading;
  final Function(Template) onSave;

  const TemplateForm({
    super.key,
    this.initialTemplate,
    this.isLoading = false,
    required this.onSave,
  });

  @override
  State<TemplateForm> createState() => _TemplateFormState();
}

class _TemplateFormState extends State<TemplateForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late final TextEditingController _colorController;
  String _category = 'Classic';
  String _status = 'Active';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialTemplate?.name ?? '',
    );
    _descController = TextEditingController(
      text: widget.initialTemplate?.description ?? '',
    );
    _colorController = TextEditingController(
      text: widget.initialTemplate?.previewColor ?? '#4F46E5',
    );
    if (widget.initialTemplate != null) {
      _category = widget.initialTemplate!.category;
      _status = widget.initialTemplate!.status;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final template = Template(
        id:
            widget.initialTemplate?.id ??
            'tpl_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        category: _category,
        status: _status,
        usageCount: widget.initialTemplate?.usageCount ?? 0,
        previewColor: _colorController.text.trim(),
        createdAt: widget.initialTemplate?.createdAt ?? DateTime.now(),
      );
      widget.onSave(template);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: 'Template Name',
            hintText: 'e.g. ATS Executive',
            controller: _nameController,
            validator: (v) => Validators.validateRequired(v, 'Template Name'),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Description',
            hintText: 'ATS optimization features & target audience summary...',
            controller: _descController,
            maxLines: 3,
            validator: (v) => Validators.validateRequired(v, 'Description'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppDropdown<String>(
                  label: 'Category',
                  value: _category,
                  items: const [
                    DropdownMenuItem(value: 'Classic', child: Text('Classic')),
                    DropdownMenuItem(
                      value: 'Professional',
                      child: Text('Professional'),
                    ),
                    DropdownMenuItem(value: 'Fresher', child: Text('Fresher')),
                    DropdownMenuItem(
                      value: 'Experienced',
                      child: Text('Experienced'),
                    ),
                  ],
                  onChanged: (v) => setState(() => _category = v ?? 'Classic'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppDropdown<String>(
                  label: 'Status',
                  value: _status,
                  items: const [
                    DropdownMenuItem(value: 'Active', child: Text('Active')),
                    DropdownMenuItem(
                      value: 'Inactive',
                      child: Text('Inactive'),
                    ),
                  ],
                  onChanged: (v) => setState(() => _status = v ?? 'Active'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Accent Color Hex',
            hintText: '#4F46E5',
            controller: _colorController,
            prefixIcon: const Icon(
              Icons.palette_outlined,
              size: 20,
              color: AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 24),
          AppButton(
            text: widget.initialTemplate != null
                ? 'Update Template'
                : 'Create Template',
            isLoading: widget.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
