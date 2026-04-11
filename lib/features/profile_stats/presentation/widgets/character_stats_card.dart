import 'package:flutter/material.dart';

import '../../../character/presentation/controllers/character_controller.dart';

final class CharacterStatsCard extends StatelessWidget {
  const CharacterStatsCard({super.key, required this.character});

  final CharacterViewState character;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              character.name ?? 'Unnamed adventurer',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text('Level ${character.level} - ${character.xp} XP'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _StatChip(label: 'Stamina', value: character.stamina),
                _StatChip(label: 'Intelligence', value: character.intelligence),
                _StatChip(label: 'Discipline', value: character.discipline),
                _StatChip(label: 'Creativity', value: character.creativity),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Cosmetic state',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'Skin: ${character.skinState ?? 'Not set'}\n'
              'Body: ${character.bodyType ?? 'Not set'}',
            ),
          ],
        ),
      ),
    );
  }
}

final class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text('$label: $value'));
  }
}
