import 'package:flutter/material.dart';

final class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_rounded,
    this.padding = EdgeInsets.zero,
    this.action,
  });

  final String title;
  final String? message;
  final IconData icon;
  final EdgeInsetsGeometry padding;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentMessage = message;

    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          if (currentMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              currentMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
          if (action != null) ...[const SizedBox(height: 16), action!],
        ],
      ),
    );
  }
}
