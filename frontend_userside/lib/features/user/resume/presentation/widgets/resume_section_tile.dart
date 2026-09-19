import 'package:flutter/material.dart';

class ResumeSectionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final int itemCount;
  final bool isSelected;
  final VoidCallback onTap;

  const ResumeSectionTile({
    super.key,
    required this.icon,
    required this.title,
    this.itemCount = 0,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF4F46E5).withValues(alpha: isDark ? 0.2 : 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF4F46E5).withValues(alpha: 0.4)
              : Colors.transparent,
        ),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: Icon(
          icon,
          color: isSelected
              ? const Color(0xFF4F46E5)
              : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
          size: 19,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? (isDark ? Colors.white : const Color(0xFF4F46E5))
                : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155)),
          ),
        ),
        trailing: itemCount > 0
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF4F46E5)
                      : (isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$itemCount',
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isDark
                              ? const Color(0xFFCBD5E1)
                              : const Color(0xFF475569)),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            : (isSelected
                  ? Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4F46E5),
                        shape: BoxShape.circle,
                      ),
                    )
                  : null),
        onTap: onTap,
      ),
    );
  }
}
