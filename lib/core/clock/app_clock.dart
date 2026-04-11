abstract interface class AppClock {
  DateTime now();
  Stopwatch startStopwatch();
}

final class SystemClock implements AppClock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();

  @override
  Stopwatch startStopwatch() => Stopwatch()..start();
}
