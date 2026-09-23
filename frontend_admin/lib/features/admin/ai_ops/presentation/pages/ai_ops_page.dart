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
import '../../domain/entities/ai_tool_config.dart';
import '../providers/ai_ops_provider.dart';

class AiOpsPage extends ConsumerStatefulWidget {
  const AiOpsPage({super.key});

  @override
  ConsumerState<AiOpsPage> createState() => _AiOpsPageState();
}

class _AiOpsPageState extends ConsumerState<AiOpsPage> {
  late TextEditingController _promptController;
  late TextEditingController _maxTokensController;
  late TextEditingController _freeLimitController;
  late TextEditingController _proLimitController;

  String? _currentToolId;
  String _selectedPrimaryModel = 'gemini-1.5-pro';
  String _selectedFallbackModel = 'gpt-4o';
  double _temperature = 0.2;

  final List<String> _availableModels = [
    'gemini-1.5-pro',
    'gemini-1.5-flash',
    'gpt-4o',
    'gpt-4o-mini',
    'claude-3-5-sonnet',
  ];

  @override
  void initState() {
    super.initState();
    _promptController = TextEditingController();
    _maxTokensController = TextEditingController();
    _freeLimitController = TextEditingController();
    _proLimitController = TextEditingController();
  }

  void _syncControllers(AiToolConfig tool) {
    if (_currentToolId != tool.id) {
      _currentToolId = tool.id;
      _promptController.text = tool.systemPrompt;
      _maxTokensController.text = tool.maxTokens.toString();
      _freeLimitController.text = tool.freeTierDailyLimit.toString();
      _proLimitController.text = tool.proTierDailyLimit.toString();
      _selectedPrimaryModel = tool.primaryModel;
      _selectedFallbackModel = tool.fallbackModel;
      _temperature = tool.temperature;
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    _maxTokensController.dispose();
    _freeLimitController.dispose();
    _proLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiOpsProvider);
    final notifier = ref.read(aiOpsProvider.notifier);
    final selectedTool = state.selectedTool;

    if (selectedTool != null) {
      _syncControllers(selectedTool);
    }

    return AdminLayout(
      title: 'AI Ops & Prompt Studio',
      currentPath: '/admin/ai-ops',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emergency Kill Switch Banner
            _buildKillSwitchBanner(state, notifier),
            const SizedBox(height: 20),

            // AI Telemetry Dashboard Metrics
            _buildTelemetryCards(state),
            const SizedBox(height: 24),

            // Main Editor Section (Two Columns)
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 950;
                return Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column: AI Feature Tool List
                    SizedBox(
                      width: isWide ? 340 : double.infinity,
                      child: _buildToolList(state, notifier),
                    ),
                    SizedBox(width: isWide ? 24 : 0, height: isWide ? 0 : 24),

                    // Right Column: Configuration & Prompt Sandbox
                    Expanded(
                      flex: isWide ? 1 : 0,
                      child: selectedTool == null
                          ? const SizedBox()
                          : _buildConfigStudio(selectedTool, state, notifier),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKillSwitchBanner(AiOpsState state, AiOpsNotifier notifier) {
    final isEnabled = state.globalAiEnabled;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bannerBg = isEnabled
        ? (isDark ? const Color(0xFF052E16) : const Color(0xFFF0FDF4))
        : (isDark ? const Color(0xFF450A0A) : const Color(0xFFFEF2F2));
    final bannerBorder = isEnabled
        ? (isDark ? const Color(0xFF166534) : const Color(0xFFBBF7D0))
        : (isDark ? const Color(0xFF991B1B) : const Color(0xFFFECACA));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: bannerBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: bannerBorder,
          width: 1.5,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 750;
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
                      color: isEnabled ? AppColors.success : AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isEnabled ? Icons.bolt_rounded : Icons.power_off_rounded,
                      color: Colors.white,
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
                                isEnabled
                                    ? 'GLOBAL AI GATEWAY: ACTIVE & OPERATIONAL'
                                    : 'EMERGENCY SHUTDOWN: GLOBAL AI PAUSED',
                                style: AppTextStyles.bodyMedium(
                                  fontWeight: FontWeight.w700,
                                  color: isEnabled
                                      ? (isDark
                                          ? const Color(0xFF86EFAC)
                                          : const Color(0xFF166534))
                                      : (isDark
                                          ? const Color(0xFFFCA5A5)
                                          : const Color(0xFF991B1B)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            AppBadge(
                              text: isEnabled ? 'ONLINE' : 'STOPPED',
                              variant: isEnabled
                                  ? BadgeVariant.success
                                  : BadgeVariant.error,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isEnabled
                              ? 'All JD Matcher, Cover Letter, STAR Kit, and Salary Estimator endpoints are responding normally.'
                              : 'All user AI prompts are currently returning fallback deterministic suggestions. Click to re-enable.',
                          style: AppTextStyles.bodySmall(
                            color: isEnabled
                                ? (isDark
                                    ? const Color(0xFF4ADE80)
                                    : const Color(0xFF15803D))
                                : (isDark
                                    ? const Color(0xFFF87171)
                                    : const Color(0xFFB91C1C)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isEnabled ? AppColors.error : AppColors.success,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: Icon(
                  isEnabled
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  size: 18,
                ),
                label: Text(
                  isEnabled ? 'Emergency Pause' : 'Restore AI Gateway',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                onPressed: () async {
                  final confirmed = await ConfirmDialog.show(
                    context: context,
                    title: isEnabled
                        ? 'Activate Emergency AI Kill-Switch?'
                        : 'Restore Global AI Gateway?',
                    message: isEnabled
                        ? 'This will immediately halt all AI inference calls across JD Matcher, Cover Letter, and STAR Optimizer for all users.'
                        : 'This will re-enable live AI inference requests across all active platform features.',
                    confirmText:
                        isEnabled ? 'Emergency Pause' : 'Restore AI Gateway',
                    type: isEnabled
                        ? ConfirmDialogType.danger
                        : ConfirmDialogType.success,
                  );
                  if (confirmed == true) {
                    await notifier.toggleGlobalKillSwitch(!isEnabled);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTelemetryCards(AiOpsState state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        final cardWidth = isWide
            ? (constraints.maxWidth - 48) / 4
            : (constraints.maxWidth - 16) / 2;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildTelemetryTile(
              title: 'Total AI Invocations (24h)',
              value:
                  '${state.totalCalls24h.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
              subtitle: '+18.4% vs yesterday',
              icon: Icons.auto_awesome,
              iconColor: AppColors.primary,
              width: cardWidth,
            ),
            _buildTelemetryTile(
              title: 'Avg Gateway Latency',
              value: '${state.avgLatencyTotal.toInt()} ms',
              subtitle: 'p95: 1,840 ms | p99: 2,410 ms',
              icon: Icons.speed_rounded,
              iconColor: const Color(0xFF0284C7),
              width: cardWidth,
            ),
            _buildTelemetryTile(
              title: 'Est. API Cost (Today)',
              value: '\$${state.estCostToday.toStringAsFixed(2)}',
              subtitle: 'Daily budget cap: \$100.00',
              icon: Icons.attach_money_rounded,
              iconColor: AppColors.success,
              width: cardWidth,
            ),
            _buildTelemetryTile(
              title: 'Global Error Rate',
              value: '${state.globalErrorRate}%',
              subtitle: 'Zero rate-limit timeouts',
              icon: Icons.shield_outlined,
              iconColor: const Color(0xFF10B981),
              width: cardWidth,
            ),
          ],
        );
      },
    );
  }

  Widget _buildTelemetryTile({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required double width,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.caption(
                    color: AppColors.textSecondary(context),
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.h2(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style:
                AppTextStyles.caption(color: AppColors.textSecondary(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildToolList(AiOpsState state, AiOpsNotifier notifier) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AI Features & Services', style: AppTextStyles.h3()),
          const SizedBox(height: 6),
          Text(
            'Select a feature to configure models, system prompts, and rate limits.',
            style:
                AppTextStyles.caption(color: AppColors.textSecondary(context)),
          ),
          const SizedBox(height: 16),
          ...state.tools.map((tool) {
            final isSelected = tool.id == state.selectedToolId;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => notifier.selectTool(tool.id),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.08)
                        : AppColors.surface(context),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.border(context),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              tool.name,
                              style: AppTextStyles.bodyMedium(
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppColors.primary
                                    : null,
                              ),
                            ),
                          ),
                          Switch(
                            value: tool.isEnabled,
                            activeColor: AppColors.primary,
                            onChanged: (val) =>
                                notifier.toggleToolEnabled(tool.id, val),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Model: ${tool.primaryModel} • ${tool.avgLatencyMs.toInt()}ms',
                        style: AppTextStyles.caption(
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.card(context),
                              borderRadius: BorderRadius.circular(4),
                              border:
                                  Border.all(color: AppColors.border(context)),
                            ),
                            child: Text(
                              '${tool.dailyUsageCount} calls/day',
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF059669).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${tool.errorRatePercent}% err',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF059669),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildConfigStudio(
      AiToolConfig tool, AiOpsState state, AiOpsNotifier notifier) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tool.name, style: AppTextStyles.h2()),
                  const SizedBox(height: 4),
                  Text(
                    tool.description,
                    style: AppTextStyles.bodySmall(
                        color: AppColors.textSecondaryLight),
                  ),
                ],
              ),
              AppBadge(
                text: tool.isEnabled ? 'Active' : 'Disabled',
                variant:
                    tool.isEnabled ? BadgeVariant.success : BadgeVariant.error,
              ),
            ],
          ),
          const Divider(height: 32),

          // Model & Temperature Parameters
          Text('Model Architecture & Hyperparameters',
              style: AppTextStyles.h3()),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              return Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                children: [
                  // Primary Model
                  Expanded(
                    flex: isWide ? 1 : 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Primary AI Model', style: AppTextStyles.label()),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border(context)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _selectedPrimaryModel,
                              items: _availableModels.map((m) {
                                return DropdownMenuItem(
                                    value: m, child: Text(m));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedPrimaryModel = val);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),

                  // Fallback Model
                  Expanded(
                    flex: isWide ? 1 : 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fallback Model (Failover)',
                            style: AppTextStyles.label()),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border(context)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _selectedFallbackModel,
                              items: _availableModels.map((m) {
                                return DropdownMenuItem(
                                    value: m, child: Text(m));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedFallbackModel = val);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),

          // Temperature Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Temperature (${_temperature.toStringAsFixed(2)})',
                style: AppTextStyles.label(),
              ),
              Text(
                _temperature < 0.3
                    ? 'Deterministic / Strict ATS'
                    : _temperature < 0.7
                        ? 'Balanced Creativity'
                        : 'High Expression',
                style: AppTextStyles.caption(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Slider(
            value: _temperature,
            min: 0.0,
            max: 1.0,
            divisions: 20,
            activeColor: AppColors.primary,
            label: _temperature.toStringAsFixed(2),
            onChanged: (val) => setState(() => _temperature = val),
          ),
          const SizedBox(height: 16),

          // Token Limit & Daily Quota Limits
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              return Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                children: [
                  Expanded(
                    flex: isWide ? 1 : 0,
                    child: AppTextField(
                      label: 'Max Completion Tokens',
                      controller: _maxTokensController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),
                  Expanded(
                    flex: isWide ? 1 : 0,
                    child: AppTextField(
                      label: 'Free Tier Daily Limit (req/user)',
                      controller: _freeLimitController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),
                  Expanded(
                    flex: isWide ? 1 : 0,
                    child: AppTextField(
                      label: 'Pro Plan Daily Limit (req/user)',
                      controller: _proLimitController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              );
            },
          ),
          const Divider(height: 32),

          // System Prompt Editor & Dynamic Variables
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('System Instruction & Prompt Template',
                  style: AppTextStyles.h3()),
              Text(
                'Click variable tag to insert',
                style:
                    AppTextStyles.caption(color: AppColors.textSecondary(context)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Available Variable Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tool.availableVariables.map((v) {
              return ActionChip(
                label: Text(v,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary)),
                backgroundColor: AppColors.primary.withOpacity(0.1),
                side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
                onPressed: () {
                  final text = _promptController.text;
                  final selection = _promptController.selection;
                  final newText = text.replaceRange(
                    selection.start < 0 ? text.length : selection.start,
                    selection.end < 0 ? text.length : selection.end,
                    v,
                  );
                  _promptController.text = newText;
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Multiline System Prompt Field
          TextField(
            controller: _promptController,
            maxLines: 8,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              height: 1.4,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surface(context),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.border(context)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.border(context)),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Test Simulation Box
          if (state.testResponse != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Test Run Response Preview (JSON Sandbox)',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.white, size: 16),
                        onPressed: () => notifier.selectTool(tool.id),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.testResponse!,
                    style: const TextStyle(
                      color: Color(0xFF38BDF8),
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Save & Test Action Buttons
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 500;
              return Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppButton(
                    text: state.isTestingPrompt
                        ? 'Running Model Test...'
                        : 'Test Run Prompt Sandbox',
                    icon: const Icon(Icons.play_arrow_rounded, size: 18),
                    variant: ButtonVariant.outline,
                    isLoading: state.isTestingPrompt,
                    onPressed: () {
                      notifier.testRunPrompt(_promptController.text);
                    },
                  ),
                  SizedBox(height: isWide ? 0 : 12),
                  AppButton(
                    text: 'Save AI Config & Deploy',
                    icon: const Icon(Icons.save_rounded, size: 18),
                    onPressed: () async {
                      final updated = tool.copyWith(
                        primaryModel: _selectedPrimaryModel,
                        fallbackModel: _selectedFallbackModel,
                        temperature: _temperature,
                        maxTokens: int.tryParse(_maxTokensController.text) ??
                            tool.maxTokens,
                        freeTierDailyLimit:
                            int.tryParse(_freeLimitController.text) ??
                                tool.freeTierDailyLimit,
                        proTierDailyLimit:
                            int.tryParse(_proLimitController.text) ??
                                tool.proTierDailyLimit,
                        systemPrompt: _promptController.text,
                      );

                      await notifier.updateToolConfig(updated);

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${tool.name} configuration updated and deployed live.',
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
        ],
      ),
    );
  }
}
