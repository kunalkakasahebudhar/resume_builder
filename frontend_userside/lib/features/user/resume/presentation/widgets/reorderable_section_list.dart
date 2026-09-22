import 'package:flutter/material.dart';

class ReorderableSectionList<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final void Function(int oldIndex, int newIndex) onReorder;
  final String emptyMessage;

  const ReorderableSectionList({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onReorder,
    this.emptyMessage = 'No items added yet.',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        alignment: Alignment.center,
        child: Text(
          emptyMessage,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      onReorder: onReorder,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          key: ValueKey(index),
          margin: const EdgeInsets.only(bottom: 12),
          child: itemBuilder(context, index, item),
        );
      },
    );
  }
}
