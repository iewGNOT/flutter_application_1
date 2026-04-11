import 'package:flutter/material.dart';

import '../controllers/gacha_controller.dart';

final class GachaCostSummary extends StatelessWidget {
  const GachaCostSummary({super.key, required this.state});

  final GachaViewState state;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gacha preview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _PreviewMetric(
                    label: 'Balance',
                    value: '${state.currentBalance}',
                    helper: 'Focus points',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PreviewMetric(
                    label: 'Available rewards',
                    value: '${state.availableRewardCount}',
                    helper: 'In current pool',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _PreviewMetric(
                    label: 'Single draw',
                    value: '${state.singleDrawCost}',
                    helper: state.canSingleDraw ? 'Ready' : 'Unavailable',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PreviewMetric(
                    label: 'Ten draw',
                    value: '${state.tenDrawCost}',
                    helper: state.canTenDraw ? 'Ready' : 'Unavailable',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final class _PreviewMetric extends StatelessWidget {
  const _PreviewMetric({
    required this.label,
    required this.value,
    required this.helper,
  });

  final String label;
  final String value;
  final String helper;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(helper, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
