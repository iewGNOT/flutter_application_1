import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/focus_sessions/presentation/pages/focus_session_page.dart';
import '../../features/gacha/presentation/pages/gacha_draw_page.dart';
import '../../features/profile_stats/presentation/pages/profile_stats_page.dart';
import '../../features/reward_cards/presentation/pages/reward_cards_page.dart';
import '../../features/tasks/presentation/pages/tasks_page.dart';
import 'app_route.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoute.dashboard.path,
    routes: [
      GoRoute(
        name: AppRoute.dashboard.name,
        path: AppRoute.dashboard.path,
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        name: AppRoute.tasks.name,
        path: AppRoute.tasks.path,
        builder: (context, state) => const TasksPage(),
      ),
      GoRoute(
        name: AppRoute.focusSession.name,
        path: AppRoute.focusSession.path,
        builder: (context, state) => const FocusSessionPage(),
      ),
      GoRoute(
        name: AppRoute.rewardCards.name,
        path: AppRoute.rewardCards.path,
        builder: (context, state) => const RewardCardsPage(),
      ),
      GoRoute(
        name: AppRoute.gacha.name,
        path: AppRoute.gacha.path,
        builder: (context, state) => const GachaDrawPage(),
      ),
      GoRoute(
        name: AppRoute.profileStats.name,
        path: AppRoute.profileStats.path,
        builder: (context, state) => const ProfileStatsPage(),
      ),
    ],
  );
});
