import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';
import 'package:frontend_admin/core/widgets/app_badge.dart';
import 'package:frontend_admin/core/widgets/app_button.dart';
import 'package:frontend_admin/core/widgets/app_card.dart';
import 'package:frontend_admin/core/widgets/app_text_field.dart';
import 'package:frontend_admin/core/widgets/confirm_dialog.dart';
import 'package:frontend_admin/features/admin/dashboard/presentation/widgets/admin_layout.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  int _activeTab = 0; // 0 = Feature Flags, 1 = Platform Config
  final TextEditingController _searchCtrl = TextEditingController();

  late TextEditingController _appNameCtrl;
  late TextEditingController _supportEmailCtrl;
  late TextEditingController _maxFreeCtrl;
  late TextEditingController _maxProCtrl;
  late TextEditingController _rateLimitCtrl;
  late TextEditingController _workersCtrl;

  @override
  void initState() {
    super.initState();
    final config = ref.read(settingsProvider).config;
    _appNameCtrl = TextEditingController(text: config.appName);
    _supportEmailCtrl = TextEditingController(text: config.supportEmail);
    _maxFreeCtrl = TextEditingController(text: config.maxFreeResumes.toString());
    _maxProCtrl = TextEditingController(text: config.maxProResumes.toString());
    _rateLimitCtrl =
        TextEditingController(text: config.aiRequestRateLimitPerMin.toString());
    _workersCtrl =
        TextEditingController(text: config.pdfExportWorkerThreads.toString());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _appNameCtrl.dispose();
    _supportEmailCtrl.dispose();
    _maxFreeCtrl.dispose();
    _maxProCtrl.dispose();
    _rateLimitCtrl.dispose();
    _workersCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return AdminLayout(
      title: 'Platform Settings & Feature Flags',
      currentPath: '/admin/settings',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Maintenance Mode Emergency Control
            _buildMaintenanceCard(state, notifier),
            const SizedBox(height: 20),

            // Tab Navigation
            Row(
              children: [
                _buildTabButton(
                  title: 'Feature Flags & Rollouts',
                  icon: Icons.flag_circle_outlined,
                  isSelected: _activeTab == 0,
                  onTap: () => setState(() => _activeTab = 0),
                ),
                const SizedBox(width: 12),
                _buildTabButton(
                  title: 'Platform Limits & Global Config',
                  icon: Icons.settings_applications_rounded,
                  isSelected: _activeTab == 1,
                  onTap: () => setState(() => _activeTab = 1),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (_activeTab == 0)
              _buildFeatureFlagsTab(state, notifier)
            else
              _buildPlatformConfigTab(state, notifier),
          ],
        ),
      ),
    );
  }

  Widget _buildMaintenanceCard(
      SettingsState state, SettingsNotifier notifier) {
    final isMaintenance = state.config.maintenanceMode;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isMaintenance
        ? (isDark ? const Color(0xFF450A0A) : const Color(0xFFFEF2F2))
        : AppColors.card(context);
    final cardBorder = isMaintenance
        ? (isDark ? const Color(0xFF991B1B) : const Color(0xFFFECACA))
        : AppColors.border(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cardBorder,
          width: isMaintenance ? 1.5 : 1,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;
          return Flex(
            direction: isWide ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: isWide
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMaintenance
                          ? AppColors.error
                          : AppColors.warning.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.construction_rounded,
                      color: isMaintenance ? Colors.white : AppColors.warning,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Global Platform Maintenance Mode',
                                style: AppTextStyles.bodyMedium(
                                  fontWeight: FontWeight.w700,
                                  color: isMaintenance
                                      ? AppColors.error
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            AppBadge(
                              text: isMaintenance
                                  ? 'ACTIVE (USER APP LOCKED)'
                                  : 'NORMAL OPERATION',
                              variant: isMaintenance
                                  ? BadgeVariant.error
                                  : BadgeVariant.success,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isMaintenance
                              ? 'Job seekers visiting the user web app are greeted with the maintenance notice.'
                              : 'All user app traffic, resume editor, and AI services are running normally.',
                          style: AppTextStyles.caption(
                            color: isMaintenance
                                ? (isDark
                                    ? const Color(0xFFFCA5A5)
                                    : const Color(0xFF991B1B))
                                : AppColors.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),
              Switch(
                value: isMaintenance,
                activeColor: AppColors.error,
                onChanged: (val) async {
                  final confirmed = await ConfirmDialog.show(
                    context: context,
                    title: val
                        ? 'Enable Global Maintenance Mode?'
                        : 'Disable Maintenance Mode?',
                    message: val
                        ? 'This will prevent all normal users from logging in or editing resumes. Admin panel will remain accessible.'
                        : 'Normal user access will be immediately restored.',
                    confirmText:
                        val ? 'Enable Maintenance' : 'Disable Maintenance',
                    type: val
                        ? ConfirmDialogType.danger
                        : ConfirmDialogType.success,
                  );
                  if (confirmed == true) {
                    await notifier.toggleMaintenanceMode(val);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF1E293B) : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.border(context).withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? AppColors.primary
                  : AppColors.textSecondary(context),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTextStyles.bodyMedium(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureFlagsTab(
      SettingsState state, SettingsNotifier notifier) {
    return Column(
      children: [
        // Controls
        AppCard(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              return Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                children: [
                  Expanded(
                    flex: isWide ? 3 : 0,
                    child: AppTextField(
                      controller: _searchCtrl,
                      hintText: 'Search feature flags by name or key...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      onChanged: (val) => notifier.setSearchQuery(val),
                    ),
                  ),
                  SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterPill('All Categories', 'all',
                            state.selectedCategory, (c) => notifier.setCategory(c)),
                        const SizedBox(width: 8),
                        _buildFilterPill('AI Suite', 'ai',
                            state.selectedCategory, (c) => notifier.setCategory(c)),
                        const SizedBox(width: 8),
                        _buildFilterPill('Editor & Parser', 'editor',
                            state.selectedCategory, (c) => notifier.setCategory(c)),
                        const SizedBox(width: 8),
                        _buildFilterPill('Growth & Virality', 'growth',
                            state.selectedCategory, (c) => notifier.setCategory(c)),
                        const SizedBox(width: 8),
                        _buildFilterPill('Infrastructure', 'infrastructure',
                            state.selectedCategory, (c) => notifier.setCategory(c)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Flag Cards Grid
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 800;
            final cardWidth = isWide
                ? (constraints.maxWidth - 20) / 2
                : constraints.maxWidth;

            return Wrap(
              spacing: 20,
              runSpacing: 20,
              children: state.filteredFlags.map((flag) {
                return SizedBox(
                  width: cardWidth,
                  child: AppCard(
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
                                    flag.name,
                                    style: AppTextStyles.bodyMedium(
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    flag.key,
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 11,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: flag.isEnabled,
                              activeColor: AppColors.primary,
                              onChanged: (val) =>
                                  notifier.toggleFlag(flag.key, val),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          flag.description,
                          style: AppTextStyles.bodySmall(
                              color: AppColors.textSecondaryLight),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface(context),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: AppColors.border(context)),
                                  ),
                                  child: Text(
                                    flag.category.toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: flag.minPlan == 'pro'
                                        ? const Color(0xFFFFFBEB)
                                        : const Color(0xFFECFDF5),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    flag.minPlan == 'pro'
                                        ? 'PRO ONLY'
                                        : 'ALL USERS',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: flag.minPlan == 'pro'
                                          ? const Color(0xFFB45309)
                                          : const Color(0xFF047857),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Rollout: ${flag.rolloutPercentage}%',
                              style: AppTextStyles.caption(
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Slider(
                          value: flag.rolloutPercentage.toDouble(),
                          min: 0,
                          max: 100,
                          divisions: 20,
                          activeColor: AppColors.primary,
                          onChanged: flag.isEnabled
                              ? (v) => notifier.updateRollout(
                                  flag.key, v.toInt())
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPlatformConfigTab(
      SettingsState state, SettingsNotifier notifier) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Global Platform Quotas & Configuration',
              style: AppTextStyles.h3()),
          const SizedBox(height: 6),
          Text(
            'Configure default user limits, worker pools, and app metadata.',
            style: AppTextStyles.caption(color: AppColors.textSecondaryLight),
          ),
          const Divider(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 650;
              return Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                children: [
                  Expanded(
                    flex: isWide ? 1 : 0,
                    child: AppTextField(
                      label: 'App Display Title',
                      controller: _appNameCtrl,
                    ),
                  ),
                  SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),
                  Expanded(
                    flex: isWide ? 1 : 0,
                    child: AppTextField(
                      label: 'Customer Support Email',
                      controller: _supportEmailCtrl,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 650;
              return Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                children: [
                  Expanded(
                    flex: isWide ? 1 : 0,
                    child: AppTextField(
                      label: 'Max Free Resumes per User',
                      controller: _maxFreeCtrl,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),
                  Expanded(
                    flex: isWide ? 1 : 0,
                    child: AppTextField(
                      label: 'Max Pro Resumes per User',
                      controller: _maxProCtrl,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 650;
              return Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                children: [
                  Expanded(
                    flex: isWide ? 1 : 0,
                    child: AppTextField(
                      label: 'AI Rate Limit (Requests / Min / IP)',
                      controller: _rateLimitCtrl,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),
                  Expanded(
                    flex: isWide ? 1 : 0,
                    child: AppTextField(
                      label: 'PDF Export Worker Pool Threads',
                      controller: _workersCtrl,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                text: 'Save Platform Configuration',
                icon: const Icon(Icons.save_rounded, size: 18),
                onPressed: () async {
                  final newConfig = state.config.copyWith(
                    appName: _appNameCtrl.text.trim(),
                    supportEmail: _supportEmailCtrl.text.trim(),
                    maxFreeResumes: int.tryParse(_maxFreeCtrl.text) ?? 3,
                    maxProResumes: int.tryParse(_maxProCtrl.text) ?? 50,
                    aiRequestRateLimitPerMin:
                        int.tryParse(_rateLimitCtrl.text) ?? 60,
                    pdfExportWorkerThreads:
                        int.tryParse(_workersCtrl.text) ?? 8,
                  );
                  await notifier.updateConfig(newConfig);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Platform settings updated successfully.'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(
    String label,
    String value,
    String current,
    Function(String) onSelect,
  ) {
    final isSelected = current == value;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => onSelect(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border(context),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.textSecondary(context),
          ),
        ),
      ),
    );
  }
}
