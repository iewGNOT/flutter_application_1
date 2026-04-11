import 'app_lifecycle_event.dart';

abstract interface class AppLifecycleMonitor {
  Stream<AppLifecycleEvent> get events;
  void start();
  void dispose();
}
