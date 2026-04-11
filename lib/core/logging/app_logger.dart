import 'dart:developer' as developer;

abstract interface class AppLogger {
  void debug(String message, {Object? error, StackTrace? stackTrace});
  void info(String message, {Object? error, StackTrace? stackTrace});
  void warning(String message, {Object? error, StackTrace? stackTrace});
  void error(String message, {Object? error, StackTrace? stackTrace});
}

final class DeveloperAppLogger implements AppLogger {
  const DeveloperAppLogger({this.name = 'LifeGacha'});

  final String name;

  @override
  void debug(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: name,
      level: 500,
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void info(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: name,
      level: 800,
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void warning(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: name,
      level: 900,
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: name,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

final class NoopAppLogger implements AppLogger {
  const NoopAppLogger();

  @override
  void debug(String message, {Object? error, StackTrace? stackTrace}) {}

  @override
  void info(String message, {Object? error, StackTrace? stackTrace}) {}

  @override
  void warning(String message, {Object? error, StackTrace? stackTrace}) {}

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {}
}
