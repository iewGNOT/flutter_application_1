import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routing/app_route.dart';
import '../controllers/dashboard_controller.dart';

final class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardControllerProvider).placeholderState();

    return Scaffold(
      appBar: AppBar(title: const Text('LifeGacha')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Focus points: ${state.focusPointsBalance}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text('Daily streak: ${state.dailyStreak}'),
          const SizedBox(height: 24),
          _DashboardNavButton(
            label: 'Tasks',
            onPressed: () => context.go(AppRoute.tasks.path),
          ),
          _DashboardNavButton(
            label: 'Focus Session',
            onPressed: () => context.go(AppRoute.focusSession.path),
          ),
          _DashboardNavButton(
            label: 'Gacha Draw',
            onPressed: () => context.go(AppRoute.gacha.path),
          ),
          _DashboardNavButton(
            label: 'Reward Cards',
            onPressed: () => context.go(AppRoute.rewardCards.path),
          ),
          _DashboardNavButton(
            label: 'Profile / Stats / Character',
            onPressed: () => context.go(AppRoute.profileStats.path),
          ),
        ],
      ),
    );
  }
}

final class _DashboardNavButton extends StatelessWidget {
  const _DashboardNavButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FilledButton(onPressed: onPressed, child: Text(label)),
    );
  }
}
