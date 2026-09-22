import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_card.dart';
import 'package:frontend_userside/core/widgets/app_text_field.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/certification.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';
import 'package:frontend_userside/features/user/resume/presentation/widgets/add_item_button.dart';
import 'package:frontend_userside/features/user/resume/presentation/widgets/reorderable_section_list.dart';

class CertificationForm extends ConsumerWidget {
  const CertificationForm({super.key});

  void _addCertification(WidgetRef ref) {
    final currentList = ref.read(activeResumeProvider)?.certifications ?? [];
    final newCert = Certification(
      id: 'cert_${DateTime.now().millisecondsSinceEpoch}',
      name: '',
      issuingOrganization: '',
      issueDate: '',
    );
    ref.read(activeResumeProvider.notifier).updateCertifications([
      ...currentList,
      newCert,
    ]);
  }

  void _updateCertification(WidgetRef ref, int index, Certification updated) {
    final currentList = List<Certification>.from(
      ref.read(activeResumeProvider)?.certifications ?? [],
    );
    if (index >= 0 && index < currentList.length) {
      currentList[index] = updated;
      ref.read(activeResumeProvider.notifier).updateCertifications(currentList);
    }
  }

  void _deleteCertification(WidgetRef ref, int index) {
    final currentList = List<Certification>.from(
      ref.read(activeResumeProvider)?.certifications ?? [],
    );
    if (index >= 0 && index < currentList.length) {
      currentList.removeAt(index);
      ref.read(activeResumeProvider.notifier).updateCertifications(currentList);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resume = ref.watch(activeResumeProvider);
    final certifications = resume?.certifications ?? [];
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Certifications',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Industry certifications and professional credentials',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${certifications.length} credentials',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ReorderableSectionList<Certification>(
            items: certifications,
            emptyMessage: 'No certifications added yet. Click below to add.',
            onReorder: (oldIndex, newIndex) {
              final list = List<Certification>.from(certifications);
              if (newIndex > oldIndex) newIndex--;
              final item = list.removeAt(oldIndex);
              list.insert(newIndex, item);
              ref
                  .read(activeResumeProvider.notifier)
                  .updateCertifications(list);
            },
            itemBuilder: (context, index, cert) {
              return _CertItemCard(
                cert: cert,
                onChanged: (updated) =>
                    _updateCertification(ref, index, updated),
                onDelete: () => _deleteCertification(ref, index),
              );
            },
          ),
          const SizedBox(height: 16),
          AddItemButton(
            label: 'Add Certification',
            onPressed: () => _addCertification(ref),
          ),
        ],
      ),
    );
  }
}

class _CertItemCard extends StatefulWidget {
  final Certification cert;
  final ValueChanged<Certification> onChanged;
  final VoidCallback onDelete;

  const _CertItemCard({
    required this.cert,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<_CertItemCard> createState() => _CertItemCardState();
}

class _CertItemCardState extends State<_CertItemCard> {
  late final TextEditingController _nameController;
  late final TextEditingController _orgController;
  late final TextEditingController _dateController;
  late final TextEditingController _idController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.cert.name);
    _orgController = TextEditingController(
      text: widget.cert.issuingOrganization,
    );
    _dateController = TextEditingController(text: widget.cert.issueDate);
    _idController = TextEditingController(text: widget.cert.credentialId ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _orgController.dispose();
    _dateController.dispose();
    _idController.dispose();
    super.dispose();
  }

  void _notify() {
    widget.onChanged(
      widget.cert.copyWith(
        name: _nameController.text.trim(),
        issuingOrganization: _orgController.text.trim(),
        issueDate: _dateController.text.trim(),
        credentialId: _idController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.drag_indicator_rounded,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.cert.name.isNotEmpty
                            ? widget.cert.name
                            : 'New Certification',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: Colors.red,
                ),
                onPressed: widget.onDelete,
                tooltip: 'Delete Certification',
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Certification Name *',
            hint: 'AWS Certified Solutions Architect',
            controller: _nameController,
            onChanged: (_) => _notify(),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 400;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: isWide
                        ? (constraints.maxWidth - 12) / 2
                        : constraints.maxWidth,
                    child: AppTextField(
                      label: 'Issuing Organization *',
                      hint: 'Amazon Web Services',
                      controller: _orgController,
                      onChanged: (_) => _notify(),
                    ),
                  ),
                  SizedBox(
                    width: isWide
                        ? (constraints.maxWidth - 12) / 2
                        : constraints.maxWidth,
                    child: AppTextField(
                      label: 'Issue Date',
                      hint: 'Mar 2023',
                      controller: _dateController,
                      onChanged: (_) => _notify(),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
