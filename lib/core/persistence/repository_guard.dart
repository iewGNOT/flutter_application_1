import 'package:sqlite3/sqlite3.dart';

import '../error/app_failure.dart';
import '../logging/app_logger.dart';
import '../result/result.dart';

typedef FailureMapper =
    AppFailure Function(Object error, StackTrace stackTrace);

Future<Result<T>> guardRepositoryCall<T>({
  required AppLogger logger,
  required Future<T> Function() action,
  FailureMapper? mapFailure,
  String operation = 'repository operation',
}) async {
  try {
    final value = await action();
    return Success(value);
  } on AppFailure catch (failure, stackTrace) {
    logger.warning(
      'Repository call failed during $operation.',
      error: failure,
      stackTrace: stackTrace,
    );
    return Failure(failure);
  } on ArgumentError catch (error, stackTrace) {
    logger.warning(
      'Validation error during $operation.',
      error: error,
      stackTrace: stackTrace,
    );
    return Failure(
      ValidationFailure(error.message?.toString() ?? 'Invalid data.'),
    );
  } on SqliteException catch (error, stackTrace) {
    logger.error(
      'SQLite failure during $operation.',
      error: error,
      stackTrace: stackTrace,
    );
    return Failure(
      mapFailure?.call(error, stackTrace) ??
          PersistenceFailure('Local database operation failed.'),
    );
  } catch (error, stackTrace) {
    logger.error(
      'Unexpected failure during $operation.',
      error: error,
      stackTrace: stackTrace,
    );
    return Failure(
      mapFailure?.call(error, stackTrace) ??
          PersistenceFailure('Unexpected local persistence failure.'),
    );
  }
}
