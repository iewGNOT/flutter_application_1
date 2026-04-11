import '../../../core/result/result.dart';
import 'gacha_draw.dart';

abstract interface class GachaRepository {
  Stream<List<GachaDraw>> watchDrawHistory();
  Future<Result<Unit>> saveDraw(GachaDraw draw);
  Future<Result<List<GachaDraw>>> recentDraws({required int limit});
}
