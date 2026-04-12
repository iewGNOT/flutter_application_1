import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_route.dart';

final class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static const _destinations = <_Destination>[
    _Destination(
      route: AppRoute.dashboard,
      label: 'Home',
      icon: Icons.home_rounded,
    ),
    _Destination(
      route: AppRoute.tasks,
      label: 'Tasks',
      icon: Icons.checklist_rounded,
    ),
    _Destination(
      route: AppRoute.focusSession,
      label: 'Focus',
      icon: Icons.timer_rounded,
    ),
    _Destination(
      route: AppRoute.gacha,
      label: 'Gacha',
      icon: Icons.casino_rounded,
    ),
    _Destination(
      route: AppRoute.rewardCards,
      label: 'Rewards',
      icon: Icons.card_giftcard_rounded,
    ),
    _Destination(
      route: AppRoute.profileStats,
      label: 'Profile',
      icon: Icons.person_rounded,
    ),
  ];

  int _selectedIndex(String location) {
    for (var i = 0; i < _destinations.length; i++) {
      if (location == _destinations[i].route.path) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _selectedIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          context.go(_destinations[index].route.path);
        },
        destinations: _destinations
            .map(
              (d) => NavigationDestination(
                icon: Icon(d.icon),
                label: d.label,
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

final class _Destination {
  const _Destination({
    required this.route,
    required this.label,
    required this.icon,
  });

  final AppRoute route;
  final String label;
  final IconData icon;
}
