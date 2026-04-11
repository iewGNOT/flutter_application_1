abstract interface class AnalyticsPort {
  void track(String eventName, {Map<String, Object?> properties});
}

final class NoopAnalyticsPort implements AnalyticsPort {
  const NoopAnalyticsPort();

  @override
  void track(String eventName, {Map<String, Object?> properties = const {}}) {}
}
