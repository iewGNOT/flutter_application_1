import 'dart:async';

import 'package:life_gacha/core/clock/app_clock.dart';
import 'package:life_gacha/core/config/domain_enums.dart';
import 'package:life_gacha/core/error/app_failure.dart';
import 'package:life_gacha/core/ids/id_generator.dart';
import 'package:life_gacha/core/persistence/unit_of_work.dart';
import 'package:life_gacha/core/random/random_int_source.dart';
import 'package:life_gacha/core/result/result.dart';
import 'package:life_gacha/features/achievements/domain/achievement.dart';
import 'package:life_gacha/features/achievements/domain/achievement_repository.dart';
import 'package:life_gacha/features/character/domain/character_profile.dart';
import 'package:life_gacha/features/character/domain/character_repository.dart';
import 'package:life_gacha/features/focus_sessions/application/focus_session_runtime_controller.dart';
import 'package:life_gacha/features/focus_sessions/domain/focus_session.dart';
import 'package:life_gacha/features/focus_sessions/domain/focus_session_repository.dart';
import 'package:life_gacha/features/gacha/domain/gacha_draw.dart';
import 'package:life_gacha/features/gacha/domain/gacha_repository.dart';
import 'package:life_gacha/features/profile_stats/domain/activity_history_summary.dart';
import 'package:life_gacha/features/profile_stats/domain/profile_stats_repository.dart';
import 'package:life_gacha/features/profile_stats/domain/profile_stats_snapshot.dart';
import 'package:life_gacha/features/profile_stats/domain/streak.dart';
import 'package:life_gacha/features/reward_cards/domain/reward_card.dart';
import 'package:life_gacha/features/reward_cards/domain/reward_card_repository.dart';
import 'package:life_gacha/features/tasks/domain/task.dart';
import 'package:life_gacha/features/tasks/domain/task_repository.dart';
import 'package:life_gacha/features/wallet/domain/wallet_ledger_entry.dart';
import 'package:life_gacha/features/wallet/domain/wallet_repository.dart';

final class FixedClock implements AppClock {
  FixedClock(this.currentTime);

  DateTime currentTime;

  @override
  DateTime now() => currentTime;

  @override
  Stopwatch startStopwatch() => Stopwatch()..start();
}

final class SequentialIdGenerator implements IdGenerator {
  SequentialIdGenerator({this.prefix = 'id'}) : _next = 0;

  final String prefix;
  int _next;

  @override
  String newId() => '$prefix-${_next++}';
}

final class ImmediateUnitOfWork implements UnitOfWork {
  @override
  Future<T> runInTransaction<T>(Future<T> Function() action) {
    return action();
  }
}

final class RecordingUnitOfWork implements UnitOfWork {
  int runInTransactionCalls = 0;

  @override
  Future<T> runInTransaction<T>(Future<T> Function() action) async {
    runInTransactionCalls += 1;
    return action();
  }
}

final class SequenceRandomIntSource implements RandomIntSource {
  SequenceRandomIntSource(List<int> values) : _values = [...values];

  final List<int> _values;

  @override
  int nextInt(int maxExclusive) {
    if (maxExclusive <= 0) {
      throw ArgumentError.value(
        maxExclusive,
        'maxExclusive',
        'Must be positive.',
      );
    }
    if (_values.isEmpty) {
      return 0;
    }

    final value = _values.removeAt(0);
    return value % maxExclusive;
  }
}

final class InMemoryTaskRepository implements TaskRepository {
  InMemoryTaskRepository([Iterable<Task> initialTasks = const []]) {
    _tasks.addAll(initialTasks);
  }

  final List<Task> _tasks = <Task>[];
  final StreamController<List<Task>> _controller =
      StreamController<List<Task>>.broadcast();

  @override
  Stream<List<Task>> watchActiveTasks() {
    return Stream<List<Task>>.multi((streamController) {
      streamController.add(_activeTasks());
      final subscription = _controller.stream.listen(streamController.add);
      streamController.onCancel = subscription.cancel;
    });
  }

  @override
  Future<Result<List<Task>>> listActiveTasks() async {
    return Success(_activeTasks());
  }

  @override
  Future<Result<Task>> findById(String id) async {
    final task = _tasks.where((candidate) => candidate.id == id).firstOrNull;
    return task == null ? const Failure(TaskNotFoundFailure()) : Success(task);
  }

