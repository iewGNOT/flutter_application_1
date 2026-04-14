import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/widgets/app_error_state.dart';
import '../../../../app/widgets/app_loading_state.dart';
import '../../../../app/widgets/app_metric_tile.dart';
import '../../../../app/widgets/app_section_card.dart';
import '../../../../app/widgets/app_section_header.dart';
import '../../../../app/widgets/app_status_banner.dart';
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
        title: const Text('Profile'),
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
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          _ProfileOverviewCard(stats: stats),
          const SizedBox(height: 18),
          CharacterStatsCard(character: character),
          const SizedBox(height: 18),
          AchievementListSection(achievements: achievements.achievements),
          const SizedBox(height: 18),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppSectionCard(
      color: Color.alphaBlend(
        colorScheme.primary.withValues(
          alpha: theme.brightness == Brightness.dark ? 0.14 : 0.07,
        ),
        colorScheme.surfaceContainerLowest,
      ),
      borderColor: colorScheme.primary.withValues(alpha: 0.18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(
            eyebrow: 'Progress overview',
            title: 'Track consistency over time',
            subtitle:
                'Your stats summarize recent momentum across tasks, focus, points, and streaks without turning the screen into an RPG dashboard.',
          ),
          const SizedBox(height: 18),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.08,
            children: [
              AppMetricTile(
                label: 'Completed tasks',
                value: '${stats.completedTasks}',
                helper: 'Finished tasks',
                icon: Icons.task_alt_rounded,
                accentColor: colorScheme.primary,
              ),
              AppMetricTile(
                label: 'Focus sessions',
                value: '${stats.completedFocusSessions}',
                helper: 'Completed runs',
                icon: Icons.timer_rounded,
                accentColor: colorScheme.secondary,
              ),
              AppMetricTile(
                label: 'Accumulated points',
                value: '${stats.accumulatedPoints}',
                helper: 'Earned overall',
                icon: Icons.auto_awesome_rounded,
                accentColor: colorScheme.tertiary,
              ),
              AppMetricTile(
                label: 'Current / best streak',
                value: '${stats.currentStreak} / ${stats.bestStreak}',
                helper: 'Days of consistency',
                icon: Icons.local_fire_department_rounded,
                accentColor: const Color(0xFFDA7A1A),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppStatusBanner(
            title: 'Consistency matters',
            message: stats.currentStreak == 0
                ? 'A new streak starts the next time you complete productive work today.'
                : 'You are on a ${stats.currentStreak}-day streak. Keep the loop going with one more meaningful action.',
            tone: stats.currentStreak == 0
                ? AppStatusBannerTone.info
                : AppStatusBannerTone.success,
            icon: Icons.local_fire_department_rounded,
          ),
        ],
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
