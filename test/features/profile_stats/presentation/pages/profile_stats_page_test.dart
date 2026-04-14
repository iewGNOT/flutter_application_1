import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_gacha/core/config/domain_enums.dart';
import 'package:life_gacha/features/achievements/domain/achievement.dart';
import 'package:life_gacha/features/achievements/presentation/controllers/achievements_controller.dart';
import 'package:life_gacha/features/character/presentation/controllers/character_controller.dart';
import 'package:life_gacha/features/profile_stats/domain/activity_history_summary.dart';
import 'package:life_gacha/features/profile_stats/presentation/controllers/profile_stats_controller.dart';
import 'package:life_gacha/features/profile_stats/presentation/pages/profile_stats_page.dart';

void main() {
  testWidgets(
    'profile page renders stats, character, achievements, and activity',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileStatsViewStateProvider.overrideWith(
              (ref) async => ProfileStatsViewState(
                completedTasks: 4,
                completedFocusSessions: 7,
                accumulatedPoints: 320,
                characterLevel: 4,
                currentStreak: 3,
                bestStreak: 5,
                activityItems: [
                  ActivityHistoryItem(
                    id: 'activity-1',
                    type: ActivityHistoryType.focusSession,
                    title: 'Completed 25 minute focus session',
                    occurredAt: DateTime.utc(2026, 4, 12, 8),
                  ),
                ],
              ),
            ),
            characterViewStateProvider.overrideWith(
              (ref) async => const CharacterViewState(
                id: 'char-1',
                name: 'Nova',
                level: 4,
                xp: 340,
                stamina: 5,
                intelligence: 4,
                discipline: 6,
                creativity: 3,
                skinState: null,
                bodyType: null,
              ),
            ),
            achievementsViewStateProvider.overrideWith(
              (ref) async => AchievementsViewState(
                achievements: [
                  Achievement(
                    id: 'achievement-1',
                    achievementType: AchievementType.completedFocusSessions,
                    progressCounter: 7,
                  ),
                ],
              ),
            ),
          ],
          child: const MaterialApp(home: ProfileStatsPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Progress overview'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Nova'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('Nova'), findsOneWidget);
      expect(find.textContaining('Level 4 - 340 XP'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Completed 25 minute focus session'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('Completed 25 minute focus session'), findsOneWidget);
      expect(find.text('Achievements'), findsOneWidget);
    },
  );
}