  @override
  Future<Result<Unit>> save(Task task) async {
    final index = _tasks.indexWhere((candidate) => candidate.id == task.id);
    if (index == -1) {
      _tasks.add(task);
    } else {
      _tasks[index] = task;
    }
    _emit();
    return const Success(unit);
  }

  @override
  Future<Result<Unit>> archive(String id) async {
    final existing = await findById(id);
    final task = existing.valueOrNull;
    if (task == null) {
      return Failure(existing.failureOrNull!);
    }

    return save(
      task.copyWith(
        status: TaskStatus.archived,
        archivedAt: task.updatedAt,
        updatedAt: task.updatedAt,
      ),
    );
  }

  @override
  Future<Result<Unit>> delete(String id) async {
    _tasks.removeWhere((candidate) => candidate.id == id);
    _emit();
    return const Success(unit);
  }

  void dispose() {
    _controller.close();
  }

  List<Task> _activeTasks() {
    final tasks = _tasks
        .where((task) => task.status == TaskStatus.active)
        .toList(growable: false);
    tasks.sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
    return tasks;
  }

  void _emit() {
    _controller.add(_activeTasks());
  }
}

final class InMemoryWalletRepository implements WalletRepository {
  InMemoryWalletRepository([
    Iterable<WalletLedgerEntry> initialEntries = const [],
  ]) : _entries = [...initialEntries];

  final List<WalletLedgerEntry> _entries;
  final StreamController<int> _balanceController =
      StreamController<int>.broadcast();
  final StreamController<List<WalletLedgerEntry>> _ledgerController =
      StreamController<List<WalletLedgerEntry>>.broadcast();

  @override
  Stream<int> watchBalance() {
    return Stream<int>.multi((streamController) {
      streamController.add(_balance());
      final subscription = _balanceController.stream.listen(
        streamController.add,
      );
      streamController.onCancel = subscription.cancel;
    });
  }

  @override
  Stream<List<WalletLedgerEntry>> watchLedger() {
    return Stream<List<WalletLedgerEntry>>.multi((streamController) {
      streamController.add(_sortedEntries());
      final subscription = _ledgerController.stream.listen(
        streamController.add,
      );
      streamController.onCancel = subscription.cancel;
    });
  }

  @override
  Future<Result<int>> getBalance() async {
    return Success(_balance());
  }

  @override
  Future<Result<List<WalletLedgerEntry>>> recentEntries({
    required int limit,
  }) async {
    return Success(_sortedEntries().take(limit).toList(growable: false));
  }

  @override
  Future<Result<Unit>> appendLedgerEntry(WalletLedgerEntry entry) async {
    _entries.add(entry);
    _balanceController.add(_balance());
    _ledgerController.add(_sortedEntries());
    return const Success(unit);
  }

  void dispose() {
    _balanceController.close();
    _ledgerController.close();
  }

  int _balance() {
    return _entries.fold(0, (sum, entry) => sum + entry.deltaPoints);
  }

  List<WalletLedgerEntry> _sortedEntries() {
    final entries = [..._entries];
    entries.sort((left, right) => right.createdAt.compareTo(left.createdAt));
    return entries;
  }
}

final class InMemoryRewardCardRepository implements RewardCardRepository {
  InMemoryRewardCardRepository([Iterable<RewardCard> initialCards = const []]) {
    _cards.addAll(initialCards);
  }

  final List<RewardCard> _cards = <RewardCard>[];
  final StreamController<List<RewardCard>> _controller =
      StreamController<List<RewardCard>>.broadcast();

  @override
  Stream<List<RewardCard>> watchRewardCards() {
    return Stream<List<RewardCard>>.multi((streamController) {
      streamController.add(_sortedCards());
      final subscription = _controller.stream.listen(streamController.add);
      streamController.onCancel = subscription.cancel;
    });
  }

  @override
  Future<Result<List<RewardCard>>> listAll() async {
    return Success(_sortedCards());
  }

  @override
  Future<Result<List<RewardCard>>> listAvailable() async {
    return Success(
      _sortedCards()
          .where((card) => card.status == RewardCardStatus.available)
          .toList(growable: false),
    );
  }

