import 'package:flutter/material.dart';

class AtsProgressIndicator extends StatelessWidget {
  final int score; // 0 - 100
  final double size;

  const AtsProgressIndicator({super.key, required this.score, this.size = 140});

  Color _getScoreColor() {
    if (score >= 80) return const Color(0xFF10B981); // Emerald Green
    if (score >= 60) return const Color(0xFFF59E0B); // Amber Warning
    return const Color(0xFFEF4444); // Red Danger
  }

  String _getScoreRating() {
    if (score >= 85) return 'Excellent';
    if (score >= 70) return 'Good';
    if (score >= 50) return 'Needs Work';
    return 'Poor';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getScoreColor();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 10,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$score',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: color,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '/ 100',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getScoreRating(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
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
