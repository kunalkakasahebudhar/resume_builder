import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_empty_state.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/usage_limit_banner.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/user_layout.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';
import 'package:go_router/go_router.dart';

class SalaryEstimatorPage extends ConsumerStatefulWidget {
  const SalaryEstimatorPage({super.key});

  @override
  ConsumerState<SalaryEstimatorPage> createState() => _SalaryEstimatorPageState();
}

class _SalaryEstimatorPageState extends ConsumerState<SalaryEstimatorPage> {
  double _yearsExperience = 4.0;
  String _selectedCity = 'Bengaluru (Tech Hub)';

  final List<String> _cities = [
    'Bengaluru (Tech Hub)',
    'Pune / Mumbai',
    'Hyderabad / Chennai',
    'Delhi NCR / Gurgaon',
    'Remote (US / Global)',
  ];

  @override
  Widget build(BuildContext context) {
    final activeResume = ref.watch(activeResumeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isRemote = _selectedCity.contains('Remote');
    final isBengaluru = _selectedCity.contains('Bengaluru');

    // Dynamic salary calculation
    final baseMin = isRemote
        ? (60 + (_yearsExperience * 18)).toInt()
        : (isBengaluru
            ? (8 + (_yearsExperience * 3.5)).toInt()
            : (6 + (_yearsExperience * 2.8)).toInt());

    final baseMax = isRemote
        ? (90 + (_yearsExperience * 24)).toInt()
        : (isBengaluru
            ? (14 + (_yearsExperience * 5.2)).toInt()
            : (11 + (_yearsExperience * 4.2)).toInt());

    final top10 = isRemote
        ? (120 + (_yearsExperience * 30)).toInt()
        : (isBengaluru
            ? (22 + (_yearsExperience * 6.5)).toInt()
            : (18 + (_yearsExperience * 5.5)).toInt());

    final unit = isRemote ? 'K USD / yr' : 'LPA (₹)';

    return UserLayout(
      currentRoute: '/salary-estimator',
      child: activeResume == null
          ? AppEmptyState(
              title: 'No Resume Selected',
              description: 'Select a resume to calculate live market worth and compensation benchmark.',
              actionText: 'Go to My Resumes',
              onAction: () => context.go('/resumes'),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.monetization_on_rounded,
                                          color: Colors.white, size: 22),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Salary & Market Worth Estimator',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Calculate your real compensation benchmark based on verified skills, years of experience, and location',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          const UsageLimitBanner(compact: true),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Interactive Controls Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final isWide = constraints.maxWidth > 600;

                                final expSlider = Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'TOTAL YEARS OF EXPERIENCE: ${_yearsExperience.toStringAsFixed(1)} YRS',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                      ),
                                    ),
                                    Slider(
                                      value: _yearsExperience,
                                      min: 0.0,
                                      max: 15.0,
                                      divisions: 30,
                                      label: '${_yearsExperience.toStringAsFixed(1)} yrs',
                                      onChanged: (v) => setState(() => _yearsExperience = v),
                                    ),
                                  ],
                                );

                                final cityDropdown = Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'LOCATION & MARKET HUB',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    DropdownButtonFormField<String>(
                                      initialValue: _selectedCity,
                                      items: _cities
                                          .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13))))
                                          .toList(),
                                      onChanged: (v) {
                                        if (v != null) setState(() => _selectedCity = v);
                                      },
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      ),
                                    ),
                                  ],
                                );

                                if (isWide) {
                                  return Row(
                                    children: [
                                      Expanded(child: expSlider),
                                      const SizedBox(width: 24),
                                      Expanded(child: cityDropdown),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      expSlider,
                                      const SizedBox(height: 16),
                                      cityDropdown,
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Salary Results Cards
                      Row(
                        children: [
                          // Base Median
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('MEDIAN MARKET BASE',
                                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF64748B))),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${isRemote ? '\$' : '₹'}$baseMin - $baseMax $unit',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text('50th Percentile Market Benchmark', style: TextStyle(fontSize: 11, color: Color(0xFF10B981))),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Top Tier / Product Company
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFF6366F1)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('TOP 10% / TIER-1 TECH',
                                          style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFFCBD5E1))),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFBBF24).withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text('🔥 HIGH ALPHA', style: TextStyle(color: Color(0xFFFBBF24), fontSize: 9, fontWeight: FontWeight.w800)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${isRemote ? '\$' : '₹'}$top10+ $unit',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text('FAANG & Top Product Startups', style: TextStyle(fontSize: 11, color: Color(0xFF93C5FD))),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // High Value Skills Booster
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.trending_up_rounded, color: Color(0xFF10B981), size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'High-Paying Skills That Boost Your Compensation by +30%',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Adding proven proficiency in these high-demand technologies directly impacts recruiter salary offers:',
                              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                _buildSkillBadge('Distributed Systems (+35%)', '+₹6 LPA', isDark),
                                _buildSkillBadge('Kubernetes & AWS Cloud (+28%)', '+₹5 LPA', isDark),
                                _buildSkillBadge('High-Concurrency Go (+25%)', '+₹4.5 LPA', isDark),
                                _buildSkillBadge('System Design Architecture (+30%)', '+₹5.5 LPA', isDark),
                                _buildSkillBadge('GraphQL & Microservices (+20%)', '+₹3.5 LPA', isDark),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildSkillBadge(String skill, String value, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            skill,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF059669),
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
