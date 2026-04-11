import '../../../core/config/life_gacha_config.dart';
import '../../focus_sessions/domain/focus_session.dart';

final class PointsPolicy {
  const PointsPolicy(this.config);

  final EconomyConfig config;

  int pointsForValidFocusSession({required int plannedMinutes}) {
    if (plannedMinutes < config.focusUnitMinutes) {
      return 0;
    }

    return (plannedMinutes ~/ config.focusUnitMinutes) *
        config.pointsPerFocusUnit;
  }

  int pointsForCompletedSession(FocusSession session) {
    return pointsForValidFocusSession(plannedMinutes: session.plannedMinutes);
  }
}
