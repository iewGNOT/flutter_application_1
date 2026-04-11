import '../../../core/config/domain_enums.dart';
import '../../../core/clock/app_clock.dart';
import '../../../core/result/result.dart';
import '../domain/character_growth_policy.dart';
import '../domain/character_profile.dart';
import '../domain/character_repository.dart';

final class ApplyCharacterGrowthUseCase {
  const ApplyCharacterGrowthUseCase({
    required CharacterRepository characterRepository,
    required CharacterGrowthPolicy characterGrowthPolicy,
    required AppClock clock,
  }) : _characterRepository = characterRepository,
       _characterGrowthPolicy = characterGrowthPolicy,
       _clock = clock;

  final CharacterRepository _characterRepository;
  final CharacterGrowthPolicy _characterGrowthPolicy;
  final AppClock _clock;

  Future<Result<CharacterProfile>> call({
    required TaskCategory category,
  }) async {
    final profileResult = await _characterRepository.getProfile();
    final profile = profileResult.valueOrNull;
    if (profile == null) {
      return Failure(profileResult.failureOrNull!);
    }

    final updated = _characterGrowthPolicy.applyGrowth(
      profile: profile,
      category: category,
      updatedAt: _clock.now().toUtc(),
    );

    final saveResult = await _characterRepository.save(updated);
    if (saveResult.isFailure) {
      return Failure(saveResult.failureOrNull!);
    }

    return Success(updated);
  }
}

final class GetCharacterProfileUseCase {
  const GetCharacterProfileUseCase(this._characterRepository);

  final CharacterRepository _characterRepository;

  Future<Result<CharacterProfile>> call() => _characterRepository.getProfile();
}

final class WatchCharacterProfileUseCase {
  const WatchCharacterProfileUseCase(this._characterRepository);

  final CharacterRepository _characterRepository;

  Stream<CharacterProfile> call() => _characterRepository.watchProfile();
}
