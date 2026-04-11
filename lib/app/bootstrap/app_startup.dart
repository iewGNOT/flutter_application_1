import '../../core/logging/app_logger.dart';
import '../../core/persistence/life_gacha_database.dart';
import '../../features/focus_sessions/application/focus_session_runtime_controller.dart';

final class AppStartup {
  const AppStartup({
    required LifeGachaDatabase database,
    required FocusSessionRuntimeController focusSessionRuntimeController,
    required AppLogger logger,
  }) : _database = database,
       _focusSessionRuntimeController = focusSessionRuntimeController,
       _logger = logger;

  final LifeGachaDatabase _database;
  final FocusSessionRuntimeController _focusSessionRuntimeController;
  final AppLogger _logger;

  Future<void> initialize() async {
    _logger.info('Initializing LifeGacha application services.');
    await _database.ensureReady();
    await _focusSessionRuntimeController.ensureStarted();
    _logger.info('LifeGacha application services are ready.');
  }
}
