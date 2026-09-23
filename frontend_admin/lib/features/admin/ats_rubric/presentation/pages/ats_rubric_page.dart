import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';
import 'package:frontend_admin/core/widgets/app_badge.dart';
import 'package:frontend_admin/core/widgets/app_button.dart';
import 'package:frontend_admin/core/widgets/app_card.dart';
import 'package:frontend_admin/features/admin/dashboard/presentation/widgets/admin_layout.dart';
import '../providers/ats_rubric_provider.dart';

class AtsRubricPage extends ConsumerStatefulWidget {
  const AtsRubricPage({super.key});

  @override
  ConsumerState<AtsRubricPage> createState() => _AtsRubricPageState();
}

class _AtsRubricPageState extends ConsumerState<AtsRubricPage> {
  final TextEditingController _verbController = TextEditingController();
  final TextEditingController _buzzwordController = TextEditingController();

  @override
  void dispose() {
    _verbController.dispose();
    _buzzwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(atsRubricProvider);
    final notifier = ref.read(atsRubricProvider.notifier);
    final config = state.config;

    return AdminLayout(
      title: 'ATS Scoring Rubric & Weights',
      currentPath: '/admin/ats-rubric',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Status Bar
            _buildCalibrationBanner(config),
            const SizedBox(height: 20),

            // Error or Success Banner
            if (state.errorMessage != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppColors.error, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        state.errorMessage!,
                        style: const TextStyle(
                          color: Color(0xFF991B1B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Main 2-Column Calibrator Layout
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 950;
                return Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column: 5-Category Weight Sliders
                    Expanded(
                      flex: isWide ? 6 : 0,
                      child: _buildWeightSliders(config, notifier),
                    ),
                    SizedBox(width: isWide ? 24 : 0, height: isWide ? 0 : 24),

                    // Right Column: Score Tiers, Word Libraries & Penalty Rules
                    Expanded(
                      flex: isWide ? 5 : 0,
                      child: Column(
                        children: [
                          _buildScoreTiersCard(config, notifier),
                          const SizedBox(height: 20),
                          _buildWordLibrariesCard(config, notifier),
                          const SizedBox(height: 20),
                          _buildPenaltyRulesCard(config, notifier),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Bottom Actions Bar
            AppCard(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
                  return Flex(
                    direction: isWide ? Axis.horizontal : Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppButton(
                        text: 'Reset to Factory Defaults',
                        variant: ButtonVariant.outline,
                        onPressed: () => notifier.resetToDefaults(),
                      ),
                      SizedBox(height: isWide ? 0 : 12),
                      AppButton(
                        text: state.isSaving
                            ? 'Calibrating Engines...'
                            : 'Deploy Live ATS Rubric',
                        icon: const Icon(Icons.tune_rounded, size: 18),
                        isLoading: state.isSaving,
                        onPressed: () async {
                          final success = await notifier.saveConfig();
                          if (success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'ATS Scoring Rubric calibrated and deployed to live analyzer.',
                                ),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalibrationBanner(dynamic config) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.analytics_rounded,
                color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Production ATS Scoring Engine (v2.4)',
                  style: AppTextStyles.bodyMedium(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  'Last calibrated by ${config.calibratedBy} on ${DateFormat('dd MMM yyyy, HH:mm').format(config.lastCalibratedAt)}',
                  style: AppTextStyles.caption(
                      color: AppColors.textSecondary(context)),
                ),
              ],
            ),
          ),
          const AppBadge(
            text: 'Live Scoring Active',
            variant: BadgeVariant.success,
          ),
        ],
      ),
    );
  }

  Widget _buildWeightSliders(dynamic config, AtsRubricNotifier notifier) {
    final total = config.totalWeight;
    final is100 = config.isValid;

    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category Weights Distribution',
                      style: AppTextStyles.h3()),
                  const SizedBox(height: 4),
                  Text(
                    'All 5 category weights must sum to exactly 100.0%',
                    style: AppTextStyles.caption(
                        color: AppColors.textSecondary(context)),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: is100
                      ? const Color(0xFFDCFCE7).withOpacity(0.3)
                      : const Color(0xFFFEE2E2).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: is100
                        ? const Color(0xFF86EFAC)
                        : const Color(0xFFFCA5A5),
                  ),
                ),
                child: Text(
                  'Total: ${total.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: is100
                        ? const Color(0xFF15803D)
                        : const Color(0xFFB91C1C),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 1. Formatting & Layout Structure
          _buildSliderItem(
            title: '1. Formatting & Parsing Structure',
            description:
                'Evaluates font compatibility, single-column margins, zero embedded text-boxes or complex shapes.',
            value: config.formattingWeight,
            icon: Icons.view_agenda_outlined,
            onChanged: (v) => notifier.updateWeights(formatting: v),
          ),
          const Divider(height: 28),

          // 2. Keyword & Hard Skills Density
          _buildSliderItem(
            title: '2. Keywords & Hard Skills Match',
            description:
                'Frequency, semantic placement in experience sections, and ATS keyword extraction density.',
            value: config.keywordWeight,
            icon: Icons.tag_rounded,
            onChanged: (v) => notifier.updateWeights(keyword: v),
          ),
          const Divider(height: 28),

          // 3. Quantifiable Impact & STAR Metrics
          _buildSliderItem(
            title: '3. Quantifiable Impact & STAR Metrics',
            description:
                'Percentage of bullet points containing measurable numbers, currency, or performance % increases.',
            value: config.quantifiableImpactWeight,
            icon: Icons.insights_rounded,
            onChanged: (v) => notifier.updateWeights(impact: v),
          ),
          const Divider(height: 28),

          // 4. Section Completeness
          _buildSliderItem(
            title: '4. Section Completeness & Standard Headings',
            description:
                'Ensures required sections exist (Experience, Education, Skills, Summary, Contact Info).',
            value: config.completenessWeight,
            icon: Icons.check_circle_outline_rounded,
            onChanged: (v) => notifier.updateWeights(completeness: v),
          ),
          const Divider(height: 28),

          // 5. Length & Brevity
          _buildSliderItem(
            title: '5. Length, Brevity & ATS Density',
            description:
                'Optimal word count (450 - 800 words), avoiding excessive whitespace and filler content.',
            value: config.brevityWeight,
            icon: Icons.format_align_left_rounded,
            onChanged: (v) => notifier.updateWeights(brevity: v),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderItem({
    required String title,
    required String description,
    required double value,
    required IconData icon,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: AppTextStyles.bodyMedium(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Text(
              '${value.toStringAsFixed(0)}%',
              style: AppTextStyles.bodyMedium(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: AppTextStyles.caption(color: AppColors.textSecondary(context)),
        ),
        const SizedBox(height: 8),
        Slider(
          value: value,
          min: 0,
          max: 60,
          divisions: 60,
          activeColor: AppColors.primary,
          onChanged: (val) => onChanged(val.roundToDouble()),
        ),
      ],
    );
  }

  Widget _buildScoreTiersCard(dynamic config, AtsRubricNotifier notifier) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Score Tier Classification Thresholds',
              style: AppTextStyles.h3()),
          const SizedBox(height: 6),
          Text(
            'Calibrates color bands and readiness advice displayed to job seekers.',
            style: AppTextStyles.caption(color: AppColors.textSecondary(context)),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 500;
              final itemWidth = isWide
                  ? (constraints.maxWidth - 20) / 3
                  : constraints.maxWidth;

              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  SizedBox(
                    width: itemWidth,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF15803D).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: const Color(0xFF15803D).withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '🟢 Ready to Apply',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF15803D),
                                fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Score ≥ ${config.strongTierThreshold}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF15803D)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD97706).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: const Color(0xFFD97706).withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '🟡 Needs Polish',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFD97706),
                                fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${config.moderateTierThreshold} - ${config.strongTierThreshold - 1}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD97706)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: const Color(0xFFDC2626).withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '🔴 Major Rework',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFDC2626),
                                fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '0 - ${config.moderateTierThreshold - 1}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFDC2626)),
                          ),
                        ],
                      ),
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

  Widget _buildWordLibrariesCard(dynamic config, AtsRubricNotifier notifier) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Power Action Verbs (+Score)', style: AppTextStyles.h3()),
              IconButton(
                icon: const Icon(Icons.add_circle_outline,
                    color: AppColors.primary),
                tooltip: 'Add Power Verb',
                onPressed: () => _showAddWordDialog(
                  title: 'Add Power Action Verb',
                  hint: 'e.g. Spearheaded, Orchestrated',
                  controller: _verbController,
                  onAdd: (w) => notifier.addPowerVerb(w),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: (config.powerActionVerbs as List<String>).map((v) {
              return Chip(
                label: Text(v, style: const TextStyle(fontSize: 11)),
                backgroundColor: const Color(0xFFECFDF5),
                side: const BorderSide(color: Color(0xFFA7F3D0)),
                deleteIcon: const Icon(Icons.close, size: 14),
                onDeleted: () => notifier.removePowerVerb(v),
              );
            }).toList(),
          ),
          const Divider(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Penalized Buzzwords (-Score)', style: AppTextStyles.h3()),
              IconButton(
                icon: const Icon(Icons.add_circle_outline,
                    color: AppColors.error),
                tooltip: 'Add Penalized Word',
                onPressed: () => _showAddWordDialog(
                  title: 'Add Cliché / Penalized Word',
                  hint: 'e.g. Synergy, Go-getter',
                  controller: _buzzwordController,
                  onAdd: (w) => notifier.addBuzzword(w),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: (config.penalizedBuzzwords as List<String>).map((w) {
              return Chip(
                label: Text(w, style: const TextStyle(fontSize: 11)),
                backgroundColor: const Color(0xFFFEF2F2),
                side: const BorderSide(color: Color(0xFFFECACA)),
                deleteIcon: const Icon(Icons.close, size: 14),
                onDeleted: () => notifier.removeBuzzword(w),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPenaltyRulesCard(dynamic config, AtsRubricNotifier notifier) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Strict ATS Compliance Penalty Toggles',
              style: AppTextStyles.h3()),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Penalize Multi-Column Tables (-15 pts)'),
            subtitle: const Text(
                'ATS parsers like Taleo and Workday fail on nested HTML/PDF tables.'),
            value: config.enableTablePenalty,
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            onChanged: (val) => notifier.toggleTablePenalty(val),
          ),
          const Divider(height: 16),
          SwitchListTile(
            title: const Text('Penalize Non-Standard Icon Headings (-10 pts)'),
            subtitle: const Text(
                'Graphics or SVG icons in section headers break text stream extraction.'),
            value: config.enableIconHeaderPenalty,
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            onChanged: (val) => notifier.toggleIconPenalty(val),
          ),
        ],
      ),
    );
  }

  void _showAddWordDialog({
    required String title,
    required String hint,
    required TextEditingController controller,
    required Function(String) onAdd,
  }) {
    controller.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: AppTextStyles.h3()),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              onAdd(controller.text);
              Navigator.of(ctx).pop();
            },
            child: const Text('Add Word'),
          ),
        ],
      ),
    );
  }
}
