import 'package:flutter/material.dart';

import '../../../../app/widgets/app_metric_tile.dart';
import '../../../../app/widgets/app_section_card.dart';
import '../../../../app/widgets/app_section_header.dart';
import '../../../character/presentation/controllers/character_controller.dart';

final class CharacterStatsCard extends StatelessWidget {
  const CharacterStatsCard({super.key, required this.character});

  final CharacterViewState character;

  @override
  Widget build(BuildContext context) {
    final xpIntoCurrentLevel = character.xp % 100;
    final progress = xpIntoCurrentLevel / 100;

    return AppSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(
            eyebrow: 'Character',
            title: character.name ?? 'Unnamed adventurer',
            subtitle:
                'Level ${character.level} - ${character.xp} XP accumulated across completed work.',
          ),
          const SizedBox(height: 18),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppMetricTile(
                          label: 'Level',
                          value: '${character.level}',
                          helper: 'Current progression tier',
                          icon: Icons.workspace_premium_rounded,
                          accentColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppMetricTile(
                          label: 'Total XP',
                          value: '${character.xp}',
                          helper: '$xpIntoCurrentLevel / 100 to next level',
                          icon: Icons.bolt_rounded,
                          accentColor: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      value: progress,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.18,
            children: [
              _AttributeTile(
                label: 'Stamina',
                value: character.stamina,
                icon: Icons.favorite_border_rounded,
                color: const Color(0xFF2E8B57),
              ),
              _AttributeTile(
                label: 'Intelligence',
                value: character.intelligence,
                icon: Icons.school_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              _AttributeTile(
                label: 'Discipline',
                value: character.discipline,
                icon: Icons.shield_moon_outlined,
                color: Theme.of(context).colorScheme.secondary,
              ),
              _AttributeTile(
                label: 'Creativity',
                value: character.creativity,
                icon: Icons.palette_outlined,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ],
          ),
          const SizedBox(height: 18),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cosmetic state',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Skin: ${character.skinState ?? 'Not set'}\nBody: ${character.bodyType ?? 'Not set'}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _AttributeTile extends StatelessWidget {
  const _AttributeTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final int value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppMetricTile(
      label: label,
      value: '$value',
      helper: 'Current attribute',
      icon: icon,
      accentColor: color,
    );
  }
}
