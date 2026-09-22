import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';

class AiBulletRewriterDialog extends StatefulWidget {
  final String initialText;
  final ValueChanged<String>? onApply;

  const AiBulletRewriterDialog({
    super.key,
    this.initialText = '',
    this.onApply,
  });

  static Future<String?> show(
    BuildContext context, {
    String initialText = '',
    ValueChanged<String>? onApply,
  }) {
    return showDialog<String>(
      context: context,
      builder: (ctx) => AiBulletRewriterDialog(
        initialText: initialText,
        onApply: onApply,
      ),
    );
  }

  @override
  State<AiBulletRewriterDialog> createState() => _AiBulletRewriterDialogState();
}

class _AiBulletRewriterDialogState extends State<AiBulletRewriterDialog> {
  late final TextEditingController _inputController;
  bool _isGenerating = false;
  String _selectedTone = 'Metrics & Impact';
  List<String> _suggestions = [];

  final List<String> _tones = [
    'Metrics & Impact',
    'Executive & Leadership',
    'FAANG Action Verbs',
    'Concise 1-Liner',
  ];

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(
      text: widget.initialText.isNotEmpty
          ? widget.initialText
          : 'Worked on frontend features and fixed performance bugs.',
    );
    _generateEnhancements();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _generateEnhancements() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isGenerating = true;
      _suggestions = [];
    });

    await Future.delayed(const Duration(milliseconds: 650));

    if (!mounted) return;

    if (_selectedTone == 'Metrics & Impact') {
      _suggestions = [
        'Architected high-throughput reactive modules, reducing API latency by 38% and accelerating user checkout conversion by 22%.',
        'Spearheaded performance optimization across 15+ core workflows, eliminating 99.4% of UI frame drops for 50K+ daily active users.',
        'Engineered scalable state caching architecture, slashing client bundle overhead by 30% and boosting Core Web Vitals score to 98/100.',
      ];
    } else if (_selectedTone == 'Executive & Leadership') {
      _suggestions = [
        'Orchestrated cross-functional engineering team of 8 to deliver enterprise platform milestone 3 weeks ahead of schedule.',
        'Championed architectural refactoring initiative, reducing technical debt and improving developer release velocity by 45%.',
        'Defined engineering roadmap and standard coding guidelines, mentoring 5 junior developers into high-performing contributors.',
      ];
    } else if (_selectedTone == 'FAANG Action Verbs') {
      _suggestions = [
        'Pioneered automated end-to-end testing pipeline, improving continuous deployment reliability from 89% to 99.8%.',
        'Spearheaded resilient micro-frontend synchronization protocol handling 2.5M daily event transactions with zero downtime.',
        'Overhauled distributed memory cache layer, mitigating concurrency race conditions and boosting server throughput by 3.2x.',
      ];
    } else {
      _suggestions = [
        'Optimized core application workflows, delivering a 40% speed boost across all client devices.',
        'Engineered responsive cross-platform UI components adopted across 12 product squads.',
        'Built automated CI/CD pipeline reducing build and deployment cycle time by 50%.',
      ];
    }

    setState(() {
      _isGenerating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 620, maxHeight: 720),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.auto_awesome_rounded,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Bullet Point Enhancer',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Text(
                              'Transform weak bullet points into high-impact ATS bullet points',
                              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Input Box
            Text(
              'ORIGINAL BULLET POINT / ROUGH IDEA',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _inputController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'e.g. Worked on Flutter app and created UI screens...',
                filled: true,
                fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Tone Selector Chips
            Text(
              'ENHANCEMENT STYLE / TONE',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _tones.map((tone) {
                  final isSelected = _selectedTone == tone;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(tone),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedTone = tone);
                          _generateEnhancements();
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 14),

            // Generated AI Suggestions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'HIGH-IMPACT ATS SUGGESTIONS',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: const Color(0xFF6366F1),
                  ),
                ),
                InkWell(
                  onTap: _generateEnhancements,
                  child: const Row(
                    children: [
                      Icon(Icons.refresh_rounded, size: 14, color: Color(0xFF6366F1)),
                      SizedBox(width: 4),
                      Text(
                        'Regenerate',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Expanded(
              child: _isGenerating
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(strokeWidth: 2.5),
                          SizedBox(height: 12),
                          Text('Generating ATS-quantified bullet points...',
                              style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = _suggestions[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Color(0xFF6366F1))),
                                  Expanded(
                                    child: Text(
                                      suggestion,
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        height: 1.45,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.copy_rounded, size: 16),
                                    tooltip: 'Copy to Clipboard',
                                    onPressed: () {
                                      Clipboard.setData(
                                          ClipboardData(text: suggestion));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Copied to clipboard!'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  AppButton(
                                    text: 'Use This Bullet',
                                    height: 28,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    onPressed: () {
                                      widget.onApply?.call(suggestion);
                                      Navigator.of(context).pop(suggestion);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
