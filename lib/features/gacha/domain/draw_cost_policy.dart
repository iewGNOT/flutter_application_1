import '../../../core/config/domain_enums.dart';
import '../../../core/config/life_gacha_config.dart';

final class DrawCostPolicy {
  const DrawCostPolicy(this.config);

  final EconomyConfig config;

  int costFor(GachaDrawType drawType) {
    return switch (drawType) {
      GachaDrawType.single => config.pointsPerDraw,
      GachaDrawType.ten => config.tenDrawCost,
    };
  }

  bool canAfford({
    required int currentBalance,
    required GachaDrawType drawType,
  }) {
    return currentBalance >= costFor(drawType);
  }
}
