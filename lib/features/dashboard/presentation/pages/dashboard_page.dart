import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/routing/app_route.dart';
import '../../../../app/widgets/app_async_value_view.dart';
import '../controllers/dashboard_controller.dart';

final class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(dashboardControllerProvider);
    final stateAsync = ref.watch(dashboardViewStateProvider);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: AppAsyncValueView<DashboardViewState>(
        value: stateAsync,
        fallbackErrorMessage: 'The dashboard could not be loaded.',
        onRetry: controller.refresh,
        builder: (context, state) => RefreshIndicator(
          onRefresh: () async {
            controller.refresh();
            await ref
                .read(dashboardViewStateProvider.future)
                .catchError((_) => controller.placeholderState());
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              _AuraBalanceCard(state: state),
              const SizedBox(height: 16),
              _StatsRow(state: state),
              const SizedBox(height: 28),
              _QuickRitualsSection(state: state),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      title: Text(
        'LifeGacha',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: colorScheme.primary,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.settings_outlined, color: colorScheme.primary),
          onPressed: () {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Settings coming soon')),
              );
          },
          tooltip: 'Settings',
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

// ── Hero card ────────────────────────────────────────────────────────────────

final class _AuraBalanceCard extends StatelessWidget {
  const _AuraBalanceCard({required this.state});

  final DashboardViewState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF92552C), Color(0xFF6C3710)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF92552C).withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AURA BALANCE',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.75),
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatPoints(state.focusPointsBalance),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'FP',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_fire_department_rounded,
                  color: Color(0xFFF9D377),
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  '${state.dailyStreak}-Day Streak',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatPoints(int points) {
    final s = points.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

// ── Stats row ────────────────────────────────────────────────────────────────

final class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.state});

  final DashboardViewState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatChip(
            icon: Icons.checklist_rounded,
            label: 'Active tasks',
            value: '${state.activeTaskCount}',
            color: Theme.of(context).colorScheme.secondary,
            onTap: () => context.go(AppRoute.tasks.path),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatChip(
            icon: Icons.card_giftcard_rounded,
            label: 'In the vault',
            value: '${state.availableRewardCount}',
            color: Theme.of(context).colorScheme.tertiary,
            onTap: () => context.go(AppRoute.rewardCards.path),
          ),
        ),
      ],
    );
  }
}

final class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}

// ── Quick Rituals ─────────────────────────────────────────────────────────────

final class _QuickRitualsSection extends StatelessWidget {
  const _QuickRitualsSection({required this.state});

  final DashboardViewState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Rituals',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.25,
          children: const [
            _RitualTile(
              label: 'Tasks',
              description: 'Manage your quests',
              icon: Icons.assignment_outlined,
              route: AppRoute.tasks,
              bgColor: Color(0xFFF6F4EC),
              iconColor: Color(0xFF92552C),
            ),
            _RitualTile(
              label: 'Focus',
              description: 'Enter deep focus',
              icon: Icons.timer_outlined,
              route: AppRoute.focusSession,
              bgColor: Color(0xFFEEF5EF),
              iconColor: Color(0xFF546A59),
            ),
            _RitualTile(
              label: 'Gacha',
              description: 'Spend your aura',
              icon: Icons.auto_awesome_rounded,
              route: AppRoute.gacha,
              bgColor: Color(0xFFFDF8E7),
              iconColor: Color(0xFF7D600D),
            ),
            _RitualTile(
              label: 'Rewards',
              description: 'Your reward cards',
              icon: Icons.card_giftcard_outlined,
              route: AppRoute.rewardCards,
              bgColor: Color(0xFFF6F4EC),
              iconColor: Color(0xFF64655C),
            ),
          ],
        ),
      ],
    );
  }
}

final class _RitualTile extends StatelessWidget {
  const _RitualTile({
    required this.label,
    required this.description,
    required this.icon,
    required this.route,
    required this.bgColor,
    required this.iconColor,
  });

  final String label;
  final String description;
  final IconData icon;
  final AppRoute route;
  final Color bgColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.go(route.path),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const Spacer(),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

