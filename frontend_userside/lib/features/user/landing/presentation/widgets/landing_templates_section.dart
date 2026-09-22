import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingTemplatesSection extends StatefulWidget {
  const LandingTemplatesSection({super.key});

  @override
  State<LandingTemplatesSection> createState() => _LandingTemplatesSectionState();
}

class _LandingTemplatesSectionState extends State<LandingTemplatesSection> {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'All (11)',
    'Ivy League & Harvard',
    'Tech & FAANG',
    'Executive Leadership',
    'FinTech & Quant',
    '1-Page Compact',
  ];

  final List<_TemplateShowcaseItem> _templates = [
    _TemplateShowcaseItem(
      id: 'harvard',
      name: 'Harvard Classic ATS',
      category: 'Ivy League & Harvard',
      description: 'The golden standard single-column Ivy League format preferred by Fortune 500 recruiters.',
      color: const Color(0xFF1E293B),
      atsScore: '99/100',
      badge: 'TOP PICK',
    ),
    _TemplateShowcaseItem(
      id: 'tech-faang',
      name: 'FAANG Engineer Pro',
      category: 'Tech & FAANG',
      description: 'Optimized for software engineers, data scientists, and DevOps with tech stack highlight pill rows.',
      color: const Color(0xFF4F46E5),
      atsScore: '98/100',
      badge: 'POPULAR',
    ),
    _TemplateShowcaseItem(
      id: 'modern-slate',
      name: 'Modern Minimalist',
      category: 'Modern Clean',
      description: 'Crisp typography and subtle section divider lines for maximum human and machine readability.',
      color: const Color(0xFF0F766E),
      atsScore: '97/100',
      badge: 'CLEAN',
    ),
    _TemplateShowcaseItem(
      id: 'executive-lead',
      name: 'Executive Leadership',
      category: 'Executive Leadership',
      description: 'High-impact layout with executive summary spotlight and P&L metric showcases for Directors & VPs.',
      color: const Color(0xFF831843),
      atsScore: '96/100',
      badge: 'SENIOR',
    ),
    _TemplateShowcaseItem(
      id: 'quant-fintech',
      name: 'FinTech & Quant Analyst',
      category: 'FinTech & Quant',
      description: 'Compact high-density layout for investment bankers, quants, and risk analysts.',
      color: const Color(0xFF1E3A8A),
      atsScore: '98/100',
      badge: 'DENSE',
    ),
    _TemplateShowcaseItem(
      id: 'compact-onepage',
      name: '1-Page Strict Compact',
      category: '1-Page Compact',
      description: 'Engineered mathematically to fit comprehensive 3-5 year careers onto a single pristine page.',
      color: const Color(0xFF7C2D12),
      atsScore: '99/100',
      badge: '1-PAGE',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredTemplates = _selectedCategoryIndex == 0
        ? _templates
        : _templates.where((t) => t.category == _categories[_selectedCategoryIndex]).toList();

    return Container(
      width: double.infinity,
      color: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                ),
                child: const Text(
                  '11+ ATS-FRIENDLY TEMPLATES',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF10B981),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                'Recruiter-Approved ATS Layouts',
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
                constraints: const BoxConstraints(maxWidth: 720),
                child: Text(
                  'Every template conforms 100% to standard single-column text flows, ISO font metrics, and parseable section headings. No multi-column tables or graphics that confuse ATS algorithms.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Category Pills
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_categories.length, (index) {
                    final isSelected = _selectedCategoryIndex == index;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(_categories[index]),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedCategoryIndex = index;
                            });
                          }
                        },
                        selectedColor: const Color(0xFF4F46E5),
                        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                        labelStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? const Color(0xFF4F46E5)
                                : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 48),

              // Template Cards Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth > 960;
                  final isTablet = constraints.maxWidth > 640 && constraints.maxWidth <= 960;

                  final cardWidth = isDesktop
                      ? (constraints.maxWidth - 48) / 3
                      : isTablet
                          ? (constraints.maxWidth - 24) / 2
                          : constraints.maxWidth;

                  return Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: (filteredTemplates.isNotEmpty ? filteredTemplates : _templates)
                        .map((template) {
                      return SizedBox(
                        width: cardWidth,
                        child: _buildTemplateCard(context, template, isDark),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 48),

              // Bottom Browse All Button
              ElevatedButton.icon(
                onPressed: () => context.push('/templates'),
                icon: const Icon(Icons.palette_outlined, size: 18),
                label: const Text('Browse All 11+ Templates in User Portal'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateCard(BuildContext context, _TemplateShowcaseItem template, bool isDark) {
    return Container(
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
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visual Mock Preview Header
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              border: Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                ),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                // Simulated Resume Paper Sheet
                Center(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 90,
                          height: 8,
                          decoration: BoxDecoration(
                            color: template.color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 140,
                          height: 4,
                          color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 1,
                          color: template.color.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 60,
                          height: 5,
                          color: template.color,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          height: 4,
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                        const SizedBox(height: 3),
                        Container(
                          width: double.infinity,
                          height: 4,
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                      ],
                    ),
                  ),
                ),
                // Badge
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: template.color,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      template.badge,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Card Body
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        template.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'ATS ${template.atsScore}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  template.description,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.push('/resumes/new'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF4F46E5),
                      side: const BorderSide(color: Color(0xFF4F46E5)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: const Text('Use This Template'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplateShowcaseItem {
  final String id;
  final String name;
  final String category;
  final String description;
  final Color color;
  final String atsScore;
  final String badge;

  _TemplateShowcaseItem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.color,
    required this.atsScore,
    required this.badge,
  });
}
