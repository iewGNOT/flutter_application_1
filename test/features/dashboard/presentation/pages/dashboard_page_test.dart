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

    expect(find.text('Current balance'), findsOneWidget);
    expect(find.text('240'), findsOneWidget);
    expect(find.text('5 day streak'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Jump back in'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Jump back in'), findsOneWidget);
    expect(find.text('Rewards'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
