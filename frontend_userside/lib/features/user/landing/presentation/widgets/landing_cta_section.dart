import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingCtaSection extends StatelessWidget {
  const LandingCtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 56),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF3730A3),
                  Color(0xFF4F46E5),
                  Color(0xFF7C3AED),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.4),
                  blurRadius: 36,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt_rounded, color: Colors.amber, size: 16),
                      SizedBox(width: 6),
                      Text(
                        '100% Free To Build & Export',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Ready to Double Your Interview Callbacks?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: const Text(
                    'Create your high-scoring ATS resume with AI-tailored bullets, 11+ certified layouts, and live job description matching in minutes.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Color(0xFFE0E7FF),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                Wrap(
                  spacing: 16,
                  runSpacing: 14,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => context.push('/resumes/new'),
                      icon: const Icon(Icons.rocket_launch_rounded, size: 18),
                      label: const Text('Create Free Resume Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF4338CA),
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                        elevation: 0,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => context.push('/ats'),
                      icon: const Icon(Icons.speed_rounded, size: 18, color: Colors.white),
                      label: const Text('Test ATS Scanner'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 1.5),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
