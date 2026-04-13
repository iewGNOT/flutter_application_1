import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_route.dart';

final class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static const _destinations = <_Destination>[
    _Destination(
      route: AppRoute.dashboard,
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    _Destination(
      route: AppRoute.tasks,
      label: 'Tasks',
      icon: Icons.assignment_outlined,
      activeIcon: Icons.assignment_rounded,
    ),
    _Destination(
      route: AppRoute.focusSession,
      label: 'Focus',
      icon: Icons.timer_outlined,
      activeIcon: Icons.timer_rounded,
    ),
    _Destination(
      route: AppRoute.gacha,
      label: 'Gacha',
      icon: Icons.auto_awesome_outlined,
      activeIcon: Icons.auto_awesome_rounded,
    ),
    _Destination(
      route: AppRoute.rewardCards,
      label: 'Rewards',
      icon: Icons.card_giftcard_outlined,
      activeIcon: Icons.card_giftcard_rounded,
    ),
    _Destination(
      route: AppRoute.profileStats,
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  int _selectedIndex(String location) {
    for (var i = 0; i < _destinations.length; i++) {
      if (location == _destinations[i].route.path) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _selectedIndex(location);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.95),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_destinations.length, (i) {
                final dest = _destinations[i];
                final isSelected = i == selectedIndex;
                return _NavItem(
                  destination: dest,
                  isSelected: isSelected,
                  onTap: () => context.go(dest.route.path),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

final class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  final _Destination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF92552C), Color(0xFFCA7940)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? destination.activeIcon : destination.icon,
              size: 22,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                destination.label,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

final class _Destination {
  const _Destination({
    required this.route,
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final AppRoute route;
  final String label;
  final IconData icon;
  final IconData activeIcon;
}
