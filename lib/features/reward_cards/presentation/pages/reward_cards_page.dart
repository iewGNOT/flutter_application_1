import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/reward_cards_controller.dart';

final class RewardCardsPage extends ConsumerWidget {
  const RewardCardsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rewardCardsControllerProvider).placeholderState();

    return Scaffold(
      appBar: AppBar(title: const Text('Reward Cards')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available rewards: ${state.availableCount}'),
            Text('Drawn rewards: ${state.drawnCount}'),
            const SizedBox(height: 16),
            const Text(
              'Reward creation and pre-draw content editing attach here.',
            ),
          ],
        ),
      ),
    );
  }
}
