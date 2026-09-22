import 'package:flutter/material.dart';

class LandingComparisonSection extends StatelessWidget {
  const LandingComparisonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final comparisonItems = [
      _ComparisonRow(
        feature: 'ATS Parsing Accuracy',
        resumeForge: '100% Single-Column Layouts (Zero parser drops)',
        traditional: 'Fails in 75% of Taleo & Workday parser scans',
      ),
      _ComparisonRow(
        feature: 'Live ATS 100-Point Score',
        resumeForge: 'Real-time score breakdown with 1-click recommendations',
        traditional: 'Zero scoring feedback or ATS guidance',
      ),
      _ComparisonRow(
        feature: 'Job Description Matcher',
        resumeForge: 'Scan any JD & highlight missing critical tech stack keywords',
        traditional: 'Manual guesswork and trial-and-error placement',
      ),
      _ComparisonRow(
        feature: 'STAR Bullet Optimization',
        resumeForge: 'AI action-verb & quantified metric generator (STAR method)',
        traditional: 'Generic lorem-ipsum dummy descriptions',
      ),
      _ComparisonRow(
        feature: 'PDF Export Integrity',
        resumeForge: 'Clean vector PDF with searchable text and zero watermarks',
        traditional: 'Bloated canvas images with unparseable text blocks',
      ),
      _ComparisonRow(
        feature: 'All-in-One Career Suite',
        resumeForge: 'Cover Letter + STAR Interview Q&A + Salary Benchmarks',
        traditional: 'Basic static document editor only',
      ),
    ];

    return Container(
      width: double.infinity,
      color: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(vertical: 88, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF4F46E5).withValues(alpha: 0.3)),
                ),
                child: const Text(
                  'WHY RESUMEFORGE?',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF4F46E5),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                'ResumeForge vs Traditional Builders',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 14),

              // Subtitle
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Text(
                  'Most online templates look pretty to the human eye but get discarded by recruiting software. See how ResumeForge guarantees parseability.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Table Container
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF131B2E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.25)
                          : const Color(0xFF0F172A).withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 760),
                      child: DataTable(
                        columnSpacing: 24,
                        horizontalMargin: 24,
                        headingRowHeight: 58,
                        dataRowMinHeight: 60,
                        dataRowMaxHeight: 70,
                        headingRowColor: WidgetStateProperty.all(
                          isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        ),
                        columns: [
                          const DataColumn(
                            label: Text(
                              'Feature / Capability',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    '⚡ ResumeForge',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const DataColumn(
                            label: Text(
                              'Canva / Word / Generic Editors',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                        ],
                        rows: comparisonItems.map((item) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  item.feature,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: Color(0xFF10B981),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        item.resumeForge,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: isDark
                                              ? const Color(0xFFE2E8F0)
                                              : const Color(0xFF1E293B),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.cancel_rounded,
                                      color: Color(0xFFEF4444),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        item.traditional,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isDark
                                              ? const Color(0xFF94A3B8)
                                              : const Color(0xFF64748B),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComparisonRow {
  final String feature;
  final String resumeForge;
  final String traditional;

  _ComparisonRow({
    required this.feature,
    required this.resumeForge,
    required this.traditional,
  });
}
