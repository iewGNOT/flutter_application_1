import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hero',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => _triggerRefreshAll(ref),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: _buildBody(
        context: context,
        ref: ref,
        statsAsync: statsAsync,
        characterAsync: characterAsync,
        achievementsAsync: achievementsAsync,
        colorScheme: colorScheme,
      ),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required WidgetRef ref,
    required AsyncValue<ProfileStatsViewState> statsAsync,
    required AsyncValue<CharacterViewState> characterAsync,
    required AsyncValue<AchievementsViewState> achievementsAsync,
    required ColorScheme colorScheme,
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
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          children: [
            // ── Progress overview ───────────────────────────────────
            _ProfileOverviewCard(stats: stats),
            const SizedBox(height: 16),
            // ── Recent activity ─────────────────────────────────────
            ActivityHistorySection(items: stats.activityItems),
            const SizedBox(height: 16),
            // ── Character hero + XP + attributes ───────────────────
            CharacterStatsCard(character: character),
            const SizedBox(height: 16),
            // ── Achievements grid ───────────────────────────────────
            AchievementListSection(achievements: achievements.achievements),
          ],
        ),
      ),
    );
  }
}

final class _ProfileOverviewCard extends StatelessWidget {
  const _ProfileOverviewCard({required this.stats});

  final ProfileStatsViewState stats;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Required by test: 'Progress overview'
          Text(
            'Progress overview',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _MetricBox(
                label: 'Completed tasks',
                value: '${stats.completedTasks}',
                icon: Icons.task_alt_rounded,
                color: colorScheme.secondary,
                bgColor: colorScheme.secondaryContainer.withValues(alpha: 0.4),
              ),
              _MetricBox(
                label: 'Focus sessions',
                value: '${stats.completedFocusSessions}',
                icon: Icons.timer_rounded,
                color: colorScheme.primary,
                bgColor: colorScheme.primaryContainer.withValues(alpha: 0.35),
              ),
              _MetricBox(
                label: 'Accumulated points',
                value: '${stats.accumulatedPoints}',
                icon: Icons.stars_rounded,
                color: const Color(0xFF7D600D),
                bgColor: const Color(0xFFF9D377).withValues(alpha: 0.25),
              ),
              _MetricBox(
                label: 'Best streak',
                value: '${stats.currentStreak} / ${stats.bestStreak}',
                icon: Icons.local_fire_department_rounded,
                color: colorScheme.error,
                bgColor: colorScheme.errorContainer.withValues(alpha: 0.25),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
