import 'package:flutter/material.dart';

class LandingFaqSection extends StatefulWidget {
  const LandingFaqSection({super.key});

  @override
  State<LandingFaqSection> createState() => _LandingFaqSectionState();
}

class _LandingFaqSectionState extends State<LandingFaqSection> {
  final List<_FaqItem> _faqs = [
    _FaqItem(
      question: 'What is an ATS (Applicant Tracking System) and why does it matter?',
      answer:
          'Over 98% of Fortune 500 companies use ATS software (such as Workday, Greenhouse, Taleo, and Lever) to automatically scan, parse, and filter incoming resumes before a human recruiter ever sees them. If your resume contains complex graphics, multi-column tables, or non-standard headers, the parser will fail and automatically discard your application. ResumeForge ensures 100% parseable text structures.',
    ),
    _FaqItem(
      question: 'Are all 11+ templates guaranteed to be ATS compliant?',
      answer:
          'Yes! Every template in ResumeForge is strictly designed with single-column layouts, standard ISO section headings (Experience, Education, Skills, Projects), parseable dates, and recruiter-tested typography. No unreadable sidebars or broken table columns.',
    ),
    _FaqItem(
      question: 'Can I export pixel-perfect PDFs with no watermarks?',
      answer:
          'Absolutely. All resume exports generate standard vector PDF files with selectable, searchable text, crisp fonts, and zero watermarks. They are ready for immediate upload to company job portals.',
    ),
    _FaqItem(
      question: 'How does the Job Description (JD) Keyword Matcher work?',
      answer:
          'Simply paste any job description into the JD Matcher tool. Our engine parses the hard skills, frameworks, cloud tools, and qualifications required for that role and compares them with your resume. It gives you a match percentage and highlights missing keywords so you can weave them into your experience bullets.',
    ),
    _FaqItem(
      question: 'Will I lose my entered data if I switch templates?',
      answer:
          'Not at all! Your resume data (experience, education, skills, achievements) is saved independently of the presentation template. You can switch between Harvard Classic, FAANG Engineer Pro, Modern Minimalist, and 1-Page Compact instantly with 1-click and full data preservation.',
    ),
    _FaqItem(
      question: 'What are the AI Cover Letter and Interview Prep tools?',
      answer:
          'Our AI Career Supercharge suite includes an AI Cover Letter generator that writes role-tailored letters matching your resume experience in seconds, and an Interview STAR Kit that predicts behavioral and technical questions with structured Situation-Task-Action-Result answers.',
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
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
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
              Text(
                'Everything you need to know about ATS scoring, templates, AI tools, and PDF generation.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 48),

              // Accordion List
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
                          padding: const EdgeInsets.all(20),
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
