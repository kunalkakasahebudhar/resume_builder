import 'package:flutter/material.dart';

class WelcomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onCreateResume;
  final VoidCallback onSelectTemplate;

  const WelcomeHeader({
    super.key,
    required this.userName,
    required this.onCreateResume,
    required this.onSelectTemplate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3730A3), Color(0xFF4F46E5), Color(0xFF6366F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle background decorative circles
          Positioned(
            right: -30,
            top: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            right: 120,
            bottom: -50,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;

                final textContent = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                size: 13,
                                color: Color(0xFFFDE047),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'ATS Parser v2.4 Active',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Welcome back, $userName 👋',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 580),
                      child: Text(
                        'Craft, analyze, and fine-tune your ATS-optimized resumes with 100% keyword compliance and machine readability.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.88),
                          fontSize: 14,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                );

                final actionButtons = Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    ElevatedButton.icon(
                      onPressed: onSelectTemplate,
                      icon: const Icon(Icons.palette_outlined, size: 16),
                      label: const Text('Browse Templates'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: onCreateResume,
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Create Resume'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF4F46E5),
                        elevation: 3,
                        shadowColor: Colors.black.withValues(alpha: 0.25),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                );

                if (isWide) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: textContent),
                      const SizedBox(width: 24),
                      actionButtons,
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textContent,
                      const SizedBox(height: 20),
                      actionButtons,
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
