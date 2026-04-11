import '../../../core/clock/app_clock.dart';
import '../../../core/config/domain_enums.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/ids/id_generator.dart';
import '../../../core/persistence/unit_of_work.dart';
import '../../../core/result/result.dart';
import '../../achievements/application/achievement_use_cases.dart';
import '../../character/application/character_use_cases.dart';
import '../domain/task.dart';
import '../domain/task_repository.dart';

final class CreateTaskUseCase {
  const CreateTaskUseCase({
    required TaskRepository taskRepository,
    required IdGenerator idGenerator,
    required AppClock clock,
  }) : _taskRepository = taskRepository,
       _idGenerator = idGenerator,
       _clock = clock;

  final TaskRepository _taskRepository;
  final IdGenerator _idGenerator;
  final AppClock _clock;

  Future<Result<Task>> call({
    required String title,
    required TaskCategory category,
  }) async {
    final now = _clock.now().toUtc();
    final task = Task(
      id: _idGenerator.newId(),
      title: title.trim(),
      category: category,
      status: TaskStatus.active,
      createdAt: now,
      updatedAt: now,
    );

    final saveResult = await _taskRepository.save(task);
    if (saveResult.isFailure) {
      return Failure(saveResult.failureOrNull!);
    }

    return Success(task);
  }
}

final class UpdateTaskUseCase {
  const UpdateTaskUseCase({
    required TaskRepository taskRepository,
    required AppClock clock,
  }) : _taskRepository = taskRepository,
       _clock = clock;

  final TaskRepository _taskRepository;
  final AppClock _clock;

  Future<Result<Task>> call({
    required String taskId,
    required String title,
    required TaskCategory category,
  }) async {
    final existingResult = await _taskRepository.findById(taskId);
    final existingTask = existingResult.valueOrNull;
    if (existingTask == null) {
      return Failure(existingResult.failureOrNull!);
    }
    if (existingTask.isArchived) {
      return const Failure(
        ValidationFailure('Archived tasks cannot be edited.'),
      );
    }

    final updatedTask = existingTask.copyWith(
      title: title.trim(),
      category: category,
      updatedAt: _clock.now().toUtc(),
    );

    final saveResult = await _taskRepository.save(updatedTask);
    if (saveResult.isFailure) {
      return Failure(saveResult.failureOrNull!);
    }

    return Success(updatedTask);
  }
}

final class DeleteTaskUseCase {
  const DeleteTaskUseCase(this._taskRepository);

  final TaskRepository _taskRepository;

  Future<Result<Unit>> call(String taskId) => _taskRepository.delete(taskId);
}

final class ListTasksUseCase {
  const ListTasksUseCase(this._taskRepository);

  final TaskRepository _taskRepository;

  Stream<List<Task>> call() => _taskRepository.watchActiveTasks();
}

final class CompleteTaskUseCase {
  const CompleteTaskUseCase({
    required TaskRepository taskRepository,
    required ApplyCharacterGrowthUseCase applyCharacterGrowthUseCase,
    required EvaluateAchievementsUseCase evaluateAchievementsUseCase,
    required UnitOfWork unitOfWork,
    required AppClock clock,
  }) : _taskRepository = taskRepository,
       _applyCharacterGrowthUseCase = applyCharacterGrowthUseCase,
       _evaluateAchievementsUseCase = evaluateAchievementsUseCase,
       _unitOfWork = unitOfWork,
       _clock = clock;

  final TaskRepository _taskRepository;
  final ApplyCharacterGrowthUseCase _applyCharacterGrowthUseCase;
  final EvaluateAchievementsUseCase _evaluateAchievementsUseCase;
  final UnitOfWork _unitOfWork;
  final AppClock _clock;

  Future<Result<Task>> call(String taskId) async {
    final existingResult = await _taskRepository.findById(taskId);
    final existingTask = existingResult.valueOrNull;
    if (existingTask == null) {
      return Failure(existingResult.failureOrNull!);
    }

    if (existingTask.isCompleted) {
      return Success(existingTask);
    }

    final now = _clock.now().toUtc();
    final completedTask = existingTask.copyWith(
      status: TaskStatus.completed,
      updatedAt: now,
    );

    return _unitOfWork.runInTransaction(() async {
      final saveResult = await _taskRepository.save(completedTask);
      if (saveResult.isFailure) {
        return Failure<Task>(saveResult.failureOrNull!);
      }

      final growthResult = await _applyCharacterGrowthUseCase.call(
        category: completedTask.category,
      );
      if (growthResult.isFailure) {
        return Failure<Task>(growthResult.failureOrNull!);
      }

      final achievementsResult = await _evaluateAchievementsUseCase.call(
        evaluatedAt: now,
      );
      if (achievementsResult.isFailure) {
        return Failure<Task>(achievementsResult.failureOrNull!);
      }

      return Success(completedTask);
    });
  }
}
