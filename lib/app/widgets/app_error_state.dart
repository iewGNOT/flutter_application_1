import 'package:flutter/material.dart';

import '../../core/error/app_failure.dart';
import '../../core/error/failure_message_mapper.dart';

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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
