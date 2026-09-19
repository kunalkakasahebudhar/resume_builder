import 'package:flutter/material.dart';

class AddItemButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AddItemButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
            style: BorderStyle.solid,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
          color: theme.colorScheme.primary.withValues(alpha: 0.04),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline_rounded,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