  @override
  Future<Result<List<RewardCard>>> listUnlocked() async {
    return Success(
      _sortedCards()
          .where(
            (card) =>
                card.status == RewardCardStatus.drawn ||
                card.status == RewardCardStatus.redeemed,
          )
          .toList(growable: false),
    );
  }

  @override
  Future<Result<RewardCard>> findById(String id) async {
    final card = _cards.where((candidate) => candidate.id == id).firstOrNull;
    return card == null
        ? const Failure(RewardCardNotFoundFailure())
        : Success(card);
  }

  @override
  Future<Result<Unit>> save(RewardCard card) async {
    final index = _cards.indexWhere((candidate) => candidate.id == card.id);
    if (index == -1) {
      _cards.add(card);
    } else {
      _cards[index] = card;
    }
    _controller.add(_sortedCards());
    return const Success(unit);
  }

  @override
  Future<Result<List<RewardCard>>> findAvailableByRarity(
    RewardRarity rarity,
  ) async {
    return Success(
      _sortedCards()
          .where(
            (card) =>
                card.rarity == rarity &&
                card.status == RewardCardStatus.available,
          )
          .toList(growable: false),
    );
  }

  @override
  Future<Result<int>> countAvailable() async {
    return Success(
      _cards.where((card) => card.status == RewardCardStatus.available).length,
    );
  }

  void dispose() {
    _controller.close();
  }

  List<RewardCard> _sortedCards() {
    final cards = [..._cards];
    cards.sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
    return cards;
  }
}

final class InMemoryGachaRepository implements GachaRepository {
  InMemoryGachaRepository([Iterable<GachaDraw> initialDraws = const []])
    : _draws = [...initialDraws];

  final List<GachaDraw> _draws;
  final StreamController<List<GachaDraw>> _controller =
      StreamController<List<GachaDraw>>.broadcast();

  @override
  Stream<List<GachaDraw>> watchDrawHistory() {
    return Stream<List<GachaDraw>>.multi((streamController) {
      streamController.add(_sortedDraws());
      final subscription = _controller.stream.listen(streamController.add);
      streamController.onCancel = subscription.cancel;
    });
  }

  @override
  Future<Result<Unit>> saveDraw(GachaDraw draw) async {
    _draws.add(draw);
    _controller.add(_sortedDraws());
    return const Success(unit);
  }

  @override
  Future<Result<List<GachaDraw>>> recentDraws({required int limit}) async {
    return Success(_sortedDraws().take(limit).toList(growable: false));
  }

  void dispose() {
    _controller.close();
  }

  List<GachaDraw> _sortedDraws() {
    final draws = [..._draws];
    draws.sort((left, right) => right.createdAt.compareTo(left.createdAt));
    return draws;
  }
}

final class InMemoryCharacterRepository implements CharacterRepository {
  InMemoryCharacterRepository(this._profile);

  CharacterProfile _profile;
  final StreamController<CharacterProfile> _controller =
      StreamController<CharacterProfile>.broadcast();

  @override
  Stream<CharacterProfile> watchProfile() {
    return Stream<CharacterProfile>.multi((streamController) {
      streamController.add(_profile);
      final subscription = _controller.stream.listen(streamController.add);
      streamController.onCancel = subscription.cancel;
    });
  }

  @override
  Future<Result<CharacterProfile>> getProfile() async {
    return Success(_profile);
  }

  @override
  Future<Result<Unit>> save(CharacterProfile profile) async {
    _profile = profile;
    _controller.add(_profile);
    return const Success(unit);
  }

  void dispose() {
    _controller.close();
  }
}

final class InMemoryAchievementRepository implements AchievementRepository {
  InMemoryAchievementRepository([
    Iterable<Achievement> initialAchievements = const [],
  ]) : _achievements = [...initialAchievements];

  List<Achievement> _achievements;
  final StreamController<List<Achievement>> _controller =
      StreamController<List<Achievement>>.broadcast();

  @override
  Stream<List<Achievement>> watchAchievements() {
    return Stream<List<Achievement>>.multi((streamController) {
      streamController.add(_sortedAchievements());
      final subscription = _controller.stream.listen(streamController.add);
      streamController.onCancel = subscription.cancel;
    });
  }

  @override
  Future<Result<List<Achievement>>> listAchievements() async {
    return Success(_sortedAchievements());
  }

