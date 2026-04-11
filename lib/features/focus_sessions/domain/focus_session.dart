import '../../../core/config/domain_enums.dart';

final class FocusSession {
  FocusSession({
    required this.id,
    required this.plannedMinutes,
    required this.startedAt,
    required this.status,
    required this.pauseCount,
    required this.appBackgroundViolation,
    required this.actualElapsedSeconds,
    required this.pointsAwarded,
    required this.lastStateChangedAt,
    this.taskId,
    this.endedAt,
  }) {
    if (id.trim().isEmpty) {
      throw ArgumentError.value(id, 'id', 'Focus session id cannot be blank.');
    }
    if (plannedMinutes <= 0) {
      throw ArgumentError.value(
        plannedMinutes,
        'plannedMinutes',
        'Must be positive.',
      );
    }
    if (pauseCount < 0) {
      throw ArgumentError.value(
        pauseCount,
        'pauseCount',
        'Cannot be negative.',
      );
    }
    if (actualElapsedSeconds < 0) {
      throw ArgumentError.value(
        actualElapsedSeconds,
        'actualElapsedSeconds',
        'Cannot be negative.',
      );
    }
    if (pointsAwarded < 0) {
      throw ArgumentError.value(
        pointsAwarded,
        'pointsAwarded',
        'Cannot be negative.',
      );
    }
    if (lastStateChangedAt.isBefore(startedAt)) {
      throw ArgumentError.value(
        lastStateChangedAt,
        'lastStateChangedAt',
        'Cannot predate startedAt.',
      );
    }
    if (endedAt != null && endedAt!.isBefore(startedAt)) {
      throw ArgumentError.value(
        endedAt,
        'endedAt',
        'Cannot predate startedAt.',
      );
    }
    if (status == FocusSessionStatus.completed && pointsAwarded <= 0) {
      throw ArgumentError.value(
        pointsAwarded,
        'pointsAwarded',
        'Completed session must award points.',
      );
    }
  }

  final String id;
  final String? taskId;
  final int plannedMinutes;
  final DateTime startedAt;
  final DateTime? endedAt;
  final FocusSessionStatus status;
  final int pauseCount;
  final bool appBackgroundViolation;
  final int actualElapsedSeconds;
  final int pointsAwarded;
  final DateTime lastStateChangedAt;

  bool get isInProgress =>
      status == FocusSessionStatus.active ||
      status == FocusSessionStatus.paused;

  bool get isTerminal =>
      status == FocusSessionStatus.completed ||
      status == FocusSessionStatus.failed ||
      status == FocusSessionStatus.cancelled;

  int get plannedSeconds => plannedMinutes * 60;

  FocusSession copyWith({
    String? id,
    String? taskId,
    bool clearTaskId = false,
    int? plannedMinutes,
    DateTime? startedAt,
    DateTime? endedAt,
    bool clearEndedAt = false,
    FocusSessionStatus? status,
    int? pauseCount,
    bool? appBackgroundViolation,
    int? actualElapsedSeconds,
    int? pointsAwarded,
    DateTime? lastStateChangedAt,
  }) {
    return FocusSession(
      id: id ?? this.id,
      taskId: clearTaskId ? null : taskId ?? this.taskId,
      plannedMinutes: plannedMinutes ?? this.plannedMinutes,
      startedAt: startedAt ?? this.startedAt,
      endedAt: clearEndedAt ? null : endedAt ?? this.endedAt,
      status: status ?? this.status,
      pauseCount: pauseCount ?? this.pauseCount,
      appBackgroundViolation:
          appBackgroundViolation ?? this.appBackgroundViolation,
      actualElapsedSeconds: actualElapsedSeconds ?? this.actualElapsedSeconds,
      pointsAwarded: pointsAwarded ?? this.pointsAwarded,
      lastStateChangedAt: lastStateChangedAt ?? this.lastStateChangedAt,
    );
  }
}
