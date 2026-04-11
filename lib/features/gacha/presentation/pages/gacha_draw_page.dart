import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/gacha_controller.dart';

final class GachaDrawPage extends ConsumerWidget {
  const GachaDrawPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gachaControllerProvider).placeholderState();

    return Scaffold(
      appBar: AppBar(title: const Text('Gacha Draw')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: () {},
              child: Text('Single draw - ${state.singleDrawCost} points'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {},
              child: Text('Ten draw - ${state.tenDrawCost} points'),
            ),
            const SizedBox(height: 16),
            const Text('Animation hooks and draw execution attach here.'),
          ],
        ),
      ),
    );
  }
}
