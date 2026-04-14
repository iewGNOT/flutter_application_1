import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routing/app_route.dart';
import '../../../../app/widgets/app_async_value_view.dart';
import '../../../../app/widgets/app_section_card.dart';
import '../../../../app/widgets/app_section_header.dart';
import '../../../../app/widgets/app_status_banner.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/dashboard_summary_card.dart';

final class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(dashboardControllerProvider);
    final stateAsync = ref.watch(dashboardViewStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LifeGacha'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: controller.refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: AppAsyncValueView<DashboardViewState>(
        value: stateAsync,
        fallbackErrorMessage: 'The dashboard could not be loaded.',
        onRetry: controller.refresh,
        builder: (context, state) => RefreshIndicator(
          onRefresh: () async {
            controller.refresh();
            await ref
                .read(dashboardViewStateProvider.future)
                .catchError((_) => controller.placeholderState());
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              _DashboardHeroCard(state: state),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: DashboardSummaryCard(
                      title: 'Active tasks',
                      value: '${state.activeTaskCount}',
                      subtitle: 'Ready for focus runs',
                      icon: Icons.checklist_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DashboardSummaryCard(
                      title: 'Available rewards',
                      value: '${state.availableRewardCount}',
                      subtitle: 'In the gacha pool',
                      icon: Icons.redeem_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              AppSectionHeader(
                title: 'Jump back in',
                subtitle:
                    'The six core destinations stay one tap away, with focus and rewards kept visible from anywhere.',
              ),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.05,
                children: [
                  _DashboardNavCard(
                    label: 'Tasks',
                    description: 'Create, edit, and complete tasks.',
                    icon: Icons.checklist_rounded,
                    onPressed: () => _goTo(context, AppRoute.tasks.path),
                  ),
                  _DashboardNavCard(
                    label: 'Focus',
                    description: 'Run the current session safely.',
                    icon: Icons.timer_rounded,
                    onPressed: () => _goTo(context, AppRoute.focusSession.path),
                  ),
                  _DashboardNavCard(
                    label: 'Gacha',
                    description: 'Spend points on reward draws.',
                    icon: Icons.casino_rounded,
                    onPressed: () => _goTo(context, AppRoute.gacha.path),
                  ),
                  _DashboardNavCard(
                    label: 'Rewards',
                    description: 'Manage the draw pool.',
                    icon: Icons.card_giftcard_rounded,
                    onPressed: () => _goTo(context, AppRoute.rewardCards.path),
                  ),
                  _DashboardNavCard(
                    label: 'Profile',
                    description: 'Inspect stats and growth.',
                    icon: Icons.person_rounded,
                    onPressed: () => _goTo(context, AppRoute.profileStats.path),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _DashboardHeroCard extends StatelessWidget {
  const _DashboardHeroCard({required this.state});

  final DashboardViewState state;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(
            eyebrow: 'Dashboard',
            title: 'Keep your momentum visible',
            subtitle:
                'A calm view of today\'s points, streak, and the next place to continue.',
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${state.focusPointsBalance}',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Current balance',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: colorScheme.primary,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                avatar: const Icon(Icons.local_fire_department_rounded),
                label: Text('${state.dailyStreak} day streak'),
              ),
              Chip(
                avatar: const Icon(Icons.timer_rounded),
                label: Text('${state.activeTaskCount} active tasks'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppStatusBanner(
            tone: AppStatusBannerTone.info,
            title: 'Productivity-first loop',
            message:
                'Finish tasks, complete focus runs, collect rewards, then spend points with intention.',
          ),
        ],
      ),
    );
  }
}

final class _DashboardNavCard extends StatelessWidget {
  const _DashboardNavCard({
    required this.label,
    required this.description,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final String description;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Icon(icon, color: colorScheme.primary),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _goTo(BuildContext context, String path) {
  final router = GoRouter.maybeOf(context);
  if (router != null) {
    router.go(path);
  }
}
