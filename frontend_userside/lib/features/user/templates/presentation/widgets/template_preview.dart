import 'package:flutter/material.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';
import 'package:frontend_userside/features/user/templates/domain/entities/resume_template.dart';

class TemplatePreviewDialog extends StatelessWidget {
  final ResumeTemplate template;
  final VoidCallback onSelect;

  const TemplatePreviewDialog({
    super.key,
    required this.template,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: theme.colorScheme.surface,
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      template.category,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      const Center(
                        child: Text(
                          'ALEX MORGAN',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'San Francisco, CA • user@resumeforge.com • +1 (555) 234-5678',
                          style: TextStyle(fontSize: 10, color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: Colors.black54, thickness: 1),
                      const SizedBox(height: 8),
                      // Summary
                      const Text(
                        'PROFESSIONAL SUMMARY',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Experienced Software Engineer with a passion for designing scalable web architectures and leading developer teams.',
                        style: TextStyle(fontSize: 10, color: Colors.black87),
                      ),
                      const SizedBox(height: 12),
                      // Experience
                      const Text(
                        'EXPERIENCE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Senior Software Engineer',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '2022 - Present',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'CloudScale Technologies - San Francisco, CA',
                        style: TextStyle(
                          fontSize: 9,
                          fontStyle: FontStyle.italic,
                          color: Colors.black87,
                        ),
                      ),
                      const Text(
                        '• Scaled distributed API services to 10M+ daily events.',
                        style: TextStyle(fontSize: 9, color: Colors.black87),
                      ),
                      const SizedBox(height: 12),
                      // Education
                      const Text(
                        'EDUCATION',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'B.S. in Computer Science',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '2016 - 2020',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'UC Berkeley, GPA: 3.85',
                        style: TextStyle(fontSize: 9, color: Colors.black87),
                      ),
                      const SizedBox(height: 12),
                      // Skills
                      const Text(
                        'SKILLS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Go, Flutter, Dart, PostgreSQL, Docker, Kubernetes, REST APIs, System Design',
                        style: TextStyle(fontSize: 9, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  text: 'Close',
                  type: ButtonType.outline,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 12),
                AppButton(
                  text: 'Select Template',
                  onPressed: () {
                    Navigator.of(context).pop();
                    onSelect();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
