import '../../../core/config/domain_enums.dart';
import '../../../core/result/result.dart';
import 'reward_card.dart';

abstract interface class RewardCardRepository {
  Stream<List<RewardCard>> watchRewardCards();
  Future<Result<List<RewardCard>>> listAll();
  Future<Result<List<RewardCard>>> listAvailable();
  Future<Result<List<RewardCard>>> listUnlocked();
  Future<Result<RewardCard>> findById(String id);
  Future<Result<Unit>> save(RewardCard card);
  Future<Result<List<RewardCard>>> findAvailableByRarity(RewardRarity rarity);
  Future<Result<int>> countAvailable();
}
