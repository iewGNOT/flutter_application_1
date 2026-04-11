final class Streak {
  const Streak({
    required this.currentStreak,
    required this.bestStreak,
    this.lastQualifiedDate,
  }) : assert(currentStreak >= 0),
       assert(bestStreak >= 0);

  final int currentStreak;
  final int bestStreak;
  final DateTime? lastQualifiedDate;

  Streak copyWith({
    int? currentStreak,
    int? bestStreak,
    DateTime? lastQualifiedDate,
    bool clearLastQualifiedDate = false,
  }) {
    return Streak(
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastQualifiedDate: clearLastQualifiedDate
          ? null
          : lastQualifiedDate ?? this.lastQualifiedDate,
    );
  }
}
