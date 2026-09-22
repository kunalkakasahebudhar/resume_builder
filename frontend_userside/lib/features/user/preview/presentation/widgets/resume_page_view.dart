import 'package:flutter/material.dart';
import 'package:frontend_userside/features/user/preview/presentation/widgets/resume_renderer.dart';
import 'package:frontend_userside/features/user/resume/domain/entities/resume.dart';

class ResumePageView extends StatelessWidget {
  final Resume resume;
  final double scale;
  final bool isHeatmapActive;

  const ResumePageView({
    super.key,
    required this.resume,
    this.scale = 0.9,
    this.isHeatmapActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Center(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ResumeRenderer(resume: resume, scale: scale),
            if (isHeatmapActive)
              Transform.scale(
                scale: scale,
                alignment: Alignment.topCenter,
                child: Container(
                  width: 794,
                  constraints: const BoxConstraints(minHeight: 1123),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Stack(
                    children: [
                      // Top Heatmap Legend Banner
                      Positioned(
                        top: 12,
                        left: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A).withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: const Color(0xFF6366F1).withValues(alpha: 0.6)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.remove_red_eye_rounded,
                                      color: Color(0xFFF43F5E), size: 16),
                                  SizedBox(width: 8),
                                  Text(
                                    'Recruiter 6-Second Eye-Tracking Heatmap Simulation',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  _HeatmapDot(color: Color(0xFFEF4444), label: '85% Gaze (High)'),
                                  SizedBox(width: 10),
                                  _HeatmapDot(color: Color(0xFFFBBF24), label: '50% (Medium)'),
                                  SizedBox(width: 10),
                                  _HeatmapDot(color: Color(0xFF38BDF8), label: '20% (Scan)'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Hotspot 1: Header / Name / Contact (High Attention)
                      Positioned(
                        top: 60,
                        left: 200,
                        child: _buildHeatGlow(width: 380, height: 110, color: const Color(0xFFEF4444)),
                      ),

                      // Hotspot 2: Recent Job Title & Company
                      Positioned(
                        top: 240,
                        left: 60,
                        child: _buildHeatGlow(width: 340, height: 90, color: const Color(0xFFEF4444)),
                      ),

                      // Hotspot 3: Metrics Numbers inside bullets
                      Positioned(
                        top: 330,
                        left: 220,
                        child: _buildHeatGlow(width: 260, height: 75, color: const Color(0xFFF59E0B)),
                      ),

                      // Hotspot 4: Skills Matrix
                      Positioned(
                        top: 480,
                        left: 60,
                        child: _buildHeatGlow(width: 420, height: 100, color: const Color(0xFFEF4444)),
                      ),

                      // Hotspot 5: Education & Degree
                      Positioned(
                        top: 650,
                        left: 60,
                        child: _buildHeatGlow(width: 300, height: 80, color: const Color(0xFF38BDF8)),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatGlow({required double width, required double height, required Color color}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(width / 2),
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.45),
            color.withValues(alpha: 0.25),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}

class _HeatmapDot extends StatelessWidget {
  final Color color;
  final String label;

  const _HeatmapDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 9.5),
        ),
      ],
    );
  }
}
