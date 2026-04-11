import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/widgets/app_error_state.dart';
import '../../../../app/widgets/app_loading_state.dart';
import '../../../achievements/presentation/controllers/achievements_controller.dart';
import '../../../character/presentation/controllers/character_controller.dart';
import '../controllers/profile_stats_controller.dart';
import '../widgets/achievement_list_section.dart';
import '../widgets/activity_history_section.dart';
import '../widgets/character_stats_card.dart';

final class ProfileStatsPage extends ConsumerWidget {
  const ProfileStatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(profileStatsViewStateProvider);
    final characterAsync = ref.watch(characterViewStateProvider);
    final achievementsAsync = ref.watch(achievementsViewStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile / Stats / Character'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => _triggerRefreshAll(ref),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(
        context: context,
        ref: ref,
        statsAsync: statsAsync,
        characterAsync: characterAsync,
        achievementsAsync: achievementsAsync,
      ),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required WidgetRef ref,
    required AsyncValue<ProfileStatsViewState> statsAsync,
    required AsyncValue<CharacterViewState> characterAsync,
    required AsyncValue<AchievementsViewState> achievementsAsync,
  }) {
    if (statsAsync.isLoading ||
        characterAsync.isLoading ||
        achievementsAsync.isLoading) {
      return const AppLoadingState();
    }

    final statsError = statsAsync.asError?.error;
    final characterError = characterAsync.asError?.error;
    final achievementsError = achievementsAsync.asError?.error;
    final error = statsError ?? characterError ?? achievementsError;
    if (error != null) {
      return AppErrorState.fromError(
        error: error,
        fallbackMessage: 'Profile data could not be loaded.',
        onRetry: () => _triggerRefreshAll(ref),
      );
    }

    final stats = statsAsync.asData!.value;
    final character = characterAsync.asData!.value;
    final achievements = achievementsAsync.asData!.value;

    return RefreshIndicator(
      onRefresh: () => _refreshAll(ref),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          _ProfileOverviewCard(stats: stats),
          const SizedBox(height: 16),
          CharacterStatsCard(character: character),
          const SizedBox(height: 16),
          AchievementListSection(achievements: achievements.achievements),
          const SizedBox(height: 16),
          ActivityHistorySection(items: stats.activityItems),
        ],
      ),
    );
  }
}

final class _ProfileOverviewCard extends StatelessWidget {
  const _ProfileOverviewCard({required this.stats});

  final ProfileStatsViewState stats;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _OverviewMetric(
                  label: 'Completed tasks',
                  value: '${stats.completedTasks}',
                ),
                _OverviewMetric(
                  label: 'Focus sessions',
                  value: '${stats.completedFocusSessions}',
                ),
                _OverviewMetric(
                  label: 'Accumulated points',
                  value: '${stats.accumulatedPoints}',
                ),
                _OverviewMetric(
                  label: 'Current / best streak',
                  value: '${stats.currentStreak} / ${stats.bestStreak}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({required this.label, required this.value});

  final String label;
  final String value;

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
            const Spacer(),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

void _triggerRefreshAll(WidgetRef ref) {
  ref.read(profileStatsControllerProvider).refresh();
  ref.read(characterControllerProvider).refresh();
  ref.read(achievementsControllerProvider).refresh();
}

Future<void> _refreshAll(WidgetRef ref) async {
  _triggerRefreshAll(ref);
  await Future.wait([
    ref.read(profileStatsViewStateProvider.future),
    ref.read(characterViewStateProvider.future),
    ref.read(achievementsViewStateProvider.future),
  ]);
}
