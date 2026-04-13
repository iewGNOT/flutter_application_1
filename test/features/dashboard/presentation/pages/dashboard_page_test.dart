import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_gacha/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:life_gacha/features/dashboard/presentation/pages/dashboard_page.dart';

void main() {
  testWidgets('dashboard page renders summary cards and quick actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardViewStateProvider.overrideWith(
            (ref) async => const DashboardViewState(
              focusPointsBalance: 240,
              dailyStreak: 5,
              availableRewardCount: 12,
              activeTaskCount: 3,
            ),
          ),
        ],
        child: const MaterialApp(home: DashboardPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('AURA BALANCE'), findsOneWidget);
    expect(find.text('240'), findsOneWidget);
    expect(find.text('5-Day Streak'), findsOneWidget);
    expect(find.text('Quick Rituals'), findsOneWidget);
    expect(find.text('Tasks'), findsWidgets);
    expect(find.text('Focus'), findsOneWidget);
    expect(find.text('Gacha'), findsOneWidget);
    expect(find.text('Rewards'), findsWidgets);
  });
}
