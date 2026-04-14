import 'package:flutter/material.dart';

enum AppStatusBannerTone { info, success, warning, error }

final class AppStatusBanner extends StatelessWidget {
  const AppStatusBanner({
    super.key,
    required this.message,
    this.title,
    this.tone = AppStatusBannerTone.info,
    this.icon,
    this.action,
  });

  final String message;
  final String? title;
  final AppStatusBannerTone tone;
  final IconData? icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accent = switch (tone) {
      AppStatusBannerTone.info => colorScheme.primary,
      AppStatusBannerTone.success => const Color(0xFF2E8B57),
      AppStatusBannerTone.warning => colorScheme.tertiary,
      AppStatusBannerTone.error => colorScheme.error,
    };
    final background = Color.alphaBlend(
      accent.withValues(
        alpha: theme.brightness == Brightness.dark ? 0.18 : 0.10,
      ),
      colorScheme.surfaceContainerLow,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accent.withValues(alpha: 0.24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: accent.withValues(
                  alpha: theme.brightness == Brightness.dark ? 0.2 : 0.14,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  icon ?? _defaultIcon(tone),
                  color: accent,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) ...[
                    Text(title!, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (action != null) ...[const SizedBox(height: 12), action!],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

IconData _defaultIcon(AppStatusBannerTone tone) {
  return switch (tone) {
    AppStatusBannerTone.info => Icons.info_outline_rounded,
    AppStatusBannerTone.success => Icons.check_circle_outline_rounded,
    AppStatusBannerTone.warning => Icons.auto_awesome_rounded,
    AppStatusBannerTone.error => Icons.error_outline_rounded,
  };
}
