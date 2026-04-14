import 'package:flutter/material.dart';

import '../../../../app/widgets/app_metric_tile.dart';
import '../../../../app/widgets/app_section_card.dart';
import '../../../../app/widgets/app_section_header.dart';
import '../../../../app/widgets/app_status_banner.dart';
import '../controllers/gacha_controller.dart';

final class GachaCostSummary extends StatelessWidget {
  const GachaCostSummary({super.key, required this.state});

  final GachaViewState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppSectionCard(
      color: Color.alphaBlend(
        colorScheme.primary.withValues(
          alpha: theme.brightness == Brightness.dark ? 0.16 : 0.08,
        ),
        colorScheme.surfaceContainerLowest,
      ),
      borderColor: colorScheme.primary.withValues(alpha: 0.18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(
            eyebrow: 'Gacha preview',
            title: 'Spend points with intention',
            subtitle:
                'Costs, pool size, and availability stay visible before you commit to a draw.',
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: AppMetricTile(
                  label: 'Balance',
                  value: '${state.currentBalance}',
                  helper: 'Focus points',
                  icon: Icons.auto_awesome_rounded,
                  accentColor: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppMetricTile(
                  label: 'Available rewards',
                  value: '${state.availableRewardCount}',
                  helper: 'Current pool',
                  icon: Icons.card_giftcard_rounded,
                  accentColor: colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppMetricTile(
                  label: 'Single draw',
                  value: '${state.singleDrawCost}',
                  helper: state.canSingleDraw ? 'Ready' : 'Unavailable',
                  icon: Icons.casino_rounded,
                  accentColor: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppMetricTile(
                  label: 'Ten draw',
                  value: '${state.tenDrawCost}',
                  helper: state.canTenDraw ? 'Ready' : 'Unavailable',
                  icon: Icons.auto_awesome_rounded,
                  accentColor: colorScheme.tertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppStatusBanner(
            title: _statusTitle(state),
            message: _statusMessage(state),
            tone: _statusTone(state),
            icon: _statusIcon(state),
          ),
        ],
      ),
    );
  }
}

AppStatusBannerTone _statusTone(GachaViewState state) {
  if (state.canTenDraw) {
    return AppStatusBannerTone.success;
  }
  if (state.canSingleDraw) {
    return AppStatusBannerTone.info;
  }
  return AppStatusBannerTone.warning;
}

String _statusTitle(GachaViewState state) {
  if (state.canTenDraw) {
    return 'Ten draw ready';
  }
  if (state.canSingleDraw) {
    return 'Single draw ready';
  }
  return 'Draw conditions not met';
}

String _statusMessage(GachaViewState state) {
  if (state.canTenDraw) {
    return 'You have enough points and at least ten eligible rewards, so both draw options are available.';
  }
  if (state.canSingleDraw) {
    return 'Single draw is available now. Ten draw still needs more points or a deeper reward pool.';
  }
  if (state.availableRewardCount == 0) {
    return 'Create reward cards first so the gacha pool has something to award.';
  }
  if (state.currentBalance < state.singleDrawCost) {
    return 'You need more focus points before any draw can begin.';
  }
  return 'Ten draw is still locked until at least ten rewards are available.';
}

IconData _statusIcon(GachaViewState state) {
  if (state.canTenDraw) {
    return Icons.workspace_premium_rounded;
  }
  if (state.canSingleDraw) {
    return Icons.casino_rounded;
  }
  return Icons.info_outline_rounded;
}
