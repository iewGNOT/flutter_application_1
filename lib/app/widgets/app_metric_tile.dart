import 'package:flutter/material.dart';

final class AppMetricTile extends StatelessWidget {
  const AppMetricTile({
    super.key,
    required this.label,
    required this.value,
    this.helper,
    this.icon,
    this.accentColor,
    this.backgroundColor,
    this.valueStyle,
  });

  final String label;
  final String value;
  final String? helper;
  final IconData? icon;
  final Color? accentColor;
  final Color? backgroundColor;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveAccent = accentColor ?? colorScheme.primary;
    final effectiveBackground =
        backgroundColor ??
        Color.alphaBlend(
          effectiveAccent.withValues(
            alpha: theme.brightness == Brightness.dark ? 0.18 : 0.08,
          ),
          colorScheme.surfaceContainerLow,
        );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: effectiveBackground,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: effectiveAccent.withValues(
            alpha: theme.brightness == Brightness.dark ? 0.32 : 0.14,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: effectiveAccent.withValues(
                    alpha: theme.brightness == Brightness.dark ? 0.16 : 0.12,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(icon, size: 18, color: effectiveAccent),
                ),
              ),
              const SizedBox(height: 14),
            ],
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style:
                  valueStyle ??
                  theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            if (helper != null) ...[
              const SizedBox(height: 6),
              Text(
                helper!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
