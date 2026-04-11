import '../../../core/result/result.dart';
import 'focus_session.dart';

abstract interface class FocusSessionRepository {
  Stream<FocusSession?> watchCurrentSession();
  Future<Result<FocusSession?>> getCurrentSession();
  Future<Result<FocusSession>> findById(String id);
  Future<Result<Unit>> saveTransition(FocusSession session);
  Future<Result<List<FocusSession>>> findRecoverableInProgressSessions();
  Future<Result<List<FocusSession>>> recentSessions({required int limit});
}