  @override
  Future<Result<Unit>> saveAll(List<Achievement> achievements) async {
    _achievements = [...achievements];
    _controller.add(_sortedAchievements());
    return const Success(unit);
  }

  void dispose() {
    _controller.close();
  }

  List<Achievement> _sortedAchievements() {
    final achievements = [..._achievements];
    achievements.sort(
      (left, right) =>
          left.achievementType.index.compareTo(right.achievementType.index),
    );
    return achievements;
  }
}

final class InMemoryProfileStatsRepository implements ProfileStatsRepository {
  InMemoryProfileStatsRepository({
    required this.snapshot,
    this.streak = const Streak(currentStreak: 0, bestStreak: 0),
    Iterable<ActivityHistoryItem> activityItems = const [],
  }) : _activityItems = [...activityItems];

  ProfileStatsSnapshot snapshot;
  Streak streak;
  final List<ActivityHistoryItem> _activityItems;
  final StreamController<ProfileStatsSnapshot> _snapshotController =
      StreamController<ProfileStatsSnapshot>.broadcast();
  final StreamController<Streak> _streakController =
      StreamController<Streak>.broadcast();

  @override
  Stream<ProfileStatsSnapshot> watchSnapshot() {
    return Stream<ProfileStatsSnapshot>.multi((streamController) {
      streamController.add(_currentSnapshot());
      final subscription = _snapshotController.stream.listen(
        streamController.add,
      );
      streamController.onCancel = subscription.cancel;
    });
  }

  @override
  Stream<Streak> watchStreak() {
    return Stream<Streak>.multi((streamController) {
      streamController.add(streak);
      final subscription = _streakController.stream.listen(
        streamController.add,
      );
      streamController.onCancel = subscription.cancel;
    });
  }

  @override
  Future<Result<ProfileStatsSnapshot>> getSnapshot() async {
    return Success(_currentSnapshot());
  }

  @override
  Future<Result<ActivityHistorySummary>> getActivityHistorySummary({
    int limit = 20,
  }) async {
    final items = [..._activityItems];
    items.sort((left, right) => right.occurredAt.compareTo(left.occurredAt));
    return Success(
      ActivityHistorySummary(items: items.take(limit).toList(growable: false)),
    );
  }

  @override
  Future<Result<Streak>> getStreak() async {
    return Success(streak);
  }

  @override
  Future<Result<Unit>> saveStreak(Streak updatedStreak) async {
    streak = updatedStreak;
    _streakController.add(streak);
    _snapshotController.add(_currentSnapshot());
    return const Success(unit);
  }

  @override
  Future<Result<int>> completedTaskCount() async {
    return Success(snapshot.completedTasks);
  }

  @override
  Future<Result<int>> completedFocusSessionCount() async {
    return Success(snapshot.completedFocusSessions);
  }

  void setSnapshot(ProfileStatsSnapshot value) {
    snapshot = value;
    _snapshotController.add(_currentSnapshot());
  }

  void setActivityItems(Iterable<ActivityHistoryItem> items) {
    _activityItems
      ..clear()
      ..addAll(items);
  }

  void dispose() {
    _snapshotController.close();
    _streakController.close();
  }

  ProfileStatsSnapshot _currentSnapshot() {
    return ProfileStatsSnapshot(
      completedTasks: snapshot.completedTasks,
      completedFocusSessions: snapshot.completedFocusSessions,
      accumulatedPoints: snapshot.accumulatedPoints,
      characterLevel: snapshot.characterLevel,
      streak: streak,
    );
  }
}

final class InMemoryFocusSessionRepository implements FocusSessionRepository {
  InMemoryFocusSessionRepository([
    Iterable<FocusSession> initialSessions = const [],
  ]) {
    _sessions.addAll(initialSessions);
  }

  final List<FocusSession> _sessions = <FocusSession>[];
  final StreamController<FocusSession?> _controller =
      StreamController<FocusSession?>.broadcast();

  @override
  Stream<FocusSession?> watchCurrentSession() {
    return Stream<FocusSession?>.multi((streamController) {
      streamController.add(_currentSession());
      final subscription = _controller.stream.listen(streamController.add);
      streamController.onCancel = subscription.cancel;
    });
  }

  @override
  Future<Result<FocusSession?>> getCurrentSession() async {
    return Success(_currentSession());
  }

