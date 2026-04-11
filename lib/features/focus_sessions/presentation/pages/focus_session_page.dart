import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/focus_session_controller.dart';

final class FocusSessionPage extends ConsumerWidget {
  const FocusSessionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(focusSessionControllerProvider).placeholderState();

    return Scaffold(
      appBar: AppBar(title: const Text('Focus Session')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Planned session: ${state.plannedMinutes} minutes'),
            const SizedBox(height: 8),
            Text('Pause used: ${state.pauseUsed ? 'yes' : 'no'}'),
            const SizedBox(height: 16),
            const Text(
              'Runtime controller, lifecycle observer, and persistence transitions attach here.',
            ),
          ],
        ),
      ),
    );
  }
}
