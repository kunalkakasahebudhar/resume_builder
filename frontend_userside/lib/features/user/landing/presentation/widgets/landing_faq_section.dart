import 'package:flutter/material.dart';

class LandingFaqSection extends StatefulWidget {
  const LandingFaqSection({super.key});

  @override
  State<LandingFaqSection> createState() => _LandingFaqSectionState();
}

class _LandingFaqSectionState extends State<LandingFaqSection> {
  final List<_FaqItem> _faqs = [
    _FaqItem(
      question: 'Will this actually pass Workday, Taleo, and Greenhouse filters?',
      answer:
          'Yes. ATS rejection happens when resumes use columns, tables, text boxes, or non-standard fonts that parser bots cannot read. Every ResumeForge template uses single-column text streams and standard ISO section headers (Experience, Education, Skills) tested against standard parser specifications.',
    ),
    _FaqItem(
      question: 'Do I have to pay or enter a credit card to download my PDF?',
      answer:
          'No. You can build, customize, score, and download your high-resolution ATS-formatted PDF without paywalls or hidden watermark traps.',
    ),
    _FaqItem(
      question: 'Can I match my resume against a specific job posting?',
      answer:
          'Yes. Paste the Job Description into the built-in JD Matcher. It instantly checks your tech stack and experience against the requirements, flags missing keywords, and shows you where to add them.',
    ),
    _FaqItem(
      question: 'Will I lose my entered data if I switch templates?',
      answer:
          'Not at all. Your resume data (experience, education, skills, achievements) is saved independently of the presentation template. You can switch between Harvard Classic, FAANG Engineer Pro, Modern Minimalist, and 1-Page Compact instantly with 1-click and full data preservation.',
    ),
    _FaqItem(
      question: 'How do the AI Cover Letter and Interview STAR tools work?',
      answer:
          'Our AI Career Suite generates role-tailored cover letters in seconds matched to your exact resume experience, and predicts technical and behavioral interview questions with structured Situation-Task-Action-Result (STAR) answer frameworks.',
    ),
  ];

  int? _expandedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      color: isDark ? const Color(0xFF070B14) : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 88, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
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
                  'FREQUENTLY ASKED QUESTIONS',
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
                'Got Questions? We Have Answers',
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
                constraints: const BoxConstraints(maxWidth: 640),
                child: Text(
                  'Everything you need to know about ATS scoring, single-column templates, AI tools, and free vector PDF exports.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Accordion List with 48px touch targets
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _faqs.length,
                separatorBuilder: (context, index) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final faq = _faqs[index];
                  final isExpanded = _expandedIndex == index;

                  return Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF131B2E) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isExpanded
                            ? const Color(0xFF4F46E5).withValues(alpha: 0.5)
                            : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                        width: isExpanded ? 1.5 : 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _expandedIndex = isExpanded ? null : index;
                          });
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      faq.question,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(
                                    isExpanded
                                        ? Icons.remove_circle_outline_rounded
                                        : Icons.add_circle_outline_rounded,
                                    color: isExpanded
                                        ? const Color(0xFF4F46E5)
                                        : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                    size: 20,
                                  ),
                                ],
                              ),
                              if (isExpanded) ...[
                                const SizedBox(height: 14),
                                Container(
                                  height: 1,
                                  color: isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFE2E8F0),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  faq.answer,
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.6,
                                    color: isDark
                                        ? const Color(0xFFCBD5E1)
                                        : const Color(0xFF475569),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqItem {
  final String question;
  final String answer;

  _FaqItem({required this.question, required this.answer});
}
