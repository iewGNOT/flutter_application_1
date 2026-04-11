import '../../../core/result/result.dart';
import 'character_profile.dart';

abstract interface class CharacterRepository {
  Stream<CharacterProfile> watchProfile();
  Future<Result<CharacterProfile>> getProfile();
  Future<Result<Unit>> save(CharacterProfile profile);
}
