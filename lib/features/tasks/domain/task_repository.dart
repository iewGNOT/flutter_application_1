import '../../../core/result/result.dart';
import 'task.dart';

abstract interface class TaskRepository {
  Stream<List<Task>> watchActiveTasks();
  Future<Result<List<Task>>> listActiveTasks();
  Future<Result<Task>> findById(String id);
  Future<Result<Unit>> save(Task task);
  Future<Result<Unit>> archive(String id);
  Future<Result<Unit>> delete(String id);
}