  @override
  Future<Result<FocusSession>> findById(String id) async {
    final session = _sessions
        .where((candidate) => candidate.id == id)
        .firstOrNull;
    return session == null
        ? const Failure(FocusSessionNotFoundFailure())
        : Success(session);
  }

  @override
  Future<Result<Unit>> saveTransition(FocusSession session) async {
    final index = _sessions.indexWhere(
      (candidate) => candidate.id == session.id,
    );
    if (index == -1) {
      _sessions.add(session);
    } else {
      _sessions[index] = session;
    }
    _controller.add(_currentSession());
    return const Success(unit);
  }

  @override
  Future<Result<List<FocusSession>>> findRecoverableInProgressSessions() async {
    return Success(
      _sessions
          .where(
            (session) =>
                session.status == FocusSessionStatus.active ||
                session.status == FocusSessionStatus.paused,
          )
          .toList(growable: false),
    );
  }

  @override
  Future<Result<List<FocusSession>>> recentSessions({
    required int limit,
  }) async {
    final sessions = [..._sessions];
    sessions.sort((left, right) => right.startedAt.compareTo(left.startedAt));
    return Success(sessions.take(limit).toList(growable: false));
  }

  void dispose() {
    _controller.close();
  }

  FocusSession? _currentSession() {
    final currentSessions = _sessions
        .where(
          (session) =>
              session.status == FocusSessionStatus.active ||
              session.status == FocusSessionStatus.paused,
        )
        .toList(growable: false);
    if (currentSessions.isEmpty) {
      return null;
    }

    currentSessions.sort(
      (left, right) => right.startedAt.compareTo(left.startedAt),
    );
    return currentSessions.first;
  }
}

final class FakeFocusSessionRuntimeController
    implements FocusSessionRuntimeController {
  final StreamController<FocusSessionRuntimeState> _controller =
      StreamController<FocusSessionRuntimeState>.broadcast();

  Result<Unit> startResult = const Success(unit);
  Result<Unit> pauseResult = const Success(unit);
  Result<Unit> resumeResult = const Success(unit);
  Result<Unit> stopResult = const Success(unit);
  Result<Unit> completeResult = const Success(unit);
  Result<Unit> failResult = const Success(unit);

  bool ensureStartedCalled = false;
  String? lastStartedTaskId;
  int? lastStartedPlannedMinutes;
  int pauseCalls = 0;
  int resumeCalls = 0;
  int stopCalls = 0;
  int completeCalls = 0;
  int failCalls = 0;

  @override
  Stream<FocusSessionRuntimeState> get states => _controller.stream;

  @override
  Future<void> ensureStarted() async {
    ensureStartedCalled = true;
  }

  @override
  Future<Result<Unit>> start({
    required String? taskId,
    required int plannedMinutes,
  }) async {
    lastStartedTaskId = taskId;
    lastStartedPlannedMinutes = plannedMinutes;
    if (startResult.isSuccess) {
      _controller.add(FocusSessionRuntimeState.active);
    }
    return startResult;
  }

  @override
  Future<Result<Unit>> pause() async {
    pauseCalls += 1;
    if (pauseResult.isSuccess) {
      _controller.add(FocusSessionRuntimeState.paused);
    }
    return pauseResult;
  }

  @override
  Future<Result<Unit>> resume() async {
    resumeCalls += 1;
    if (resumeResult.isSuccess) {
      _controller.add(FocusSessionRuntimeState.active);
    }
    return resumeResult;
  }

  @override
  Future<Result<Unit>> stopEarly() async {
    stopCalls += 1;
    if (stopResult.isSuccess) {
      _controller.add(FocusSessionRuntimeState.cancelled);
    }
    return stopResult;
  }

  @override
  Future<Result<Unit>> completeByTimer() async {
    completeCalls += 1;
    if (completeResult.isSuccess) {
      _controller.add(FocusSessionRuntimeState.completed);
    }
    return completeResult;
  }

  @override
  Future<Result<Unit>> failForLifecycleViolation() async {
    failCalls += 1;
    if (failResult.isSuccess) {
      _controller.add(FocusSessionRuntimeState.failed);
    }
    return failResult;
  }

  @override
  void dispose() {
    _controller.close();
  }
}

extension<E> on Iterable<E> {
  E? get firstOrNull {
    final iterator = this.iterator;
    return iterator.moveNext() ? iterator.current : null;
  }
}
