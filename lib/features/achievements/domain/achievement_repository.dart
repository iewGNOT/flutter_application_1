import '../../../core/result/result.dart';
import 'achievement.dart';

abstract interface class AchievementRepository {
  Stream<List<Achievement>> watchAchievements();
  Future<Result<List<Achievement>>> listAchievements();
  Future<Result<Unit>> saveAll(List<Achievement> achievements);
}
