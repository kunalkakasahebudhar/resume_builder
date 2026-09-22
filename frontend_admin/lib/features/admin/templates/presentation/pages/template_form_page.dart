import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';
import 'package:frontend_admin/core/widgets/app_loader.dart';
import 'package:frontend_admin/features/admin/dashboard/presentation/widgets/admin_layout.dart';
import 'package:frontend_admin/features/admin/templates/presentation/providers/template_provider.dart';
import 'package:frontend_admin/features/admin/templates/presentation/widgets/template_form.dart';

class TemplateFormPage extends ConsumerStatefulWidget {
  final String? templateId;

  const TemplateFormPage({super.key, this.templateId});

  @override
  ConsumerState<TemplateFormPage> createState() => _TemplateFormPageState();
}

class _TemplateFormPageState extends ConsumerState<TemplateFormPage> {
  @override
  void initState() {
    super.initState();
    if (widget.templateId != null && widget.templateId != 'new') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(templatesProvider.notifier)
            .loadTemplateById(widget.templateId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(templatesProvider);
    final isEdit = widget.templateId != null && widget.templateId != 'new';

    return AdminLayout(
      title: isEdit ? 'Edit Template' : 'Create New Template',
      currentPath: '/admin/templates',
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => context.go('/admin/templates'),
                ),
                const SizedBox(width: 8),
                Text('Back to Templates', style: AppTextStyles.titleMedium()),
              ],
            ),
            const SizedBox(height: 16),
            if (isEdit &&
                state.isActionLoading &&
                state.selectedTemplate == null)
              const Expanded(
                child: AppLoader(message: 'Loading template details...'),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.borderLight),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: TemplateForm(
                          initialTemplate: isEdit
                              ? state.selectedTemplate
                              : null,
                          isLoading: state.isActionLoading,
                          onSave: (template) async {
                            final ok = await ref
                                .read(templatesProvider.notifier)
                                .saveTemplate(template, isEdit: isEdit);
                            if (ok && context.mounted) {
                              context.go('/admin/templates');
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
