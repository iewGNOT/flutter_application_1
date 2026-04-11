import 'dart:async';

import 'package:flutter/widgets.dart';

import 'app_lifecycle_event.dart';
import 'app_lifecycle_monitor.dart';

final class FlutterAppLifecycleMonitor extends WidgetsBindingObserver
    implements AppLifecycleMonitor {
  FlutterAppLifecycleMonitor()
    : _controller = StreamController<AppLifecycleEvent>.broadcast();

  final StreamController<AppLifecycleEvent> _controller;
  bool _started = false;

  @override
  Stream<AppLifecycleEvent> get events => _controller.stream;

  @override
  void start() {
    if (_started) {
      return;
    }

    WidgetsBinding.instance.addObserver(this);
    _started = true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final event = switch (state) {
      AppLifecycleState.resumed => AppLifecycleEvent.resumed,
      AppLifecycleState.inactive => AppLifecycleEvent.inactive,
      AppLifecycleState.paused => AppLifecycleEvent.paused,
      AppLifecycleState.detached => AppLifecycleEvent.detached,
      AppLifecycleState.hidden => AppLifecycleEvent.hidden,
    };

    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  @override
  void dispose() {
    if (_started) {
      WidgetsBinding.instance.removeObserver(this);
      _started = false;
    }

    if (!_controller.isClosed) {
      _controller.close();
    }
  }
}
