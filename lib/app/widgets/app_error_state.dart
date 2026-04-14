import 'package:flutter/material.dart';

import '../../core/error/app_failure.dart';
import '../../core/error/failure_message_mapper.dart';
import 'app_section_card.dart';

final class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
    this.retryLabel = 'Try again',
  });

  factory AppErrorState.fromError({
    Key? key,
    required Object error,
    required String fallbackMessage,
    VoidCallback? onRetry,
    IconData icon = Icons.error_outline_rounded,
    String retryLabel = 'Try again',
  }) {
    return AppErrorState(
      key: key,
      message: switch (error) {
        AppFailure failure => FailureMessageMapper.toFriendlyMessage(failure),
        _ => fallbackMessage,
      },
      onRetry: onRetry,
      icon: icon,
      retryLabel: retryLabel,
    );
  }

  final String message;
  final VoidCallback? onRetry;
  final IconData icon;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: AppSectionCard(
          padding: const EdgeInsets.all(24),
          borderColor: colorScheme.error.withValues(alpha: 0.22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Icon(icon, size: 28, color: colorScheme.error),
                ),
              ),
              const SizedBox(height: 16),
              Text('Something went wrong', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(retryLabel),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
