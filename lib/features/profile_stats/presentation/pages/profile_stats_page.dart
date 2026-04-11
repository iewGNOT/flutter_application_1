import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/profile_stats_controller.dart';

final class ProfileStatsPage extends ConsumerWidget {
  const ProfileStatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileStatsControllerProvider).placeholderState();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile / Stats / Character')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Completed tasks: ${state.completedTasks}'),
          Text('Completed focus sessions: ${state.completedFocusSessions}'),
          Text('Accumulated points: ${state.accumulatedPoints}'),
          Text('Character level: ${state.characterLevel}'),
          const SizedBox(height: 16),
          const Text(
            'Character growth, medals, and activity history attach here.',
          ),
        ],
      ),
    );
  }
}
