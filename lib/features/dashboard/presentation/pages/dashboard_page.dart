import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routing/app_route.dart';
import '../../../../app/widgets/app_async_value_view.dart';
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
            padding: const EdgeInsets.all(16),
            children: [
              _DashboardHeroCard(state: state),
              const SizedBox(height: 16),
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
              Text(
                'Quick actions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today at a glance', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              '${state.focusPointsBalance}',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Current balance',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
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
          ],
        ),
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: colorScheme.primary),
              const Spacer(),
              Text(label, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
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
