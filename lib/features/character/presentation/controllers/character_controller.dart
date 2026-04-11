import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/use_case_providers.dart';
import '../../domain/character_profile.dart';

final characterControllerProvider = Provider<CharacterController>((ref) {
  return CharacterController(ref);
});

final characterViewStateProvider = FutureProvider<CharacterViewState>((ref) {
  return ref.watch(characterControllerProvider).load();
});

final class CharacterController {
  CharacterController(this._ref);

  final Ref _ref;

  Future<CharacterViewState> load() async {
    final result = await _ref.read(getCharacterProfileUseCaseProvider).call();
    final profile = result.valueOrNull;
    if (profile == null) {
      throw result.failureOrNull!;
    }

    return CharacterViewState.fromProfile(profile);
  }

  void refresh() => _ref.invalidate(characterViewStateProvider);
}

final class CharacterViewState {
  const CharacterViewState({
    required this.id,
    required this.name,
    required this.level,
    required this.xp,
    required this.stamina,
    required this.intelligence,
    required this.discipline,
    required this.creativity,
  });

  factory CharacterViewState.fromProfile(CharacterProfile profile) {
    return CharacterViewState(
      id: profile.id,
      name: profile.name,
      level: profile.level,
      xp: profile.xp,
      stamina: profile.stamina,
      intelligence: profile.intelligence,
      discipline: profile.discipline,
      creativity: profile.creativity,
    );
  }

  final String id;
  final String? name;
  final int level;
  final int xp;
  final int stamina;
  final int intelligence;
  final int discipline;
  final int creativity;
}
